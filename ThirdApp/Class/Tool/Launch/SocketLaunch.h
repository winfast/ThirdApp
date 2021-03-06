//
//  SocketLaunch.h
//  GHome
//
//  Created by Qincc on 2021/2/26.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"
#import <GHNetworkModule/GHNetworkReachabilityManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface SocketLaunch : NSObject<LaunchCommand>

+ (instancetype)shareLaunch;

/// 启动UDP服务器（只有登录成功才会启动UDP刷新）
- (void)startUDPServices;

/// 推出登录
- (void)logout;

/// 更新网络状态
/// @param networkStatus 当前的网络状态
- (void)updateNetworkStatus:(GHNetworkStatus)networkStatus;

@end

NS_ASSUME_NONNULL_END
