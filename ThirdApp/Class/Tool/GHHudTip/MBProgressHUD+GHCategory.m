//
//  MBProgressHUD+GHCategory.m
//  GHome
//
//  Created by Qincc on 2020/12/19.
//

#import "MBProgressHUD+GHCategory.h"
#import <objc/runtime.h>

@implementation MBProgressHUD (GHCategory)

- (void)setAcitonPading:(CGFloat)acitonPading {
	objc_setAssociatedObject(self, @selector(setAcitonPading:), @(acitonPading), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)acitonPading {
	return [objc_getAssociatedObject(self, @selector(setAcitonPading:)) doubleValue];
}


- (void)updatePaddingConstraints {
	// Set padding dynamically, depending on whether the view is visible or not
	
	if (self.acitonPading < 4) {
		[self callClassMethod:@"updatePaddingConstraints"];
	} else {
		__block BOOL hasVisibleAncestors = NO;
		NSArray *paddingConstraints = [self valueForKey:@"paddingConstraints"];  //使用KVC获取数组
		[paddingConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *padding, NSUInteger idx, BOOL *stop) {
			UIView *firstView = (UIView *)padding.firstItem;
			UIView *secondView = (UIView *)padding.secondItem;
			BOOL firstVisible = !firstView.hidden && !CGSizeEqualToSize(firstView.intrinsicContentSize, CGSizeZero);
			BOOL secondVisible = !secondView.hidden && !CGSizeEqualToSize(secondView.intrinsicContentSize, CGSizeZero);
			// Set if both views are visible or if there's a visible view on top that doesn't have padding
			// added relative to the current view yet
			// 根据UI的要求 这个地方的间距是20
			padding.constant = (firstVisible && (secondVisible || hasVisibleAncestors)) ? self.acitonPading : 0.f;
			hasVisibleAncestors |= secondVisible;
		}];
	}
}

// 调用回原类的方法
- (void)callClassMethod:(NSString *)methodName {
	u_int count;
	Method *methods = class_copyMethodList([MBProgressHUD class], &count);
	NSInteger index = 0;
	
	for (int i = 0; i < count; i++) {
		SEL name = method_getName(methods[i]);
		NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
		if ([strName isEqualToString:methodName]) {
			index = i;  // 先获取原类方法在方法列表中的索引
		}
	}
	
	// 调用方法
	MBProgressHUD *hud = [[MBProgressHUD alloc] init];
	SEL sel = method_getName(methods[index]);
	IMP imp = method_getImplementation(methods[index]);
	((void (*)(id, SEL))imp)(hud,sel);
}

@end
