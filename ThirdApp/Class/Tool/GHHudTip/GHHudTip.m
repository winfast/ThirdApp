//
//  GHHud.m
//  GHome
//
//  Created by Qincc on 2020/12/19.
//

#import "GHHudTip.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+GHCategory.h"

const CGFloat HudShowTime = 2.0;

@implementation GHHudTip

#pragma mark - 提示（带菊花）

+ (void)showHUDWithMessage:(NSString *)message {
	[self showHUDWithMessage:message inView:nil delay:0];
}

/**
 带信息菊花（View上，需手动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 */
+ (void)showHUDWithMessage:(NSString *)message inView:(UIView *)view{
	[self showHUDWithMessage:message inView:view delay:0];
}

/**
 带信息菊花（View上，自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 @param time 自动隐藏延迟时间
 */
+ (void)showHUDWithMessage:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time{
	[self hideHUD];
	MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:view];
	if (time > 0) {
		[hud hideAnimated:YES afterDelay:time];
		if (view) {
			hud.completionBlock = ^{
				[[GHUDHelp share].hudViews removeObject:view];
			};
		}
	}
}

#pragma mark - 提示（不带菊花）

/**
 提示（Window上，2s后自动隐藏）
 
 @param message 提示信息
 */
+ (void)showTips:(NSString *)message {
	[self showTips:message inView:nil];
}

/**
 提示（Window上，显示在底部，2s后自动隐藏）
 
 @param message 提示信息
 */
#define screenH [UIScreen mainScreen].bounds.size.height
+ (void)showBottomTips:(NSString *)message{
	[self showTips:message inView:nil delay:HudShowTime yOffset:screenH/2-80];
}

/**
 提示（View上，2s后自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 */
+ (void)showTips:(NSString *)message inView:(UIView *)view{
	[self showTips:message inView:view delay:HudShowTime];
}

/**
 提示（View上，自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 @param time 自动隐藏时间
 */
+ (void)showTips:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time{
	[self showTips:message inView:view delay:time yOffset:0];
}

/**
 提示（View上，自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 @param time 自动隐藏时间
 @param yOffset 距离中心点的Y轴的位置
 */
+ (void)showTips:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time yOffset:(CGFloat)yOffset{
	[self hideHUD];
	MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:view icon:nil yOffset:yOffset];
	hud.mode = MBProgressHUDModeText;
	hud.userInteractionEnabled = NO;
	if (time>0) {
		[hud hideAnimated:YES afterDelay:time];
		if (view) {
			hud.completionBlock = ^{
				[[GHUDHelp share].hudViews removeObject:view];
			};
		}
	}
}

/**
提示（View上，自动隐藏）

@param message 提示信息
@param view 显示提示的View
@param time 自动隐藏时间
@param yOffset 距离中心点的Y轴的位置
@param configBlock  配置回调
*/

+ (void)showTips:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time yOffset:(CGFloat)yOffset configBlock:(void(^)(MBProgressHUD *hub))configBlock {
	[self hideHUDWithView:view];
	MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:view icon:nil yOffset:yOffset];
	hud.mode = MBProgressHUDModeText;
	if (configBlock) {
		configBlock(hud);
	}
	if (time > 0) {
		[hud hideAnimated:YES afterDelay:time];
		if (view) {
			hud.completionBlock = ^{
				[[GHUDHelp share].hudViews removeObject:view];
			};
		}
	}
}

#pragma mark - 成功，失败
/**
 成功提示（View上，自动隐藏）
 
 @param message 提示信息
 */
+ (void)showSuccessWithTips:(NSString *)message imageName:(NSString *)imageName {
	[self hideHUD];
	MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:nil icon:imageName yOffset:0];
	hud.mode = MBProgressHUDModeCustomView;
	hud.userInteractionEnabled = NO;
	[hud hideAnimated:YES afterDelay:HudShowTime];;
}

/**
 成功提示（View上，自动隐藏）
 
 @param message 提示信息
 @param time 自动隐藏时间
 */
+ (void)showSuccessWithTips:(NSString *)message delay:(NSTimeInterval)time imageName:(NSString *)imageName  {
	[self hideHUD];
	MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:nil icon:imageName yOffset:0];
	hud.mode = MBProgressHUDModeCustomView;
	hud.userInteractionEnabled = NO;
	if (time>0) {
		[hud hideAnimated:YES afterDelay:time];
	}
}

/**
 错误提示（View上，自动隐藏）
 
 @param message 提示信息
 */
+ (void)showErrorWithTips:(NSString *)message {
	[self hideHUD];
	MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:nil icon:nil yOffset:0];
	hud.mode = MBProgressHUDModeCustomView;
	hud.userInteractionEnabled = NO;
	[hud hideAnimated:YES afterDelay:HudShowTime];;
}

/**
 错误提示（View上，自动隐藏）
 
 @param message 提示信息
 @param time 自动隐藏时间
 */
+ (void)showErrorWithTips:(NSString *)message delay:(NSTimeInterval)time {
	[self hideHUD];
	MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message inView:nil icon:nil yOffset:0];
	hud.mode = MBProgressHUDModeCustomView;
	hud.userInteractionEnabled = NO;
	if (time>0) {
		[hud hideAnimated:YES afterDelay:time];;
	}
}

#pragma mark - 隐藏
/**
 隐藏
 */
+ (void)hideHUD{
	UIView *winView = (UIView*)[UIApplication sharedApplication].delegate.window;
	[MBProgressHUD hideHUDForView:winView animated:YES];
	for (UIView *view in [GHUDHelp share].hudViews) {
		[MBProgressHUD hideHUDForView:view animated:YES];
	}
	[[GHUDHelp share].hudViews removeAllObjects];
}

/**
 隐藏
 
 @param view 所在View
 */
+ (void)hideHUDWithView:(UIView *)view {
	if ([[UIApplication sharedApplication].delegate.window isEqual:view]) {
		[MBProgressHUD hideHUDForView:view animated:YES];
	}
	else {
		[MBProgressHUD hideHUDForView:view animated:YES];
		[[GHUDHelp share].hudViews removeObject:view];
	}
}

/**
 初始化Hud
 
 @param message 提示自定义菊花
 @param view 显示提示的View
 @return Hud
 */
+ (MBProgressHUD *)createMBProgressHUDviewWithMessage:(NSString*)message inView:(UIView *)view{
	if (!view) {
		view = [UIApplication sharedApplication].delegate.window;
	}else{
		[[GHUDHelp share].hudViews addObject:view];
	}
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.label.text = message ? message:nil;
	hud.mode = MBProgressHUDModeCustomView;
	hud.label.font = [UIFont systemFontOfSize:16];
	hud.contentColor = UIColor.whiteColor;
	hud.label.numberOfLines = 0;
	hud.minSize = CGSizeMake(82, 82);
	hud.bezelView.color = ASColorHexAlpha(0x303333, 0.6);
	hud.bezelView.layer.cornerRadius = 8;
	hud.bezelView.layer.masksToBounds = YES;
	hud.removeFromSuperViewOnHide = YES;
	hud.margin = 20;
	GHHudCustomView *redView = [[GHHudCustomView alloc] init];
	redView.image = ASImage(@"pop_icon_loading");
	redView.backgroundColor = UIColor.clearColor;
	redView.frame = CGRectMake(0, 0, 40, 40);
	hud.customView = redView;
	return hud;
}

/**
 初始化Hud
 
 @param message 提示语
 @param view 显示提示的View
 @return Hud
 */
+ (MBProgressHUD *)createMBProgressHUDviewWithMessage:(NSString*)message inView:(UIView *)view icon:(NSString *)icon yOffset:(CGFloat)yOffset{
	if (!view) {
		view = [UIApplication sharedApplication].delegate.window;
	}else{
		[[GHUDHelp share].hudViews addObject:view];
	}
	UIImage *img = [UIImage imageNamed:icon];
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	hud.label.text = message ? message:nil;
	hud.label.font = [UIFont systemFontOfSize:16];
	hud.label.numberOfLines = 0;
	if (img) {
		hud.contentColor = ASColorHex(0x303333);
		hud.bezelView.color = UIColor.whiteColor;
		hud.backgroundColor = ASColorHexAlpha(0x303333, 0.5);
	} else {
		hud.contentColor = UIColor.whiteColor;
		hud.bezelView.color = ASColorHexAlpha(0x303333, 0.8);
	}
	hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
	
	hud.bezelView.layer.cornerRadius = 8;
	hud.bezelView.layer.masksToBounds = YES;
	hud.removeFromSuperViewOnHide = YES;
	hud.acitonPading = 20;
//    hud.dimBackground = NO;
//    UIImage *img = [UIImage gp_imgWithCls:[self class] podName:@"GPComponent" imgName:icon];
	
	if (icon) hud.customView = [[UIImageView alloc] initWithImage:img];
	if (yOffset>0) {
		hud.offset = CGPointMake(0, yOffset);
	}
	return hud;
}

@end


@implementation GHUDHelp

static GHUDHelp *hudHelp = nil;
+ (GHUDHelp *)share
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		hudHelp = [[self alloc] init];
	});
	return hudHelp;
}
- (NSMutableArray *)hudViews{
	if (!_hudViews) {
		_hudViews = [NSMutableArray array];
	}return _hudViews;
}

@end


@implementation GHHudCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self startAnimating];
	}
	return self;
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(40, 40);
}

- (void)startAnimating {
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.toValue = [NSNumber numberWithFloat: 360*M_PI/180];
	rotateAnimation.duration = 0.8;
	rotateAnimation.autoreverses = NO;
	rotateAnimation.fillMode = kCAFillModeForwards;
	rotateAnimation.removedOnCompletion = NO;
	rotateAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
	[self.layer addAnimation:rotateAnimation forKey:@"rotation"];
}

@end
