//
//  TSAddUserAlertView.h
//  ThirdApp
//
//  Created by QinChuancheng on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSAddUserAlertView : UIControl

@property (nonatomic, strong, readonly) UIButton *addImageBtn;
@property (nonatomic, strong, readonly) UITextField *userNameTextField;
@property (nonatomic, strong, readonly) UIButton *mailBtn;
@property (nonatomic, strong, readonly) UIButton *femailBtn;
@property (nonatomic, strong, readonly) UIButton *cancelBtn;
@property (nonatomic, strong, readonly) UIButton *okBtn;

+ (instancetype)showWithView:(UIView *)view
              textFieldPlace:(NSString *)textFieldPlace
                    btnBlock:(void (^)(TSAddUserAlertView *alertView, UIButton* clickBtn))clickBlock;

@end

NS_ASSUME_NONNULL_END
