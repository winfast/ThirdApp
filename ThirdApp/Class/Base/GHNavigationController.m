//
//  GHNavigationController.m
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import "GHNavigationController.h"

@interface GHNavigationController ()

@end

@implementation GHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UINavigationBar.appearance setBarTintColor:UIColor.whiteColor];
    [UINavigationBar.appearance setTintColor:ASColorHex(0x000000)];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (self.viewControllers.count > 0) {
		viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"nav_icon_return"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated)];
		// 当前导航栏, 只有一个viewController push的时候设置隐藏
		if (self.viewControllers.count == 1) {
			viewController.hidesBottomBarWhenPushed = YES;
		}
	} else {
		viewController.hidesBottomBarWhenPushed = NO;
	}
	[super pushViewController:viewController animated:animated];
}

- (void)popViewControllerAnimated {
    [self popViewControllerAnimated:YES];
}

@end
