//
//  TSAddUserAlertView.m
//  ThirdApp
//
//  Created by QinChuancheng on 2021/3/9.
//

#import "TSAddUserAlertView.h"

@interface TSAddUserAlertView ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UIButton *mailBtn;
@property (nonatomic, strong) UIButton *femailBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) void (^clickAddUserAlertView)(TSAddUserAlertView *alertView, UIButton * clickBtn);

@end

@implementation TSAddUserAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(clickBgControl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype)showWithView:(UIView *)view
              textFieldPlace:(NSString *)textFieldPlace
                    btnBlock:(void (^)(TSAddUserAlertView *alertView, UIButton * clickBtn))clickBlock {
    TSAddUserAlertView *alertView = TSAddUserAlertView.alloc.init;
    alertView.backgroundColor = [[UIColor colorWithRed:48/255.0 green:51/255.0 blue:51/255.0 alpha:1] colorWithAlphaComponent:0.5];
    alertView.frame = view.bounds;
    
    [alertView addSubview:alertView.contentView];
    [alertView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(alertView.mas_width).offset(-90);
    }];
    
    [alertView.contentView addSubview:alertView.addImageBtn];
    [alertView.addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(50);
        make.centerX.mas_equalTo(0);
    }];
    
    [alertView.contentView addSubview:alertView.userNameTextField];
    alertView.userNameTextField.placeholder = textFieldPlace;
    [alertView.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.right.mas_equalTo(-6);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(alertView.addImageBtn.mas_bottom).offset(10);
    }];
    
    alertView.mailBtn.selected = YES;
    [alertView.contentView addSubview:alertView.mailBtn];
    [alertView.mailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alertView.contentView.mas_centerX).multipliedBy(0.5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(alertView.userNameTextField.mas_bottom).offset(10);
    }];
    
    [alertView addSubview:alertView.femailBtn];
    [alertView.femailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alertView.contentView.mas_centerX).multipliedBy(1.5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(alertView.userNameTextField.mas_bottom).offset(10);
    }];
    
    alertView.lineView = UIView.alloc.init;
    alertView.lineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];
    [alertView.contentView addSubview:alertView.lineView];
    [alertView.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView.mailBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(alertView.contentView.mas_width);
        make.left.mas_equalTo(0);
    }];
    
    [alertView.contentView addSubview:alertView.cancelBtn];
    [alertView.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView.lineView.mas_bottom);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(alertView.contentView.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(50);
    }];
    
    [alertView.contentView addSubview:alertView.okBtn];
    [alertView.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView.lineView.mas_bottom);
        make.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(alertView.cancelBtn.mas_right);
        make.height.mas_equalTo(50);
    }];

    UIView *btnLineView = UIView.alloc.init;
    btnLineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];
    [alertView.contentView addSubview:btnLineView];
    [btnLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(.5);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(0);
    }];

    [view addSubview:alertView];
    
    [view layoutIfNeeded];
    
    alertView.alpha = 0;
    alertView.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
        alertView.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    return alertView;
}

- (void)clickBgControl:(id)sender {
    [self dismiss:nil];
}

- (void)dismiss:(void(^)(void))complete {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = .0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        !complete ?: complete();
    }];
}

- (void)clickAddUserAlertViewBtn:(id)sender {
    [self dismiss:^{
        !self.clickAddUserAlertView ?: self.clickAddUserAlertView(self, sender);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.alloc.init;
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)addImageBtn {
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageBtn setImage:ASImage(@"add_image") forState:UIControlStateNormal];
        [_addImageBtn addTarget:self action:@selector(clickAddUserAlertViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        _addImageBtn.layer.cornerRadius = 25;
        _addImageBtn.layer.masksToBounds = YES;
        _addImageBtn.backgroundColor = UIColor.grayColor;
    }
    return _addImageBtn;
}

- (UIButton *)mailBtn {
    if (!_mailBtn) {
        _mailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mailBtn setTitle:@"男" forState:UIControlStateNormal];
        _mailBtn.titleLabel.font = ASFont(16);
        [_mailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_mailBtn setTitleColor:UIColor.blueColor forState:UIControlStateSelected];
        [_mailBtn setImage:ASImageWithHexColor(0xFFFFFF, 1) forState:UIControlStateNormal];
        [_mailBtn setImage:ASImageWithHexColor(0x0000FF, 1) forState:UIControlStateSelected];
        _mailBtn.layer.borderColor = UIColor.blueColor.CGColor;
        _mailBtn.layer.borderWidth = 1.0;
        _mailBtn.layer.cornerRadius = 20;
        _mailBtn.layer.masksToBounds = YES;
        [_mailBtn addTarget:self action:@selector(clickAddUserAlertViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mailBtn;
}

- (UIButton *)femailBtn {
    if (!_femailBtn) {
        _femailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_femailBtn setImage:ASImage(@"add_image") forState:UIControlStateNormal];
        [_femailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_femailBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_femailBtn setImage:ASImageWithHexColor(0xFFFFFF, 1) forState:UIControlStateSelected];
        [_femailBtn setImage:ASImageWithHexColor(0x0000FF, 1) forState:UIControlStateNormal];
        _femailBtn.layer.borderColor = UIColor.blueColor.CGColor;
        _femailBtn.layer.borderWidth = 1.0;
        _femailBtn.layer.cornerRadius = 20;
        _femailBtn.layer.masksToBounds = YES;
        [_femailBtn addTarget:self action:@selector(clickAddUserAlertViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _femailBtn;
}

- (UITextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = UITextField.alloc.init;
        _userNameTextField.textColor = UIColor.blackColor;
        _userNameTextField.font = [UIFont systemFontOfSize:14];
        _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
        _userNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        _userNameTextField.rightViewMode = UITextFieldViewModeAlways;
        _userNameTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        _userNameTextField.layer.cornerRadius = 4;
        _userNameTextField.layer.borderWidth = 1.0;
        _userNameTextField.layer.borderColor = [UIColor colorWithRed:220/255.0 green:230/255.0 blue:226/255.0 alpha:1].CGColor;
    }
    return _userNameTextField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 0;
        [_cancelBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(clickAddUserAlertViewBtn:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _cancelBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_okBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        _okBtn.tag = 1;
        [_okBtn addTarget:self action:@selector(clickAddUserAlertViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}


@end

