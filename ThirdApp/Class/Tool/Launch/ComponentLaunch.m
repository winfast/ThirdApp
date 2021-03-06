//
//  ComponentLaunch.m
//  GPlus
//
//  Created by KimeeMacmini on 2019/1/7.
//  Copyright © 2019 Galanz. All rights reserved.
//

#import "ComponentLaunch.h"
#import <WXApi.h>
#import "WXApiManager.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <Bugly/Bugly.h>
#import <AFNetworkReachabilityManager.h>

@interface ComponentLaunch ()<TencentSessionDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation ComponentLaunch

+ (instancetype)shareLaunch {
    static ComponentLaunch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)startMonitoring {
	[AFNetworkReachabilityManager.sharedManager startMonitoring];
}

- (void)stopMonitoring {
	[AFNetworkReachabilityManager.sharedManager stopMonitoring];
}

// MARK: Protocol
- (void)executeCommand {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{  // 这里的代码引起模拟器卡在启动图，子线程处理
        // QQ登录，分享
        self.tencentOAuth = [[GPAutoLoginManager sharedManager] tencentRegisterApp:GPQQAppID];
        self.tencentOAuth.authShareType = AuthShareType_QQ;
		
		//启动网络监听
		AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
		[manager startMonitoring];
		@weakify(self)
		[manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
			@strongify(self);
			self.networkStatus = status;
		}];
        
        [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
            NSLog(@"log : %@", log);
        }];
        // 微信注册
        [WXApi registerApp:GPWeChatAppID universalLink:GPWeChatUniversalLink]; // 传通链给微信
        // Bugly
        [Bugly startWithAppId:GPBuglyAppID];
		
//        ASWeak(self);
        WXApiManager.sharedManager.WXShareCallBack = ^(SendMessageToWXResp *resp) {
            if (resp.errCode == 0) {
//                [weakself shareToGetPoints];
            }
        };
    });
}

- (BOOL)openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    NSString *path = url.absoluteString;
    NSLog(@"%@", [url scheme]);
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        return YES;
    } else if ([[url scheme] isEqualToString:GPWeChatAppID]) {
        // 微信登录 - 包含 微信调起与短信调起
        ///MARK: 注意:  -- WechatOpenSDK 1.8.6 后调起微信进行授权登录或支付,不再周openURL方法,
        ///而是只走-(BOOL)application:continueUserActivity:restorationHandler:
        ///但是通过网页发手机验证码链接登录依然会走openURL方法
        if ([GPAutoLoginManager checkWechatAutoURL:url options:options]) {
            return YES;
        }
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    } else if ([[url scheme] isEqualToString:GPTencentURLScheme]) { // tencent1107862426
        if ([path containsString:@"&error"]&& [path containsString:@"&version"]) {
            NSInteger code = [[path substringWithRange:NSMakeRange([path rangeOfString:@"&error="].location+[path rangeOfString:@"&error="].length, [path rangeOfString:@"&version"].location-[path rangeOfString:@"&error="].location)] integerValue];
            if (code == 0) {
                [GPTipsUtil showTips:@"分享成功"];
            }else{
                [GPTipsUtil showTips:@"分享失败"];
            }
        }
        if ([TencentOAuth CanHandleOpenURL:url]) {
            return [TencentOAuth HandleOpenURL:url];
        } else {
            return [QQApiInterface handleOpenURL:url delegate:self];
        }
        return YES;
    } else if ([[url scheme] isEqualToString:GPQQURLScheme]) { // QQ1107862426
        // QQ
         return [QQApiInterface handleOpenURL:url delegate:self];
    }
    return NO;
}

#pragma mark - TencentSessionDelegate

//TODO: 使用了GPAutoLoginManager - 该三个协议方法事实上已经没有作用了
// 登录功能没添加，但调用TencentOAuth相关方法进行分享必须添加<TencentSessionDelegate>，则以下方法必须实现，尽管并不需要实际使用它们
- (void)tencentDidLogin {}

// 非网络错误导致登录失败
- (void)tencentDidNotLogin:(BOOL)cancelled {}

// 网络错误导致登录失败
- (void)tencentDidNotNetWork {}


//#pragma mark - WeiboSDKDelegate
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
//    NSLog(@"============didReceiveWeiboRequest================");
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
////        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
////        NSLog(@"\n=====================\n%@\n==================\n", message);
//        if (response.statusCode == 0) {
//            [self shareToGetPoints];
//        }
//        else {
//            
//        }
//    } else if ([response isKindOfClass:WBAuthorizeResponse.class]){
//        NSLog(@"\n=====================\n%@\n==================\n",response.userInfo);
//        [[NSUserDefaults standardUserDefaults] setObject:response.userInfo forKey:@"WBResponse_UserInfo"];
//        if (response.userInfo != nil) {
//            //登录成功发送通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationWeiboLogin" object:nil];
//        }
//    }
//}

- (void)isOnlineResponse:(NSDictionary *)response {}

- (void)onReq:(QQBaseReq *)req {}

- (void)onResp:(QQBaseResp *)resp {
    if ([resp.result integerValue] == 0) {
//        [self shareToGetPoints];
    } else {
        
    }
}


@end
