//
//  TSBezierPathView.h
//  GHome
//
//  Created by Qincc on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "TSBezierPathModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSBezierPathView : UIView

//0 表示摄氏度。1 表示华氏度
@property (nonatomic) NSInteger showTempType;
//温度列表（按照时间排序）
@property (nonatomic, copy) NSArray<TSBezierPathModel *> *dataSource;

// y轴的平均距离
@property (nonatomic) CGFloat axisYAverageValue;

//左边x轴移动的距离
@property (nonatomic) CGFloat leftAxisX;

//右边x轴移动的距离
@property (nonatomic) CGFloat rightAxisX;

//下边移动Y
@property (nonatomic) CGFloat bottomAxisY;
@property (nonatomic) CGFloat startbottomAxisY;

//上边移动Y
@property (nonatomic) CGFloat topAxisY;

// 默认七条线条
@property (nonatomic) NSInteger axisXLineCount;

@property (nonatomic) CGFloat maxYValue;
@property (nonatomic) CGFloat minYValue;

@end

NS_ASSUME_NONNULL_END
