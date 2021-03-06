//
//  GHNetworkRequestLaunch.m
//  GHome
//
//  Created by Qincc on 2020/12/27.
//  启动的时候确定App的服务器，推出登录， 切换区域的时候更新服务器

#import "GHNetworkRequestLaunch.h"
#import "GHUserInfo.h"
//#import "GHLoginHomeViewModel.h"
#import "GHCountryList.h"
#import "GHLoginViewModel.h"

@interface GHNetworkRequestLaunch ()

//@property (nonatomic, strong) GHLoginHomeViewModel *viewModel;
@property (nonatomic, strong) GHLoginViewModel *loginViewModel;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation GHNetworkRequestLaunch

+ (instancetype)shareLaunch {
	static GHNetworkRequestLaunch *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.semaphore = dispatch_semaphore_create(0);
	}
	return self;
}


// MARK: Protocol
- (void)executeCommand {
	//如果是登录的状态。需要重新获取Token和STS
	if (GHUserInfo.share.isLogin) {
		//重新获取Token
		GHRefreshTokenRequest *request = GHRefreshTokenRequest.alloc.init;
		request.token = GHUserInfo.share.token;
		[self.loginViewModel.refreshTokenCommand execute:request];
	}
}

//- (GHLoginHomeViewModel *)viewModel {
//	if (!_viewModel) {
//		_viewModel = GHLoginHomeViewModel.alloc.init;
//	}
//	return _viewModel;
//}

- (GHLoginViewModel *)loginViewModel {
	if (!_loginViewModel) {
		_loginViewModel = GHLoginViewModel.alloc.init;
	}
	return _loginViewModel;
}

- (void)logout {
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		[[self.viewModel.reginCommand execute:nil] subscribeNext:^(id  _Nullable x) {
//			dispatch_async(dispatch_get_main_queue(), ^{
//				GHUserInfo.share.region_code = x[@"cc"];
//				NSArray *countryList = [GHCountryList.alloc.init statesArray];
//				NSUInteger index = [[countryList valueForKey:@"region_code"] indexOfObject:GHUserInfo.share.region_code];
//				if (index != NSNotFound) {
//					NSDictionary *stateInfo = [countryList objectAtIndex:index];
//					GHUserInfo.share.region_name = stateInfo[@"region_name"];
//					GHUserInfo.share.phone_code = stateInfo[@"phone_code"];
//				}
//				dispatch_semaphore_signal(self.semaphore);
//			});
//		}];
//	});
//
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
//		GHConfigRequest *request = GHConfigRequest.alloc.init;
//		request.country_code = GHUserInfo.share.region_code;
//		[[self.viewModel.configCommand execute:request] subscribeNext:^(NSString *_Nullable x) {
//			dispatch_async(dispatch_get_main_queue(), ^{
//				GHUserInfo.share.api_server = x;
//				NSLog(@"获取服务器地址成功 = %@", x);
//			});
//		} error:^(NSError * _Nullable error) {
//			NSLog(@"获取服务器地址失败");
//		}];
//	});
}

@end
