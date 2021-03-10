//
//  TSHistoryModel.h
//  GHome
//
//  Created by Qincc on 2021/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSHistoryModel : NSObject

//数据库自带的
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *sheshiduValue;
@property (nonatomic, copy) NSString *huashiduValue;
@property (nonatomic, copy) NSString *temperatureTime;

@end

NS_ASSUME_NONNULL_END
