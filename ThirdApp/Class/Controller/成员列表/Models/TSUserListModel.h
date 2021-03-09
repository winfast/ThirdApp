//
//  TSUserListModel.h
//  ThirdApp
//
//  Created by Qincc on 2021/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSUserListModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userBirthday;
@property (nonatomic, copy) NSString *userCover;

@property (nonatomic) BOOL userSex;

@end

NS_ASSUME_NONNULL_END
