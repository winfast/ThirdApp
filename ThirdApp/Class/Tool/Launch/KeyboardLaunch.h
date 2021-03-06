//
//  KeyboardLaunch.h
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardLaunch : NSObject<LaunchCommand>

+ (instancetype)shareLaunch;

@end


NS_ASSUME_NONNULL_END
