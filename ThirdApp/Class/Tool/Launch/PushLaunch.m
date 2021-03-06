//
//  PushLaunch.m
//  GPlus
//
//  Created by KimeeMacmini on 2019/1/7.
//  Copyright © 2019 Galanz. All rights reserved.
//

#import "PushLaunch.h"
#import <UserNotifications/UserNotifications.h>
#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>

@interface PushLaunch () <LaunchCommand, UNUserNotificationCenterDelegate>

@end

@implementation PushLaunch

+ (instancetype)shareLaunch {
    static PushLaunch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

// MARK: Protocol
- (void)executeCommand {
	[UMConfigure setLogEnabled:YES];   //开启日志
	[UMConfigure initWithAppkey:@"" channel:@"App Store"];  // required
	
	UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
	//type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
	entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
	[UNUserNotificationCenter currentNotificationCenter].delegate = self;
	[UMessage registerForRemoteNotificationsWithLaunchOptions:self.options Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
		if (granted) {
			
		} else {
			
		}
	}];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	//关闭友盟自带的弹出框
	[UMessage setAutoAlert:NO];
	[UMessage didReceiveRemoteNotification:userInfo];

}

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
	NSDictionary * userInfo = notification.request.content.userInfo;
	if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		//应用处于前台时的远程推送接受
		//关闭友盟自带的弹出框
		[UMessage setAutoAlert:NO];
		//必须加这句代码
		[UMessage didReceiveRemoteNotification:userInfo];
	}
	completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
	NSDictionary * userInfo = response.notification.request.content.userInfo;
	if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		//应用处于后台时的远程推送接受
		//必须加这句代码
		[UMessage didReceiveRemoteNotification:userInfo];
	}else{
		//应用处于后台时的本地推送接受
	}
}

// Push 高级功能设置，如果使用"交互式"的通知(iOS 8.0 and later)，请参考下面函数注释部分的代码。
- (void)setupPushAdvanceFunctionWithLaunchOptions:(NSDictionary *_Nullable)launchOptions
{
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
//    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
//
//    if (([[[UIDevice currentDevice] systemVersion]intValue]>=8)&&([[[UIDevice currentDevice] systemVersion]intValue]<10))
//    {
//        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
//        action1.identifier = @"action1_identifier";
//        action1.title=@"打开应用";
//        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
//
//        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
//        action2.identifier = @"action2_identifier";
//        action2.title=@"忽略";
//        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
//        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//        action2.destructive = YES;
//        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
//        actionCategory1.identifier = @"category1";//这组动作的唯一标示
//        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
//        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
//        entity.categories=categories;
//    }
//
//    //如果要在iOS10显示交互式的通知，必须注意实现以下代码
//    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10)
//    {
//        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
//        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
//
//        //UNNotificationCategoryOptionNone
//        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//        NSSet *categories = [NSSet setWithObjects:category1_ios10, nil];
//        entity.categories=categories;
//    }
//    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//        }else
//        {
//        }
//    }];
}

- (void)bingdingUMengAlias{
//	[UMessage setAlias:<#(NSString * _Nonnull)#> type:<#(NSString * _Nonnull)#> response:<#^(id  _Nullable responseObject, NSError * _Nullable error)handle#>]
}

- (void)unbingdingUMengAlias{
	
}

- (void)resetUMengBadge {
	
}



@end
