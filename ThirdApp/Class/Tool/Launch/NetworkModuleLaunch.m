//
//  NetworkModuleLaunch.m
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import "NetworkModuleLaunch.h"
#import "GHUserInfo.h"
#import <AFNetworking/AFNetworking.h>
#import "GHHudTip.h"
#import "ZYNetworkAccessibility.h"
#import "GHConfigDeviceManager.h"

@implementation NetworkModuleLaunch

+ (instancetype)shareLaunch {
    static NetworkModuleLaunch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


// MARK: Protocol
- (void)executeCommand {
    // MARK: ⚙ 网络请求组件基础配置
#ifdef DEBUG
    GHNetworkConfigure.share.generalServer = [NSUserDefaults.standardUserDefaults stringForKey:@"GHEnviValue"] ?: @"https://test-openiot.gosund.com";
#else
	GHNetworkConfigure.share.generalServer = @"https://openiot.gosund.com";
#endif
    GHNetworkConfigure.share.enableDebug = YES;
    GHNetworkConfigure.share.useCache = YES;
	
    GHNetworkConfigure.share.respondeSuccessKeys = @[@"err_code"];   /** 与后端约定的请求结果状态字段, 默认 code, status */
    GHNetworkConfigure.share.respondeHttpCodeKeys = @[@"http_code"];
    GHNetworkConfigure.share.respondeMsgKeys = @[@"msg"];       /** 与后端约定的请求结果消息字段集合, 默认 message, msg */
    GHNetworkConfigure.share.respondeDataKeys = @[@"data"];      /** 与后端约定的请求结果数据字段集合, 默认 data */
    GHNetworkConfigure.share.respondeSuccessCode = @"0";                  /** 与后端约定的请求成功code，默认为 200 */
    GHNetworkConfigure.share.respondeHttpCode = @"200";
	GHNetworkConfigure.share.startReachability = NO;
    GHNetworkConfigure.share.generalHeaders = @{
        @"platform":@"iphone",
		@"lang":[NSBundle.mainBundle objectForInfoDictionaryKey:@"GHLanguage"],
		@"appVersion":[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
		@"os":@"iOS",
		@"osSystem":[[UIDevice currentDevice] systemVersion]
    };
//    // 全局静态请求头参数设置
//    GPNetworkConfigure.shareInstance.generalHeaders = ({
//        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
//        [temp setValue:@"iOS" forKey:@"platform"];
//        [temp setValue:[NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
//        [temp setValue:@"App Store" forKey:@"channel"];
//        temp;
//    });
//
//
//    // 全局动态请求头参数设置，token，sign等
	GHNetworkConfigure.share.generalDynamicHeaders = ^NSDictionary<NSString *,NSString *> * _Nonnull(NSDictionary * _Nonnull parameters) {
        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:1];
		[temp setValue:GHUserInfo.share.Authorization forKey:@"Authorization"];
        return temp;
    };
	
	ASWeak(self);
	[GHNetworkReachabilityManager startNetworkReachability:^(GHNetworkStatus status) {
		weakself.upadteNetworkStatus(status);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			GHNetworkConfigure.share.startReachability = YES;
			[self initSystemNotify];
		});
	}];
	
	[[RACObserve(GHUserInfo.share, uid) ignore:nil] subscribeNext:^(id  _Nullable x) {
		GHNetworkConfigure.share.userToken = x;
		[GHNetworkCache resetCacheName:x];
	}];
	
	[ZYNetworkAccessibility setAlertEnable:NO];
	[ZYNetworkAccessibility setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
		NSLog(@"setStateDidUpdateNotifier > %zd", state);
		if (state == ZYNetworkRestricted || state == ZYNetworkUnknown) {
			[GHConfigDeviceManager share].isNetPermissOk = NO;
		}else{
			[GHConfigDeviceManager share].isNetPermissOk = YES;
		}
	}];
	[ZYNetworkAccessibility start];
//
//    // 全局动态公参
////    GPNetworkConfigure.shareInstance.generalDynamicParameters = ^NSDictionary<NSString *,id> * _Nonnull{
////        NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:2];
////        [temp setValue:@"506878" forKey:@"userId"];
////        [temp setValue:@"44bd15964b49474c94a6c5979c8e3318" forKey:@"userTypeId"];
////        return temp;
////    };
//
//    // 请求结果统一回调处理
//	GHNetworkConfigure.share.responseUnifiedCallBack = ^(id _Nonnull response) {
//        // MARK: 用户模块 token 过期 code为 230；单点登录code为231
//		if ([response isKindOfClass:NSClassFromString(@"NSError")]) {
//			if ([(NSError *)response code] == -1009) {
//				[GHHudTip showSuccessWithTips:NSLocalizedString(@"No network connection, please check the network", nil) imageName:@"pop_icon_nonetwork"];
//			}
//		}
//    };
}

- (void)stopMonitoring {
	[GHNetworkReachabilityManager stopMonitoring];
}

- (void)startMonitoring {
	[GHNetworkReachabilityManager startMonitoring];
}

- (void)logout {
	[GHNetworkModule.share clearCache:NO];
}

- (void)initSystemNotify {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
	});
}

- (void)applicationDidEnterBackgroundNotification {
	[self stopMonitoring];
}

- (void)applicationDidBecomeActiveNotification {
	[self startMonitoring];
}

- (void)applicationWillResignActiveNotification {
	[self stopMonitoring];
}

@end
