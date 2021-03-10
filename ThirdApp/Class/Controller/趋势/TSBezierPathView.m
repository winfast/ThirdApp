//
//  TSBezierPathView.m
//  GHome
//
//  Created by Qincc on 2021/3/10.
//

#import "TSBezierPathView.h"

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

@interface TSBezierPathView ()

@property (nonatomic, copy) NSArray<NSValue *> *pointValue;

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
	CGFloat startY = height - self.startbottomAxisY;
	CGFloat startX = self.leftAxisX;
	
	//绘制X轴
	CGFloat axisXDis = (frame.size.height - self.topAxisY - self.startbottomAxisY)/(CGFloat)(self.axisXLineCount - 1);
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
	
	//绘制最下面的那条横线
	[lineBezierPath moveToPoint:CGPointMake(startX, height- self.bottomAxisY)];
	[lineBezierPath addLineToPoint:CGPointMake(width - self.rightAxisX, height- self.bottomAxisY)];
	
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
	
	for (NSInteger index = 0; index < self.dataSource.count; ++index) {
		[axisYLineBezierPath moveToPoint:CGPointMake(startX + axisYDis * index, 0)];
		[axisYLineBezierPath addLineToPoint:CGPointMake(startX + axisYDis * index, height - self.bottomAxisY)];
		
		NSString *text = @"15:04\r2021/03/06";
		NSDictionary *attr = @{NSParagraphStyleAttributeName:axisXstyle, NSFontAttributeName:ASFont(10), NSForegroundColorAttributeName:ASColorHex(0x999999)};
		[text drawInRect:CGRectMake(0 + axisYDis * index, height - self.bottomAxisY, 60, maxAxisXFontSize.height) withAttributes:attr];
	}
	[UIColor.grayColor setStroke];
	[axisYLineBezierPath stroke];
	
	//绘制温度曲线
	NSMutableArray<NSValue *> *tempPoint = NSMutableArray.alloc.init;
	//计算每个像素大约的温度
	CGFloat averageTempWithPt = (height - self.topAxisY - self.startbottomAxisY)/(37.6  - 32.8);
	
	UIBezierPath *tempPath = [UIBezierPath bezierPath];
	tempPath.lineJoinStyle = kCGLineJoinRound;
	tempPath.lineWidth = 2;
	for (NSInteger index = 0; index < self.dataSource.count; ++index) {
		TSBezierPathModel *model = self.dataSource[index];
		CGPoint pt;
		pt.x = startX + self.axisYAverageValue *index;
		pt.y = (37.6 - model.sheshiduValue) * averageTempWithPt + self.topAxisY;
		[tempPoint addObject:[NSValue valueWithCGPoint:pt]];
		if (index == 0) {
			[tempPath moveToPoint:pt];
		} else {
			[tempPath addLineToPoint:pt];
		}
	}
	[[UIColor redColor] setStroke];
	[tempPath stroke];
	

	CGSize maxTempSize = [maxText sizeWithAttributes:@{NSFontAttributeName:ASFont(12)}];
	for (NSInteger index = 0; index < self.dataSource.count; ++index) {
		TSBezierPathModel *model = self.dataSource[index];
		CGPoint pt;
		pt.x = startX + self.axisYAverageValue *index;
		pt.y = (37.6 - model.sheshiduValue) * averageTempWithPt + self.topAxisY;
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(pt.x - 3, pt.y - 3, 6, 6)];
		circlePath.lineWidth = 2;
		[UIColor.redColor setStroke];
		[UIColor.whiteColor setFill];
		[circlePath stroke];
		[circlePath fill];
		
		// 写当前温度
		NSString *text = [NSString stringWithFormat:@"%.1f",model.sheshiduValue];
		NSDictionary *attr = @{NSParagraphStyleAttributeName:style, NSFontAttributeName:ASFont(10), NSForegroundColorAttributeName:UIColor.blackColor};
		[text drawInRect:CGRectMake(pt.x - maxTempSize.width * 0.5 - 2, pt.y - 5 - maxTempSize.height, maxTempSize.width + 4, maxFontSize.height) withAttributes:attr];
	}

//	UIBezierPath *path = [self smoothedPathWithPoints:tempPoint andGranularity:8];
//	path.lineWidth = 2;
//	[[UIColor redColor] setStroke];
//	[path stroke];
}

/// 返回平滑的贝塞尔曲线
/// @param pointsArray 坐标点
/// @param granularity 颗粒度  越大越平滑, 但是点越多
- (UIBezierPath *)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity {
	if (pointsArray.count == 0) {
		return nil;
	}
 
	NSMutableArray *points = [pointsArray mutableCopy];
	UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
	smoothedPath.lineWidth = 1;
	// Add control points to make the math make sense
	[points insertObject:[points objectAtIndex:0] atIndex:0];
	[points addObject:[points lastObject]];
	[smoothedPath moveToPoint:POINT(0)];
	for (NSUInteger index = 1; index < points.count - 2; index++) {
		CGPoint p0 = POINT(index - 1);
		CGPoint p1 = POINT(index);
		CGPoint p2 = POINT(index + 1);
		CGPoint p3 = POINT(index + 2);
		// now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
		for (int i = 1; i < granularity; i++) {
			float t = (float) i * (1.0f / (float) granularity);
			float tt = t * t;
			float ttt = tt * t;
			CGPoint pi; // intermediate point
			pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
			pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
		}
		// Now add p2
		[smoothedPath addLineToPoint:p2];
	}

	// finish by adding the last point
	[smoothedPath addLineToPoint:POINT(points.count - 1)];
	smoothedPath.lineJoinStyle = kCGLineJoinRound;
	return smoothedPath;
}

- (CGFloat)convertPointY:(CGFloat)pointY {
	return self.frame.size.height - self.bottomAxisY - pointY;
}

/*

 - (UIBezierPath *)bezierPathWithText:(NSString *)text font:(UIFont *)font
 {
	 CTFontRef ctFont =  CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);;
	 if (!ctFont) return nil;
	 NSDictionary *attrs = @{ (__bridge id)kCTFontAttributeName:(__bridge id)ctFont };
	 NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
	 CFRelease(ctFont);
	 
	 CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)attrString);
	 if (!line) return nil;
	 
	 CGMutablePathRef cgPath = CGPathCreateMutable();
	 CFArrayRef runs = CTLineGetGlyphRuns(line);
	 for (CFIndex iRun = 0, iRunMax = CFArrayGetCount(runs); iRun < iRunMax; iRun++) {
		 CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runs, iRun);
		 CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
		 
		 for (CFIndex iGlyph = 0, iGlyphMax = CTRunGetGlyphCount(run); iGlyph < iGlyphMax; iGlyph++) {
			 CFRange glyphRange = CFRangeMake(iGlyph, 1);
			 CGGlyph glyph;
			 CGPoint position;
			 CTRunGetGlyphs(run, glyphRange, &glyph);
			 CTRunGetPositions(run, glyphRange, &position);
			 
			 CGPathRef glyphPath = CTFontCreatePathForGlyph(runFont, glyph, NULL);
			 if (glyphPath) {
				 CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
				 CGPathAddPath(cgPath, &transform, glyphPath);
				 CGPathRelease(glyphPath);
			 }
		 }
	 }
	 UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
	 CGRect boundingBox = CGPathGetPathBoundingBox(cgPath);
	 CFRelease(cgPath);
	 CFRelease(line);
	 
	 [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
	 [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
	 return path;
 }

 

 //增加渐变效果
 - (void)drawLinearGradientWithPath:(CGPathRef)path
						 startColor:(CGColorRef)startColor
						   endColor:(CGColorRef)endColor
 {
	 CGContextRef context = UIGraphicsGetCurrentContext();
	 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	 CGFloat locations[] = {0.0, 1.0};
	 
	 NSArray *colors = @[(__bridge id)startColor,(__bridge id)endColor];
	 CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors,locations);
	 CGRect pathRect = CGPathGetBoundingBox(path);
	 
	 //具体方向可根据需求修改
	 CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
	 CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMaxY(pathRect));
	 
	 CGContextSaveGState(context);
	 CGContextAddPath(context, path);
	 CGContextClip(context);
	 CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	 CGContextRestoreGState(context);
	 CGGradientRelease(gradient);
	 CGColorSpaceRelease(colorSpace);
 }

 */

@end
