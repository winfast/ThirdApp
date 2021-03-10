//
//  TSBezierPathView.m
//  GHome
//
//  Created by Qincc on 2021/3/10.
//

#import "TSBezierPathView.h"

@interface TSBezierPathView ()


@end

@implementation TSBezierPathView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	[super drawRect:rect];
	
	CGRect frame = self.frame;
	CGFloat height = frame.size.height;
	CGFloat width = frame.size.width;
	CGFloat startY = height - self.bottomAxisY;
	CGFloat startX = self.leftAxisX;
	
	//绘制X轴
	CGFloat axisXDis = (frame.size.height - self.topAxisY - self.bottomAxisY)/(CGFloat)(self.axisXLineCount - 1);
	UIBezierPath *lineBezierPath = [UIBezierPath bezierPath];
	lineBezierPath.lineWidth = 0.5;
	
	//写X轴的值
	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
	[style setAlignment:NSTextAlignmentRight];
	NSString *maxText = [@(37.9) stringValue];
	CGSize maxFontSize = [maxText sizeWithAttributes:@{NSFontAttributeName:ASFont(10)}];
	
	for (NSInteger index = 0; index < self.axisXLineCount; ++index) {
		[lineBezierPath moveToPoint:CGPointMake(startX, startY - index * axisXDis)];
		[lineBezierPath addLineToPoint:CGPointMake(width - self.rightAxisX, startY - index * axisXDis)];
		
		NSString *text = [NSString stringWithFormat:@"%.1f",((CGFloat)32.8 + (CGFloat)0.8 * index)];
		NSDictionary *attr = @{NSParagraphStyleAttributeName:style, NSFontAttributeName:ASFont(10), NSForegroundColorAttributeName:ASColorHex(0x999999)};
		[text drawInRect:CGRectMake(0, startY - index * axisXDis - maxFontSize.height * 0.5, startX - 3, maxFontSize.height) withAttributes:attr];
	};
	[UIColor.grayColor setStroke];
	[lineBezierPath stroke];
	
	//绘制Y轴
	CGFloat axisYDis = self.axisYAverageValue;
	UIBezierPath *axisYLineBezierPath = [UIBezierPath bezierPath];
	lineBezierPath.lineWidth = 0.5;
	
	//写Y轴的值
	NSMutableParagraphStyle* axisXstyle = [[NSMutableParagraphStyle alloc] init];
	[axisXstyle setAlignment:NSTextAlignmentCenter];
	NSString *maxAxisXText = @"15:04\r2021/03/06";
	CGSize maxAxisXFontSize = [maxAxisXText sizeWithAttributes:@{NSFontAttributeName:ASFont(10)}];
	
	for (NSInteger index = 0; index < 6; ++index) {
		[axisYLineBezierPath moveToPoint:CGPointMake(startX + axisYDis * index, 0)];
		[axisYLineBezierPath addLineToPoint:CGPointMake(startX + axisYDis * index, height - self.bottomAxisY)];
		
		NSString *text = @"15:04\r2021/03/06";
		NSDictionary *attr = @{NSParagraphStyleAttributeName:axisXstyle, NSFontAttributeName:ASFont(10), NSForegroundColorAttributeName:ASColorHex(0x999999)};
		[text drawInRect:CGRectMake(0 + axisYDis * index, height - self.bottomAxisY, 60, maxAxisXFontSize.height) withAttributes:attr];
	}
	[UIColor.grayColor setStroke];
	[axisYLineBezierPath stroke];
}

@end
