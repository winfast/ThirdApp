//
//  NetworkModuleLaunch.h
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"


NS_ASSUME_NONNULL_BEGIN

@interface NetworkModuleLaunch : NSObject<LaunchCommand>

+ (instancetype)shareLaunch;

- (void)startMonitoring;

- (void)stopMonitoring;

- (void)logout;

@end

NS_ASSUME_NONNULL_END
