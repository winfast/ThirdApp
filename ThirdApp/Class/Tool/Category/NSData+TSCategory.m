//
//  NSData+TSCategory.m
//  GHome
//
//  Created by Qincc on 2021/3/15.
//

#import "NSData+TSCategory.h"

NSString const *DeviceMacAddress = @"DeviceMacAddress";
NSString const *DeviceTempUnit = @"DeviceTempUnit";
NSString const *DeviceCommand = @"DeviceCommand";
NSString const *DeviceTempValue = @"DeviceTempValue";
NSString const *DeviceTempCreateTime = @"DeviceTempCreateTime";

@implementation NSData (TSCategory)

+ (void)testData {
    /*
    tempUnit = 26
     deviceCommand = 1
     payloadLenth = 20
     showTemp = 368
     year = 20, showMoth = 3, showDay = 15, showHour = 23, minute = 15, second = 53
     */
	char testChar[] = {
		0xFE,   //tou
		0x01, 0x11, 0x22, 0x33, 0x44, 0x55, //mac 地址
		0x1A,  //0x1A摄氏度 0x15华氏度
		0x01, //测量体温
		0x14, //长度
		0x24,//温度高字节
		0x08, //温度低字节
		0x14,
		0x35,
		0x57,
		0x0F,
		0x35,
		0x00,
		0x0D,
		0x0A
	};
	NSData *data = [NSData dataWithBytes:testChar length:20];
	[data dictFromDeviceData];
}

- (NSDictionary *)dictFromDeviceData {

	if (self.length == 8) {
		
		return nil;
	}
	
	char deviceMacAddr[] = {0};
	[self getBytes:deviceMacAddr range:NSMakeRange(1, 6)];
	NSString *deviceMacAddrStr = [[NSString alloc] initWithBytes:deviceMacAddr length:6 encoding:NSUTF8StringEncoding];
	
	UInt8 tempUnit = 0;
	[self getBytes:&tempUnit range:NSMakeRange(7, 1)];
	NSLog(@"tempUnit = %d", tempUnit);
	
	UInt8 deviceCommand = 0;
	[self getBytes:&deviceCommand range:NSMakeRange(8, 1)];
	NSLog(@"deviceCommand = %d", deviceCommand);
	
	UInt8 payloadLenth = 0;
	[self getBytes:&payloadLenth range:NSMakeRange(9, 1)];
	NSLog(@"payloadLenth = %d", payloadLenth);
	
	UInt8 bigTemp = 0;  //大端在前 10～11
	[self getBytes:&bigTemp range:NSMakeRange(10, 1)];
	
	UInt8 littleTemp = 0;  //大端在前 10～11
	[self getBytes:&littleTemp range:NSMakeRange(11, 1)];
	UInt16 showTemp = bigTemp * 10 + littleTemp;
	NSLog(@"showTemp = %d", showTemp);
	
	UInt8 year = 0;
	[self getBytes:&year range:NSMakeRange(12, 1)];
	
	UInt8 month = 0;
	[self getBytes:&month range:NSMakeRange(13, 1)];
	//0~3表示日的低字节。 4～7表示月分
	UInt8 showMonth = month >> 4;
	UInt8 showLittleDay = month & 0B00001111;
	
	UInt8 hour = 0;
	[self getBytes:&hour range:NSMakeRange(14, 1)];
	//6~7表示日期的高字节。0～5表示小时
	UInt8 showHour = hour & 0B00111111;
	UInt8 showBigDay = (hour >> 6) & 0B11;
	
	UInt8 showDay = showBigDay * 10 + showLittleDay;
	
	UInt8 minute = 0;
	[self getBytes:&minute range:NSMakeRange(15, 1)];
	
	UInt8  second = 0;
	[self getBytes:&second range:NSMakeRange(16, 1)];
	
	NSLog(@"year = %d, showMoth = %d, showDay = %d, showHour = %d, minute = %d, second = %d", year, showMonth,  showDay, showHour, minute, second);
	
	return @{
		@"":@"",
		@"":@""
	};
}

+ (NSData *)postConnectData {
	char postChar[] = {0xFE, 0xFD, 0xAA, 0xA0, 0x0D, 0x0A};
	return [NSData dataWithBytes:postChar length:6];
}

+ (NSData *)postCloseDeviceData {
	char postChar[] = {0xFE, 0xFD, 0xAA, 0x91, 0x0D, 0x0A};
	return [NSData dataWithBytes:postChar length:6];
}

@end
