//
//  WindowLaunch.h
//  MobileSoft
//
//  Created by Qincc on 2018/12/25.
//  Copyright © 2018 Qincc's Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface WindowLaunch : NSObject <LaunchCommand>

@property (strong, nonatomic) NSDictionary *options;

+ (instancetype)shareLaunch;

- (void)logout;

- (void)updateRootViewController;

@end

NS_ASSUME_NONNULL_END
