//
//  GHAlertView.m
//  GHAlertView
//
//  Created by Qincc on 2020/12/11.
//

#import "GHAlertView.h"
#import <Masonry/Masonry.h>

@interface GHAlertView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, copy) GHAlertViewClickBlock clickBlock;


@end

@implementation GHAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(clickBgControl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
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

+ (instancetype)showWithView:(UIView *)view
                       title:(NSString *)title
              textFieldPlace:(NSString *)textFieldPlace
                  okBtnTitle:(NSString *)okBtnTitle
              cancelBtnTitle:(NSString *)cancelBtnTitle
                 configBlock:(void (^)(GHAlertView *alertView))configBlock
                    btnBlock:(GHAlertViewClickBlock)clickBlock {
    
    if (title.length == 0) {
        return nil;
    }
    
    GHAlertView *alertView = GHAlertView.alloc.init;
    alertView.backgroundColor = [[UIColor colorWithRed:48/255.0 green:51/255.0 blue:51/255.0 alpha:1] colorWithAlphaComponent:0.5];
    alertView.frame = view.bounds;
    
    [alertView addSubview:alertView.contentView];
    [alertView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(alertView.mas_width).offset(-95);
    }];
    
    alertView.titleLabel.text = title;
    [alertView.contentView addSubview:alertView.titleLabel];
    [alertView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(alertView.contentView.mas_width).offset(-20 * 2);
        make.height.mas_equalTo(48);
    }];
    
    NSAttributedString *atrtr = [NSAttributedString.alloc initWithString:textFieldPlace attributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName:[UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1]
    }];
    alertView.inputTextField.attributedPlaceholder = atrtr;
    [alertView.contentView addSubview:alertView.inputTextField];
    [alertView.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView.titleLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(36);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    alertView.lineView = UIView.alloc.init;
    alertView.lineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];
    [alertView.contentView addSubview:alertView.lineView];
    [alertView.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView.inputTextField.mas_bottom).offset(20);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(alertView.contentView.mas_width);
        make.left.mas_equalTo(0);
    }];
    
    if (cancelBtnTitle.length > 0) {
        [alertView.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
        [alertView.cancelBtn addTarget:alertView action:@selector(clickAlertBtn:) forControlEvents:UIControlEventTouchUpInside];
        [alertView.contentView addSubview:alertView.cancelBtn];
        
        [alertView.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alertView.lineView.mas_bottom);
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(alertView.contentView.mas_width).multipliedBy(0.5);
            make.height.mas_equalTo(50);
        }];
    }
    
    if (okBtnTitle.length > 0) {
        [alertView.okBtn setTitle:okBtnTitle forState:UIControlStateNormal];
        [alertView.okBtn addTarget:alertView action:@selector(clickAlertBtn:) forControlEvents:UIControlEventTouchUpInside];
        [alertView.contentView addSubview:alertView.okBtn];
        
        [alertView.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alertView.lineView.mas_bottom);
            make.right.bottom.mas_equalTo(0);
            if (cancelBtnTitle.length > 0) {
                make.left.mas_equalTo(alertView.cancelBtn.mas_right);
            } else{
                make.left.mas_equalTo(0);
            }
            make.height.mas_equalTo(50);
        }];
    }
    
    if (okBtnTitle.length > 0 && cancelBtnTitle.length > 0) {
        UIView *btnLineView = UIView.alloc.init;
        btnLineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];;
        [alertView.contentView addSubview:btnLineView];
        [btnLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(0);
        }];
    }
    
    [view addSubview:alertView];
    
    if (configBlock) {
        configBlock(alertView);
    }
    
    [view layoutIfNeeded];
    
    alertView.alpha = 0;
    alertView.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
        alertView.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    [alertView.inputTextField becomeFirstResponder];
    alertView.clickBlock = clickBlock;
    return alertView;
}

+ (instancetype)showWithView:(UIView *)view
                   imageName:(NSString *)imageName
                       title:(NSString *)title
                     message:(NSString *)message
                  okBtnTitle:(NSString *)okBtnTitle
              cancelBtnTitle:(NSString *)cancelBtnTitle
                 configBlock:(void (^)(GHAlertView *alertView))configBlock
                    btnBlock:(GHAlertViewClickBlock)clickBlock {
    
    if (message.length == 0 && title.length == 0 ) {
        return nil;
    }
    
    if (okBtnTitle.length == 0 && cancelBtnTitle.length == 0 ) {
        return nil;
    }
    
    GHAlertView *alertView = GHAlertView.alloc.init;
    alertView.backgroundColor = [[UIColor colorWithRed:48/255.0 green:51/255.0 blue:51/255.0 alpha:1] colorWithAlphaComponent:0.5];
    alertView.frame = view.bounds;
    
    [alertView addSubview:alertView.contentView];
    [alertView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(alertView.mas_width).offset(-95);
    }];
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (image) {
        alertView.topImageView = UIImageView.alloc.init;
        alertView.topImageView.backgroundColor = UIColor.whiteColor;
        alertView.topImageView.image = image;
        [alertView.contentView addSubview:alertView.topImageView];
        [alertView.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(48, 48));
            make.centerX.mas_equalTo(0);
        }];
    }
    
    if (title.length > 0) {
        alertView.titleLabel.text = title;
        [alertView.contentView addSubview:alertView.titleLabel];
        [alertView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (alertView.topImageView) {
                make.top.mas_equalTo(alertView.topImageView.mas_bottom).offset(20);
            } else {
                make.top.mas_equalTo(20);
            }
            
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(alertView.contentView.mas_width).offset(-20 * 2);
        }];
    }
    
    if (message.length > 0) {
        alertView.messageLabel.text = message;
        [alertView.contentView addSubview:alertView.messageLabel];
        if (title.length > 0) {
            [alertView.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(alertView.titleLabel.mas_bottom).offset(20);
                make.centerX.mas_equalTo(0);
                make.width.mas_equalTo(alertView.contentView.mas_width).offset(-20 * 2);
            }];
            
        } else {
            [alertView.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (alertView.topImageView) {
                    make.top.mas_equalTo(alertView.topImageView.mas_bottom).offset(20);
                } else {
                    make.top.mas_equalTo(20);
                }
                make.centerX.mas_equalTo(0);
                make.width.mas_equalTo(alertView.contentView.mas_width).offset(-20 * 2);
            }];
        }
    }
    
    alertView.lineView = UIView.alloc.init;
    alertView.lineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];
    [alertView.contentView addSubview:alertView.lineView];
    [alertView.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (message.length > 0) {
            make.top.mas_equalTo(alertView.messageLabel.mas_bottom).offset(20);
        } else {
            make.top.mas_equalTo(alertView.titleLabel.mas_bottom).offset(20);
        }
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(alertView.contentView.mas_width);
        make.left.mas_equalTo(0);
    }];
    
    if (cancelBtnTitle.length > 0) {
        [alertView.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
        [alertView.cancelBtn addTarget:alertView action:@selector(clickAlertBtn:) forControlEvents:UIControlEventTouchUpInside];
        [alertView.contentView addSubview:alertView.cancelBtn];
        
        [alertView.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alertView.lineView.mas_bottom);
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(alertView.contentView.mas_width).multipliedBy(0.5);
            make.height.mas_equalTo(50);
        }];
    }
    
    if (okBtnTitle.length > 0) {
        [alertView.okBtn setTitle:okBtnTitle forState:UIControlStateNormal];
        [alertView.okBtn addTarget:alertView action:@selector(clickAlertBtn:) forControlEvents:UIControlEventTouchUpInside];
        [alertView.contentView addSubview:alertView.okBtn];
        
        [alertView.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alertView.lineView.mas_bottom);
            make.right.bottom.mas_equalTo(0);
            if (cancelBtnTitle.length > 0) {
                make.left.mas_equalTo(alertView.cancelBtn.mas_right);
            } else{
                make.left.mas_equalTo(0);
            }
            make.height.mas_equalTo(50);
        }];
    }
    
    if (okBtnTitle.length > 0 && cancelBtnTitle.length > 0) {
        UIView *btnLineView = UIView.alloc.init;
        btnLineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];
        [alertView.contentView addSubview:btnLineView];
        [btnLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(.5);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.centerX.mas_equalTo(0);
        }];
    }

    [view addSubview:alertView];
    
    if (configBlock) {
        configBlock(alertView);
    }
    
    [view layoutIfNeeded];
    
    alertView.alpha = 0;
    alertView.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
        alertView.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    alertView.clickBlock = clickBlock;
    
    return alertView;
}


+ (instancetype)showWithView:(UIView *)view
                       title:(NSString *)title
                     message:(NSString *)message
              cancelBtnTitle:(NSString *)cancelBtnTitle
                 configBlock:(void (^)(GHAlertView *alertView))configBlock
                    btnBlock:(GHAlertViewClickBlock)clickBlock
              otherBtnTitles:(NSString *)otherBtnTitles,... {
    if (message.length == 0 && title.length == 0 ) {
        return nil;
    }
    
    if (cancelBtnTitle.length == 0 ) {
        return nil;
    }
    
    va_list params; //定义一个指向个数可变的参数列表指针;
    va_start(params,otherBtnTitles);//va_start 得到第一个可变参数地址,
    NSMutableArray *btnsArray = NSMutableArray.alloc.init;
    [btnsArray addObject:otherBtnTitles];
    while (1) {
        id obj = va_arg(params, id);
        if (obj == nil) {
            break;
        }
        [btnsArray addObject:obj];
    }
    va_end(params);
    
    if (btnsArray.count < 2) {
        return [GHAlertView showWithView:view imageName:nil title:title message:message okBtnTitle:btnsArray.count > 0 ? btnsArray.firstObject : nil cancelBtnTitle:cancelBtnTitle configBlock:configBlock btnBlock:clickBlock];
    }
    
    GHAlertView *alertView = GHAlertView.alloc.init;
    alertView.backgroundColor = [[UIColor colorWithRed:48/255.0 green:51/255.0 blue:51/255.0 alpha:1] colorWithAlphaComponent:0.5];
    alertView.frame = view.bounds;
    
    [alertView addSubview:alertView.contentView];
    [alertView.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(alertView.mas_width).offset(-95);
    }];
    
    if (title.length > 0) {
        alertView.titleLabel.text = title;
        [alertView.contentView addSubview:alertView.titleLabel];
        [alertView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(48);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(alertView.contentView.mas_width).offset(-20 * 2);
        }];
    }
    
    if (message.length > 0) {
        alertView.messageLabel.text = message;
        [alertView.contentView addSubview:alertView.messageLabel];
        if (title.length > 0) {
            [alertView.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(alertView.titleLabel.mas_bottom).offset(20);
                make.centerX.mas_equalTo(0);
                make.width.mas_equalTo(alertView.contentView.mas_width).offset(-20 * 2);
            }];
            
        } else {
            [alertView.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(20);
                make.centerX.mas_equalTo(0);
                make.width.mas_equalTo(alertView.contentView.mas_width).offset(-20 * 2);
            }];
        }
    }
    
    UIButton *preBtn;
    for (NSInteger index = btnsArray.count - 1; index >= 0; --index) {
        UIView *btnLineView = UIView.alloc.init;
        btnLineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];
        [alertView.contentView addSubview:btnLineView];
        [btnLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            if (index == btnsArray.count - 1) {
                if (message.length > 0) {
                    make.top.mas_equalTo(alertView.messageLabel.mas_bottom).offset(20);
                } else {
                    make.top.mas_equalTo(alertView.titleLabel.mas_bottom).offset(20);
                }
            } else {
                make.top.mas_equalTo(preBtn.mas_bottom).offset(0);
            }
        }];
        
        UIButton * otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherBtn setTitle:btnsArray[index] forState:UIControlStateNormal];
        [otherBtn setTitleColor:[UIColor colorWithRed:11/255.0 green:208/255.0 blue:135/255.0 alpha:1] forState:UIControlStateNormal];
        [otherBtn addTarget:alertView action:@selector(clickAlertBtn:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.tag = index + 1;
        [alertView.contentView addSubview:otherBtn];
        [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(btnLineView.mas_bottom).offset(0);
        }];
        
        preBtn = otherBtn;
    }
    
    
    alertView.lineView = UIView.alloc.init;
    alertView.lineView.backgroundColor = [UIColor colorWithRed:193/255.0 green:204/255.0 blue:201/255.0 alpha:1];
    [alertView.contentView addSubview:alertView.lineView];
    [alertView.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(preBtn.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(alertView.contentView.mas_width);
        make.left.mas_equalTo(0);
    }];
    
    
    [alertView.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
    [alertView.cancelBtn addTarget:alertView action:@selector(clickAlertBtn:) forControlEvents:UIControlEventTouchUpInside];
    [alertView.contentView addSubview:alertView.cancelBtn];
    
    [alertView.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView.lineView.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];


    [view addSubview:alertView];
    
    if (configBlock) {
        configBlock(alertView);
    }
    
    [view layoutIfNeeded];
    
    alertView.alpha = 0;
    alertView.contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
        alertView.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    alertView.clickBlock = clickBlock;
    return alertView;
}


- (void)clickAlertBtn:(UIButton *)sender {
    [self dismiss:^{
        !self.clickBlock ?:self.clickBlock(self, [sender tag]);
    }];
}

#pragma lazy laod
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.alloc.init;
        _contentView.backgroundColor = UIColor.whiteColor;
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.alloc.init;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = UILabel.alloc.init;
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.textColor = UIColor.blackColor;
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = UITextField.alloc.init;
        _inputTextField.tintColor = [UIColor colorWithRed:11/255.0 green:208/255.0 blue:135/255.0 alpha:1];
        _inputTextField.textColor = [UIColor colorWithRed:48/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _inputTextField.font = [UIFont systemFontOfSize:14];
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _inputTextField.rightViewMode = UITextFieldViewModeAlways;
        _inputTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        _inputTextField.layer.cornerRadius = 4;
        _inputTextField.layer.borderWidth = 1.0;
        _inputTextField.layer.borderColor = [UIColor colorWithRed:220/255.0 green:230/255.0 blue:226/255.0 alpha:1].CGColor;
    }
    return _inputTextField;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 0;
        [_cancelBtn setTitleColor:[UIColor colorWithRed:48/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _cancelBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_okBtn setTitleColor:[UIColor colorWithRed:11/255.0 green:208/255.0 blue:135/255.0 alpha:1] forState:UIControlStateNormal];
        _okBtn.tag = 1;
    }
    return _okBtn;
}

@end
