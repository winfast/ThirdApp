//
//  ComponentLaunch.h
//  GPlus
//
//  Created by KimeeMacmini on 2019/1/7.
//  Copyright © 2019 Galanz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComponentLaunch : NSObject <LaunchCommand>

@property (nonatomic) AFNetworkReachabilityStatus networkStatus;

+ (instancetype)shareLaunch;

- (void)startMonitoring;
- (void)stopMonitoring;



@end

NS_ASSUME_NONNULL_END
