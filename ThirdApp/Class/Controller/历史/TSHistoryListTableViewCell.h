//
//  TSHistoryListTableViewCell.h
//  GHome
//
//  Created by Qincc on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "TSHistoryModel.h"


@interface TSHistoryListTableViewCell : UITableViewCell

- (void)bindHistoryModel:(TSHistoryModel *)model;

@end

