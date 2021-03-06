//
//  SocketLaunch.m
//  GHome
//
//  Created by Qincc on 2021/2/26.
//

#import "SocketLaunch.h"
#import "GHCucoMQTTService.h"
#import "GHUserInfo.h"

@interface SocketLaunch ()

@property (nonatomic) GHNetworkStatus currNetworkStatus;

@end

@implementation SocketLaunch

+ (instancetype)shareLaunch {
	static dispatch_once_t onceToken;
	static SocketLaunch *socketLaunch;
	dispatch_once(&onceToken, ^{
		socketLaunch = SocketLaunch.alloc.init;
	});
	return socketLaunch;
}

- (void)executeCommand {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
	if (GHUserInfo.share.isLogin && GHNetworkStatusReachableViaWiFi == self.currNetworkStatus) {
		[SocketLaunch.shareLaunch startUDPServices];
	}
}

- (void)startUDPServices {
	//UDPService
	[GHCucoMQTTService startUDPServiceSocket];
}

- (void)logout {
	[GHCucoMQTTService closeUDPService];
	[GHCucoMQTTService closeUDPClient];
	[GHCucoMQTTService disConnectTCPSocket];
}

- (void)updateNetworkStatus:(GHNetworkStatus)networkStatus {
	self.currNetworkStatus = networkStatus;
	if (networkStatus == GHNetworkStatusReachableViaWiFi && GHUserInfo.share.isLogin) {
		[GHCucoMQTTService startUDPServiceSocket];
	} else {
		[self logout];
	}
}

- (void)applicationDidEnterBackgroundNotification {
	[self logout];
}

@end
