//
//  MQTTLaunch.m
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import "MQTTLaunch.h"
#import "GHUserInfo.h"
#import "GHCucoMQTTService.h"
#import "NSString+GHCategory.h"
#ifdef DEBUG
#import "GHHudTip.h"
#endif

@implementation MQTTLaunch

+ (instancetype)shareLaunch {
    static dispatch_once_t onceToken;
    static MQTTLaunch *mqttLaunch;
    dispatch_once(&onceToken, ^{
        mqttLaunch = MQTTLaunch.alloc.init;
    });
    return mqttLaunch;
}

- (void)executeCommand {
	//MQTT配置
	
	//同样的状态不刷新
	GHCucoMQTTService.share.isUpdateSameSmartOvenShadow = NO;
	
	[[RACObserve(self, networkStatus) skip:1] subscribeNext:^(id  _Nullable x) {
		GHCucoMQTTService.share.networkStatus = [x intValue];
	}];
	
	//MQTT控制的字典逻辑处理, 增加公共参数
	GHCucoMQTTService.share.generalDynamicDictValue = ^NSDictionary<NSString *,NSString *> *(NSDictionary *controlDict) {
		NSMutableDictionary *lastControlDict = controlDict.mutableCopy;
		NSUInteger timeStamp = (NSUInteger)([NSDate.date timeIntervalSince1970] * 1000);
		[lastControlDict setObject:[NSString stringWithFormat:@"A%ld", timeStamp] forKey:@"messageId"];
		[lastControlDict setObject:[@(timeStamp) description] forKey:@"timestamp"];
		return lastControlDict;
	};
	
	//MQTT登录
	RACSignal *mqttDictSignals = RACObserve(GHUserInfo.share, mqttDict);
	RACSignal *domainSignals = RACObserve(GHUserInfo.share, domain.mqttsUrl);
	[[[RACSignal combineLatest:@[mqttDictSignals, domainSignals]] filter:^BOOL(RACTuple * _Nullable value) {
		NSDictionary *mqttDict = value.first;
		NSString *mqttURL = value.second;
		if ([mqttDict count] > 0 && mqttURL.length > 0) {
			return YES;
		}
		return NO;
	}] subscribeNext:^(RACTuple * _Nullable x) {
		//MQTT断开之前的回调
		NSLog(@"-------------------> 我可以连接上MQTT了 <-----------------------");
		NSDictionary *mqttDict = x.first;
		NSString *mqttURL = x.second;
			
		NSArray *mqttURLArray = [mqttURL componentsSeparatedByString:@"."];
		
		GHMQTTModel *model = GHMQTTModel.alloc.init;
		model.sessionToken = mqttDict[@"session_token"];
		model.secret_key = mqttDict[@"secret_access_key"];
		model.access_key = mqttDict[@"access_key_id"];
		model.clientId = [NSString currUUID];
		
		NSUInteger currIndex = [mqttURLArray indexOfObject:@"amazonaws"];
		if (currIndex == NSNotFound) {
			currIndex = [mqttURLArray indexOfObject:@"iot"];
			if (currIndex == NSNotFound) {
				currIndex = 3;
			} else {
				currIndex = currIndex + 1;
			}
		} else {
			currIndex = currIndex - 1;
		}
		
		model.region = mqttURLArray[currIndex];
		model.end_point = mqttURL;
		GHCucoMQTTService.share.disconnectSmartOven = ^{
		};
		
		GHCucoMQTTService.share.connectSmartOvenSuccess = ^{
		};
		
		GHCucoMQTTService.share.reconnectSmartOven = ^{
			NSLog(@"重连之前需要的动作");
		};
		
		[GHCucoMQTTService.share connectMQTTServiceWithDevice:model];
	}];
}

- (void)logout {
	[GHCucoMQTTService.share disConnectMQTTService];
}

@end
