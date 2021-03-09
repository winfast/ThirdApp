//
//  TSTableViewCell.m
//  ThirdApp
//
//  Created by QinChuancheng on 2021/3/9.
//

#import "TSTableViewCell.h"

@interface TSTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *selectedLabel;

@end


@implementation TSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self viewsLayout];
    }
    return self;
}

- (void)viewsLayout {
    self.iconImageView = UIImageView.alloc.init;
    self.iconImageView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(8);
        make.bottom.mas_lessThanOrEqualTo(-8).priority(900);
    }];
    
    self.userNameLabel = UILabel.alloc.init;
    self.userNameLabel.textColor = UIColor.blackColor;
    self.userNameLabel.font = ASFont(16);
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.7).priority(900);
    }];
    
    self.selectedLabel = UILabel.alloc.init;
    self.selectedLabel.textColor = UIColor.blueColor;
    self.selectedLabel.font = ASFont(16);
    self.selectedLabel.text = @"✓";
    self.selectedLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.selectedLabel];
    [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectedLabel.hidden = !selected;
}

@end
