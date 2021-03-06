//
//  AppDelegate.m
//  ThirdApp
//
//  Created by Qincc on 2021/3/6.
//

#import "AppDelegate.h"
#import "LaunchHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LaunchHelper.share launchWithApplication:application options:launchOptions];
    [[LaunchHelper share] helperExecute];
    return YES;
}

@end
