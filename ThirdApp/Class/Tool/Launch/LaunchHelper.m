//
//  LaunchHelper.m
//  MobileSoft
//
//  Created by Qincc on 2018/12/25.
//  Copyright © 2018 Qincc's Mac. All rights reserved.
//

#import "LaunchHelper.h"
#import <IQKeyboardManager.h>
#import "WindowLaunch.h"
#import "NetworkModuleLaunch.h"
#import "KeyboardLaunch.h"
#import "MQTTLaunch.h"
#import "GHUserInfo.h"
#import "GHNetworkRequestLaunch.h"
#import "ActivityLaunch.h"
#import <Bugly/Bugly.h>
#import "GHThirdKey.h"
#import "GHConfigDeviceManager.h"
#import "SocketLaunch.h"
#import "PushLaunch.h"
#import "GHBLEClient.h"

@interface LaunchHelper ()

@property (strong, nonatomic) NSArray *commands;

@end

@implementation LaunchHelper

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static LaunchHelper *helper;
    dispatch_once(&onceToken, ^{
        helper = LaunchHelper.alloc.init;
    });
    return helper;
}

// MARK: Appdelegate 初始化
- (void)launchWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions {
    
    // 前置参数初始化
    WindowLaunch.shareLaunch.options = launchOptions;
	PushLaunch.shareLaunch.options = launchOptions;
	
	[Bugly startWithAppId:GHBuglyAppID];
	
	[GHBLEClient share];
	
    self.commands = @[
        WindowLaunch.shareLaunch,
        NetworkModuleLaunch.shareLaunch,
        MQTTLaunch.shareLaunch,
        KeyboardLaunch.shareLaunch,
		GHNetworkRequestLaunch.shareLaunch,
		ActivityLaunch.shareLaunch,
		SocketLaunch.shareLaunch];
}

- (BOOL)application:(nonnull UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
	if ([ActivityLaunch.shareLaunch conformsToProtocol:NSProtocolFromString(@"LaunchCommand")]) {
		return [ActivityLaunch.shareLaunch application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
	}
	return NO;
}

// 推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	if ([PushLaunch.shareLaunch conformsToProtocol:NSProtocolFromString(@"LaunchCommand")]) {
		[PushLaunch.shareLaunch application:application didReceiveRemoteNotification:userInfo];
	}
}

// MARK: 启动协议执行方法
- (void)helperExecute {
    // MARK: ⚙ 其他组件基础配置
    [self.commands enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(LaunchCommand)]) [obj executeCommand];
    }];
	
	// 直接切换rootViewController
	[[[RACObserve(GHUserInfo.share, isLogin) skip:1] distinctUntilChanged] subscribeNext:^(NSNumber *_Nullable x) {
		if (![x boolValue]) {
			[NetworkModuleLaunch.shareLaunch logout];
			[MQTTLaunch.shareLaunch logout];
			
			//由于在个人设置中会切换区域和退出登录都会清空用户信息， 但是切换区域不会清空api_server
			[GHNetworkRequestLaunch.shareLaunch logout];
			[WindowLaunch.shareLaunch logout];
			[SocketLaunch.shareLaunch logout];
		} else {
			[WindowLaunch.shareLaunch updateRootViewController];
		}
	}];
	
	ASWeak(self);
	NetworkModuleLaunch.shareLaunch.upadteNetworkStatus = ^(GHNetworkStatus status) {
		NSLog(@"GHNetworkStatus = %lu", (unsigned long)status);
		weakself.networkStatus = status;
		[GHConfigDeviceManager share].networkStatus = status;
		[SocketLaunch.shareLaunch updateNetworkStatus:status];
		MQTTLaunch.shareLaunch.networkStatus = status;
	};
}

- (void)modifyRigion; {
	[MQTTLaunch.shareLaunch logout];
}

- (void)startMonitoring {
	[NetworkModuleLaunch.shareLaunch startMonitoring];
}

- (void)stopMonitoring {
	[NetworkModuleLaunch.shareLaunch stopMonitoring];
}

@end
