//
//  WindowLaunch.m
//  MobileSoft
//
//  Created by Qincc on 2018/12/25.
//  Copyright © 2018 Qincc's Mac. All rights reserved.
//

#import "WindowLaunch.h"
#import <UIKit/UIKit.h>

@interface WindowLaunch ()

@end

@implementation WindowLaunch

+ (instancetype)shareLaunch {
    static WindowLaunch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)updateRootViewController {
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
	//移除所有window上的view控件,防止内存泄露
	[window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setRootViewControllerWithWindow:window];
    [UIApplication.sharedApplication.delegate.window makeKeyAndVisible];
}


- (void)setRootViewControllerWithWindow:(UIWindow *)window {
    UITabBarController *tab = [[NSClassFromString(@"GHTabBarController") alloc] init];
    window.rootViewController = tab;
}

// MARK: Protocol
- (void)executeCommand {
    UIWindow *window = [UIWindow.alloc initWithFrame:UIScreen.mainScreen.bounds];
    [self setRootViewControllerWithWindow:window];
    window.backgroundColor = UIColor.whiteColor;
    window.rootViewController.view.backgroundColor = UIColor.whiteColor;
    UIApplication.sharedApplication.delegate.window = window;
    [UIApplication.sharedApplication.delegate.window makeKeyAndVisible];
}

//由于退出登录的时候，直接进入登录UI
- (void)logout {
	UIWindow *window = UIApplication.sharedApplication.delegate.window;
	[self setRootViewControllerWithWindow:window];
	[UIApplication.sharedApplication.delegate.window makeKeyAndVisible];
}

@end
