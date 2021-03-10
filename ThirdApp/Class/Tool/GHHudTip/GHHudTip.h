//
//  GHHud.h
//  GHome
//
//  Created by Qincc on 2020/12/19.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;


@interface GHHudTip : NSObject

#pragma mark - 提示（带菊花）

/**
 带信息菊花（View上，需手动隐藏）显示在window上
 
 @param message 提示信息
 */
+ (void)showHUDWithMessage:(NSString *)message;

/**
 带信息菊花（View上，需手动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 */
+ (void)showHUDWithMessage:(NSString *)message inView:(UIView *)view;

/**
 带信息菊花（View上，自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 @param time 自动隐藏延迟时间
 */
+ (void)showHUDWithMessage:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time;

#pragma mark - 提示（不带菊花）

/**
 提示（Window上，1.5s后自动隐藏）
 
 @param message 提示信息
 */
+ (void)showTips:(NSString *)message;

/**
 提示（Window上，显示在底部，1.5s后自动隐藏）
 
 @param message 提示信息
 */
+ (void)showBottomTips:(NSString *)message;

/**
 提示（View上，1.5s后自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 */
+ (void)showTips:(NSString *)message inView:(UIView *)view;

/**
 提示（View上，自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 @param time 自动隐藏时间（default:1s）
 */
+ (void)showTips:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time;

/**
 提示（View上，自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 @param time 自动隐藏时间
 @param yOffset 距离中心点的Y轴的位置
 */
+ (void)showTips:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time yOffset:(CGFloat)yOffset;

/**
 提示（View上，自动隐藏）
 
 @param message 提示信息
 @param view 显示提示的View
 @param time 自动隐藏时间
 @param yOffset 距离中心点的Y轴的位置
 @param configBlock  配置回调
 */
+ (void)showTips:(NSString *)message inView:(UIView *)view delay:(NSTimeInterval)time yOffset:(CGFloat)yOffset configBlock:(void(^)(MBProgressHUD *hub))configBlock;

#pragma mark - 成功，失败
/**
 成功提示（View上，自动隐藏）
 
 @param message 提示信息
 @param imageName 图片
 */
+ (void)showSuccessWithTips:(NSString *)message imageName:(NSString *)imageName;

/**
 成功提示（View上，自动隐藏）
 
 @param message 提示信息
 @param time 自动隐藏时间
 @param imageName 图片
 */
+ (void)showSuccessWithTips:(NSString *)message delay:(NSTimeInterval)time imageName:(NSString *)imageName;

/**
 错误提示（View上，自动隐藏）
 
 @param message 提示信息
 */
+ (void)showErrorWithTips:(NSString *)message;

/**
 错误提示（View上，自动隐藏）
 
 @param message 提示信息
 @param time 自动隐藏时间
 */
+ (void)showErrorWithTips:(NSString *)message delay:(NSTimeInterval)time;

#pragma mark - 隐藏
/**
 隐藏
 */
+ (void)hideHUD;

/**
 隐藏
 
 @param view 所在View
 */
+ (void)hideHUDWithView:(UIView *)view;

@end


@interface GHUDHelp : NSObject
@property (nonatomic, strong) NSMutableArray * hudViews;

+ (GHUDHelp *)share;

@end


@interface GHHudCustomView : UIImageView


@end
