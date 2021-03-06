//
//  ActivityLaunch.m
//  GHome
//
//  Created by Qincc on 2020/12/31.
//

#import "ActivityLaunch.h"
#import "GHThirdKey.h"
#import "GHAnotherToGhomeViewController.h"
#import "GHUserInfo.h"
#import "GHHudTip.h"

@interface GHAlexaToGhomeModel : NSObject

@property (nonatomic, copy) NSString *client_id;
@property (nonatomic, copy) NSString *redirect_uri;
@property (nonatomic, copy) NSString *response_type;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *state;

@end

@implementation GHAlexaToGhomeModel

@end

@interface GHAWSAlexaBindModel : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *state;

@end

@implementation GHAWSAlexaBindModel


@end

@interface GHAWSAlexaUnBindModel : NSObject

@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *errorDescription;
@property (nonatomic, copy) NSString *state;

@end


@implementation GHAWSAlexaUnBindModel


@end

@implementation ActivityLaunch

+ (instancetype)shareLaunch {
	static dispatch_once_t onceToken;
	static ActivityLaunch *activityLaunch;
	dispatch_once(&onceToken, ^{
		activityLaunch = ActivityLaunch.alloc.init;
	});
	return activityLaunch;
}

- (void)executeCommand {
	
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
	if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
		NSURL *webPageURL = userActivity.webpageURL;
		//根据URL判断是绑定还是解绑
		if (webPageURL) {
			NSURLComponents *components = [[NSURLComponents alloc] initWithURL:webPageURL resolvingAgainstBaseURL:YES];
			NSArray *queryItems = components.queryItems;
			NSMutableDictionary *dict = NSMutableDictionary.alloc.init;
			for (NSURLQueryItem *queryItem in queryItems) {
				[dict setObject:queryItem.value forKey:queryItem.name];
			}
			
			if (dict.count == 0) {
				return NO;
			}
			
			GHAWSAlexaBindModel *bindModel = [GHAWSAlexaBindModel mj_objectWithKeyValues:dict];
			GHAWSAlexaUnBindModel *unbindModel = [GHAWSAlexaUnBindModel mj_objectWithKeyValues:dict];
			GHAlexaToGhomeModel *toModel = [GHAlexaToGhomeModel mj_objectWithKeyValues:dict];
			if (bindModel.code.length > 0) {
				[NSNotificationCenter.defaultCenter postNotificationName:GHAlexaBindNotify object:nil userInfo:@{
					@"code":bindModel.code
				}];
			} else if (toModel.redirect_uri.length > 0) {
				//进入绑定UI
				if (!GHUserInfo.share.isLogin) {
					GHUserInfo.share.universalLinkInfo = [toModel mj_keyValues];
				} else {
					
					UITabBarController *tab = (UITabBarController *)UIApplication.sharedApplication.keyWindow.rootViewController;
					UINavigationController *nav = [tab selectedViewController];
					
					if (![nav.visibleViewController isMemberOfClass:GHAnotherToGhomeViewController.class]) {
						GHAnotherToGhomeViewController *vc = GHAnotherToGhomeViewController.alloc.init;
						vc.info = [toModel mj_keyValues];
						[nav pushViewController:vc animated:YES];
					} else {
						GHAnotherToGhomeViewController *vc = (GHAnotherToGhomeViewController *)nav.visibleViewController;
						vc.info = [toModel mj_keyValues];
					}
				}
			} else {
				if (unbindModel.error.length > 0) {
					[GHHudTip showTips:@"You have not completed the Alexa account authrization"];
				}
			}
		}
		return YES;
	}
	return NO;
}

@end


