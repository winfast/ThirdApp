//
//  GHTabBarController.m
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import "GHTabBarController.h"

@interface GHTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray *images;

@end

@implementation GHTabBarController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[NSLocalizedString(@"测量", nil),
						NSLocalizedString(@"趋势", nil),
                        NSLocalizedString(@"历史", nil)];
      
    self.images = @[@"tab_icon_home",
					@"tab_icon_market",
                    @"tab_icon_mine"];
      
    NSArray *classArray = @[@"GHBaseViewController",
							@"GHBaseViewController",
                            @"GHBaseViewController"];
      
    [classArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          [self setControllerWithClassName:obj
                                     title:titles[idx]
                                 imageName:self.images[idx]
                       selectedImageSuffix:@"_select"];
    }];
    
    self.tabBar.translucent = YES;
	self.delegate = self;
    // 设置阴影及字体
	if (@available (iOS 13, *)) {
		UITabBarAppearance *appearance = self.tabBar.standardAppearance.copy;
		appearance.backgroundImage = ASImageWithHexColor(0xFFFFFF, 1);
		[appearance setShadowImage:ASImageWithHexColor(0xEBF5F4, 1)];
		appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName : ASColorHex(0x606664), NSFontAttributeName : ASFont(10)};
		appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName : ASColorHex(0x0BD087), NSFontAttributeName : ASFont(10)};
		appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffsetMake(0, -4);
		appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, -4);
		self.tabBar.standardAppearance = appearance;
	} else {
		[self.tabBar setBackgroundImage:ASImageWithHexColor(0xFFFFFF, 1)];
		[self.tabBar setShadowImage:ASImageWithHexColor(0xEBF5F4, 1)];
	}
	
	
//	__block NSInteger index = 0;
//	[self.tabBar layoutIfNeeded];
//	[self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//		if ([obj isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//			UIView *item = obj;
//			if (2 == index) {
//				self.redView = UIView.alloc.init;
//				self.redView.backgroundColor = ASColorHex(0xFC682D);
//				self.redView.frame = CGRectMake(0, 0, 6, 6);
//				self.redView.layer.cornerRadius = 3;
//				self.redView.layer.masksToBounds = YES;
//				self.redView.center = CGPointMake(item.center.x + 6, 0 + 10);
//				self.redView.hidden = YES;
//				[self.tabBar addSubview:self.redView];
//			}
//			else {
//			}
//			index++;
//		}
//	}];
//	[self dataRequest];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOTAListNotify:) name:GHOTASuccessNotify object:nil];
//
//#ifdef DEBUG
//	UISwipeGestureRecognizer *swipe = [UISwipeGestureRecognizer.alloc initWithTarget:self action:@selector(swipeGesture:)];
//	swipe.direction = UISwipeGestureRecognizerDirectionRight;
//	[self.tabBar addGestureRecognizer:swipe];
//#endif
}


- (void)setControllerWithClassName:(NSString *)className title:(NSString *)title imageName:(NSString *)imageName selectedImageSuffix:(NSString *)suffix {
    UIViewController *itemVc = [NSClassFromString(className).alloc init];
    itemVc.navigationItem.title = title;
    
    // 自定义导航栏
    UINavigationController *itemNav = [[NSClassFromString(@"GHNavigationController") alloc] initWithRootViewController:itemVc];
    [self addChildViewController:itemNav];
    
    // 底部标签🏷 图片设置
    NSString *selecteImg = [NSString stringWithFormat:@"%@%@", imageName, suffix];
    NSString *normalImg = [NSString stringWithFormat:@"%@%@", imageName, @"_normal"];
    itemNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                               selectedImage:[[UIImage imageNamed:selecteImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
	if (@available (iOS 13, *)) {
		
	} else {
		// 底部标签🏷 默认颜色
		NSDictionary *normalAttributes = @{NSForegroundColorAttributeName : ASColorHex(0x606664),
										   NSFontAttributeName : ASFont(10)};
		[itemNav.tabBarItem setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
		// 底部标签🏷 选中颜色
		NSDictionary *selectAttributes = @{NSForegroundColorAttributeName : ASColorHex(0x0BD087),
										   NSFontAttributeName : ASFont(10)};
		[itemNav.tabBarItem setTitleTextAttributes:selectAttributes forState:UIControlStateSelected];
		// 底部标签🏷 标题偏移
		[itemNav.tabBarItem setTitlePositionAdjustment:(UIOffset){0, -4}];
	}
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
#ifdef DEBUG
    [self configFlex];
#endif
}

#ifdef DEBUG
- (void)configFlex {
//	NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
//	for (UIWindow *win in frontToBackWindows) {
//		if (win.windowLevel == UIWindowLevelNormal) {
//			if (![win viewWithTag:0xFFFFFEEE]) {
//				GHFlexDotView *dotView = [[GHFlexDotView alloc] initWithFrame:CGRectMake(0, 200, 60, 60)];
//				dotView.tag = 0xFFFFFEEE;
//				[win addSubview:dotView];
//				dotView.layer.zPosition = MAXFLOAT; //让View永远置于最上面的方法
//				break;
//			}
//		}
//	}
}
#endif

@end
