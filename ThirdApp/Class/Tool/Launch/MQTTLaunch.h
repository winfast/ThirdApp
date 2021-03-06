//
//  MQTTLaunch.h
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"
#import <GHNetworkModule/GHNetworkReachabilityManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQTTLaunch : NSObject<LaunchCommand>

@property (nonatomic) GHNetworkStatus networkStatus;

+ (instancetype)shareLaunch;

- (void)logout;

@end

NS_ASSUME_NONNULL_END
