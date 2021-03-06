//
//  GHNetworkRequestLaunch.h
//  GHome
//
//  Created by Qincc on 2020/12/27.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface GHNetworkRequestLaunch : NSObject <LaunchCommand>

+ (instancetype)shareLaunch;

- (void)logout;

@end

NS_ASSUME_NONNULL_END
