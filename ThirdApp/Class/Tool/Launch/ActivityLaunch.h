//
//  ActivityLaunch.h
//  GHome
//
//  Created by Qincc on 2020/12/31.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityLaunch : NSObject <LaunchCommand>

+ (instancetype)shareLaunch;

@end

NS_ASSUME_NONNULL_END
