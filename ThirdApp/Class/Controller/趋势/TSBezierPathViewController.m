//
//  TSBezierPathViewController.m
//  GHome
//
//  Created by Qincc on 2021/3/10.
//

#import "TSBezierPathViewController.h"
#import "TSBezierPathView.h"

@interface TSBezierPathViewController ()

//@property (nonatomic, strong) UISeg *control;

@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) TSBezierPathView *bezierPathView;

@end

@implementation TSBezierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.hbd_barAlpha = 0.0f;
	self.hbd_barShadowHidden = YES;
	[self.view addSubview:self.segControl];
	[self.segControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.height.mas_equalTo(44);
		make.top.mas_equalTo(ASNavBarHeight);
		make.width.mas_equalTo(160);
	}];
	
	self.unitLabel.text = @"°C";
	[self.view addSubview:self.unitLabel];
	[self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(20);
		make.top.mas_equalTo(self.segControl.mas_bottom).offset(5);
	}];
	
	[self.view addSubview:self.bezierPathView];
	self.bezierPathView.leftAxisX = 30;
	self.bezierPathView.rightAxisX = 16;
	self.bezierPathView.topAxisY = 16;
	self.bezierPathView.bottomAxisY = 30;
	self.bezierPathView.axisXLineCount = 7;
	self.bezierPathView.axisYAverageValue = 65;
	[self.bezierPathView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(0);
		make.height.mas_equalTo(self.bezierPathView.mas_width);
		make.top.mas_equalTo(self.unitLabel.mas_bottom).offset(5);
	}];
	
	[self.bezierPathView setNeedsDisplay];
}

- (void)clickSegControlBtn:(id)sender {
	if (self.segControl.selectedSegmentIndex == 0) {
		self.unitLabel.text = @"°C";
	} else  {
		self.unitLabel.text = @"°F";
	}
}

- (UISegmentedControl *)segControl {
	if (!_segControl) {
		_segControl = [UISegmentedControl.alloc initWithItems:@[@"摄氏度", @"华氏度"]];
//		[_segControl]
		[_segControl setTitleTextAttributes:@{
			NSFontAttributeName:ASFont(16),
			NSForegroundColorAttributeName:UIColor.blackColor,
		} forState:UIControlStateNormal];
		[_segControl setTitleTextAttributes:@{
			NSFontAttributeName:ASFont(16),
			NSForegroundColorAttributeName:UIColor.whiteColor,
		} forState:UIControlStateSelected];
		[_segControl addTarget:self action:@selector(clickSegControlBtn:) forControlEvents:UIControlEventValueChanged];
		_segControl.layer.cornerRadius = 4;
		_segControl.layer.borderWidth = 1;
		_segControl.layer.masksToBounds = YES;
		_segControl.layer.borderColor = UIColor.blueColor.CGColor;
		[_segControl setSelectedSegmentIndex:0];
		_segControl.tintColor = UIColor.blueColor;
	}
	return _segControl;
}

- (UILabel *)unitLabel {
	if (!_unitLabel) {
		_unitLabel = UILabel.alloc.init;
		_unitLabel.backgroundColor = UIColor.whiteColor;
		_unitLabel.font = ASFont(14);
		_unitLabel.textColor = UIColor.grayColor;
	}
	return _unitLabel;
}

- (TSBezierPathView *)bezierPathView {
	if (!_bezierPathView) {
		_bezierPathView = TSBezierPathView.alloc.init;
		_bezierPathView.backgroundColor = UIColor.whiteColor;
	}
	return _bezierPathView;
}

/*
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
			 
			 //如果超出界限, 则不绘制不绘制该曲线
			 if (pi.x < self.frame.size.width - self.config.moveRightAxisX - self.config.checkRightAxisX) {
				  [smoothedPath addLineToPoint:pi];
			 }
			 
			 
		 }
		 // Now add p2
		 [smoothedPath addLineToPoint:p2];
	 }

	 // finish by adding the last point
	 [smoothedPath addLineToPoint:POINT(points.count - 1)];
	 smoothedPath.lineJoinStyle = kCGLineJoinRound;
	 return smoothedPath;
 }

 */


@end
