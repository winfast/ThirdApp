//
//  LaunchHelper.h
//  MobileSoft
//
//  Created by Qincc on 2018/12/25.
//  Copyright © 2018 Qincc's Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UNUserNotificationCenter.h>


NS_ASSUME_NONNULL_BEGIN

@interface LaunchHelper : NSObject

+ (instancetype)share;


/** 初始化方法*/
- (void)launchWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions;
/** 执行方法*/
- (void)helperExecute;

@end

NS_ASSUME_NONNULL_END
