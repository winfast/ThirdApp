//
//  PushLaunch.h
//  GPlus
//
//  Created by KimeeMacmini on 2019/1/7.
//  Copyright © 2019 Galanz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchCommandHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface PushLaunch : NSObject <LaunchCommand>

@property (strong, nonatomic) NSDictionary *options;


@property (nonatomic, strong) NSString *registrationID;

@property (nonatomic, strong) NSNumber *notifuNumber;

+ (instancetype)shareLaunch;

// JPUSH 自定义方法
- (void)bingdingUMengAlias;
- (void)unbingdingUMengAlias;
- (void)resetUMengBadge;

@end

NS_ASSUME_NONNULL_END
