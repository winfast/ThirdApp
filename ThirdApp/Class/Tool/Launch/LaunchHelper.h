//
//  LaunchHelper.h
//  MobileSoft
//
//  Created by Qincc on 2018/12/25.
//  Copyright © 2018 Qincc's Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHNetworkModule/GHNetworkReachabilityManager.h>
#import <UserNotifications/UNUserNotificationCenter.h>


NS_ASSUME_NONNULL_BEGIN

@interface LaunchHelper : NSObject

+ (instancetype)share;

@property (nonatomic) GHNetworkStatus networkStatus;

/** 初始化方法*/
- (void)launchWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions;
/** 执行方法*/
- (void)helperExecute;

- (void)startMonitoring;

- (void)stopMonitoring;

- (void)modifyRigion;

- (BOOL)application:(nonnull UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;

// 推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
