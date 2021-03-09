//
//  GHAlertView.h
//  GHAlertView
//
//  Created by Qincc on 2020/12/11.
//

#import <UIKit/UIKit.h>

@class GHAlertView;

typedef void(^GHAlertViewClickBlock)(GHAlertView * alertView, NSInteger tag);

@interface GHAlertView : UIControl

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIImageView *topImageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UIView *lineView;
@property (nonatomic, strong, readonly) UIButton *okBtn;
@property (nonatomic, strong, readonly) UIButton *cancelBtn;
@property (nonatomic, strong, readonly) UITextField *inputTextField;


/// 显示普通的警告弹窗
/// @param view 要显示在哪个View上面
/// @param imageName 顶部图片的名称
/// @param title 标题
/// @param message 内容
/// @param okBtnTitle 确定按钮的名称
/// @param cancelBtnTitle 取消按钮的名称
/// @param configBlock 配置只读控件的属性
/// @param clickBlock 点击按钮的回调
+ (instancetype)showWithView:(UIView *)view
                   imageName:(NSString *)imageName
                       title:(NSString *)title
                     message:(NSString *)message
                  okBtnTitle:(NSString *)okBtnTitle
              cancelBtnTitle:(NSString *)cancelBtnTitle
                 configBlock:(void (^)(GHAlertView *alertView))configBlock
                    btnBlock:(GHAlertViewClickBlock)clickBlock;


/// 显示多按钮的弹窗，如果只有两个按钮，该接口直接调用上面的实现
/// @param view 要显示在哪个View上面
/// @param title 标题
/// @param message 内容
/// @param cancelBtnTitle 取消按钮的名称。其tag = 0
/// @param configBlock 配置控件的属性
/// @param clickBlock 点击按钮的回调
/// @param otherBtnTitles 其它的按钮的名称,从下向上排列， tag从1开始自增
+ (instancetype)showWithView:(UIView *)view
                       title:(NSString *)title
                     message:(NSString *)message
              cancelBtnTitle:(NSString *)cancelBtnTitle
                 configBlock:(void (^)(GHAlertView *alertView))configBlock
                    btnBlock:(GHAlertViewClickBlock)clickBlock
              otherBtnTitles:(NSString *)otherBtnTitles,...;



/// 显示带有输入框的弹窗
/// @param view 要显示在哪个View上面
/// @param title 标题
/// @param textFieldPlace 输入框的提示文本
/// @param okBtnTitle 确定按钮的名称
/// @param cancelBtnTitle 取消按钮的名称
/// @param configBlock 配置只读控件的属性
/// @param clickBlock 点击按钮的回调
+ (instancetype)showWithView:(UIView *)view
                       title:(NSString *)title
              textFieldPlace:(NSString *)textFieldPlace
                  okBtnTitle:(NSString *)okBtnTitle
              cancelBtnTitle:(NSString *)cancelBtnTitle
                 configBlock:(void (^)(GHAlertView *alertView))configBlock
                    btnBlock:(GHAlertViewClickBlock)clickBlock;


/// 关闭弹窗
/// @param complete 关闭后的回调
- (void)dismiss:(void(^)(void))complete;


@end

