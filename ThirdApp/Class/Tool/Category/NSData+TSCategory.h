//
//  NSData+TSCategory.h
//  GHome
//
//  Created by Qincc on 2021/3/15.
//

#import <Foundation/Foundation.h>


@interface NSData (TSCategory)

- (NSDictionary *)dictFromDeviceData;

+ (NSData *)postConnectData;

+ (NSData *)postCloseDeviceData;

+ (void)testData;

@end

