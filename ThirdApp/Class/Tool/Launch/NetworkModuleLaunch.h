//
//  NetworkModuleLaunch.h
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"
#import <GHNetworkModule/GHNetworkReachabilityManager.h>


NS_ASSUME_NONNULL_BEGIN

@interface NetworkModuleLaunch : NSObject<LaunchCommand>

+ (instancetype)shareLaunch;

- (void)startMonitoring;

- (void)stopMonitoring;

- (void)logout;


@property (nonatomic, copy) void (^upadteNetworkStatus)(GHNetworkStatus status);

@end

NS_ASSUME_NONNULL_END
