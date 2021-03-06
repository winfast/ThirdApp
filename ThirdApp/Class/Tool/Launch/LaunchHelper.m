//
//  LaunchHelper.m
//  MobileSoft
//
//  Created by Qincc on 2018/12/25.
//  Copyright © 2018 Qincc's Mac. All rights reserved.
//

#import "LaunchHelper.h"
#import "WindowLaunch.h"
#import "KeyboardLaunch.h"

@interface LaunchHelper ()

@property (strong, nonatomic) NSArray *commands;

@end

@implementation LaunchHelper

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static LaunchHelper *helper;
    dispatch_once(&onceToken, ^{
        helper = LaunchHelper.alloc.init;
    });
    return helper;
}

// MARK: Appdelegate 初始化
- (void)launchWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions {
    
    // 前置参数初始化
    WindowLaunch.shareLaunch.options = launchOptions;
	
    self.commands = @[
        WindowLaunch.shareLaunch,
        KeyboardLaunch.shareLaunch];
}

// MARK: 启动协议执行方法
- (void)helperExecute {
    // MARK: ⚙ 其他组件基础配置
    [self.commands enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(LaunchCommand)]) [obj executeCommand];
    }];
}


@end
