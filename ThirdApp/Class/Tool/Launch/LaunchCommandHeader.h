//
//  LaunchCommandHeader.h
//  GPLaunchHelper
//
//  Created by Qincc on 2019/7/19.
//

#ifndef LaunchCommandHeader_h
#define LaunchCommandHeader_h

#import <UserNotifications/UserNotifications.h>


@protocol LaunchCommand <NSObject>

@required
- (void)executeCommand;

@optional
// MARK: 微信 / 支付宝 等组件回调
- (BOOL)openURL:(NSURL *_Nonnull)url options:(NSDictionary<NSString*, id> * _Nullable)options;
// MARK: 推送相关回调
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *_Nonnull)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *_Nullable)error;
//- (void)didReceiveRemoteNotification:(NSDictionary *_Nonnull)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult nonnull))completionHandler;
- (BOOL)application:(nonnull UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;

// 推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end


#endif /* LaunchCommandHeader_h */
