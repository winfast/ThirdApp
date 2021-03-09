//
//  TSTableViewCell.h
//  ThirdApp
//
//  Created by QinChuancheng on 2021/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UILabel *userNameLabel;
@property (nonatomic, strong, readonly) UILabel *selectedLabel;

@end

NS_ASSUME_NONNULL_END
