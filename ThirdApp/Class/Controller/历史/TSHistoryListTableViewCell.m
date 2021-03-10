//
//  TSHistoryListTableViewCell.m
//  GHome
//
//  Created by Qincc on 2021/3/10.
//

#import "TSHistoryListTableViewCell.h"

@interface TSHistoryListTableViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *sheshiduLabel;
@property (nonatomic, strong) UILabel *huashiduLabel;

@end

@implementation TSHistoryListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		UILabel *timeLabel = UILabel.alloc.init;
		self.timeLabel = timeLabel;
		timeLabel.textColor = UIColor.blackColor;
		timeLabel.textAlignment = NSTextAlignmentCenter;
		timeLabel.text = @"18:00\n1984/09/05";
		timeLabel.numberOfLines = 2;
		timeLabel.font = ASFont(14);
		[self.contentView addSubview:timeLabel];
		[timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(0);
			make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1/3.0);
			make.height.mas_equalTo(40);
			make.top.mas_equalTo(5);
			make.bottom.mas_lessThanOrEqualTo(-5).priority(900);
		}];
		
		UILabel *shesiduLabel = UILabel.alloc.init;
		self.sheshiduLabel = shesiduLabel;
		shesiduLabel.textColor = UIColor.blackColor;
		shesiduLabel.textAlignment = NSTextAlignmentCenter;
		shesiduLabel.text = @"摄氏度(°C)";
		shesiduLabel.font = ASFont(14);
		[self.contentView addSubview:shesiduLabel];
		[shesiduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.mas_equalTo(0);
			make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1/3.0);
			make.centerY.mas_equalTo(0);
		}];
		
		UILabel *huashiduLabel = UILabel.alloc.init;
		self.huashiduLabel = huashiduLabel;
		huashiduLabel.textColor = UIColor.blackColor;
		huashiduLabel.textAlignment = NSTextAlignmentCenter;
		huashiduLabel.text = @"华氏度(°F)";
		huashiduLabel.font = ASFont(14);
		[self.contentView addSubview:huashiduLabel];
		[huashiduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(0);
			make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1/3.0);
			make.centerY.mas_equalTo(0);
		}];
	}
	return self;
}

- (void)bindHistoryModel:(TSHistoryModel *)model {
	self.timeLabel.text = model.temperatureTime;
	self.huashiduLabel.text = model.huashiduValue;
	self.sheshiduLabel.text = model.sheshiduValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
