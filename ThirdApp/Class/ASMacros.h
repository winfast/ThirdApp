//
//  GOMacros.m
//  GalanzSmartOven
//
//  Created by Janzen on 2020/4/27.
//  Copyright © 2020 Galanz. All rights reserved.
//

//debug
#ifndef __OPTIMIZE__
#define START_TIMER NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define END_TIMER(msg)  NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate]; MyLog([NSString stringWithFormat:@"%@ Time = %f";, msg, stop-start]);
#define NSLog(...) NSLog(__VA_ARGS__)
#else
//release
#define START_TIMER
#define END_TIMER(msg)
#define NSLog(...)
#endif

// NSFileManager
#define ASFileManager                           NSFileManager.defaultManager
#define ASFileDocumentPath                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
#define ASFileCachePath                         NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define ASFileTempPath                          NSTemporaryDirectory()
#define ASFileSize(path)                        [ASFileManager attributesOfItemAtPath:path error:nil].fileSize

#define ASScreenBounds                          UIScreen.mainScreen.bounds
#define ASScreenSize                            UIScreen.mainScreen.bounds.size
#define ASScreenWidth                           UIScreen.mainScreen.bounds.size.width
#define ASScreenHeight                          UIScreen.mainScreen.bounds.size.height

#define ASScreenMaxLength                       MAX(ASScreenWidth, ASScreenHeight)
#define ASScreenMinLength                       MIN(ASScreenWidth, ASScreenHeight)
#define ASScale(float)                          float * (ASScreenWidth / 375.0)
#define ASStatusBarH                            [UIApplication sharedApplication].statusBarFrame.size.height
#define ASNavBarHeight                          (44 + ASStatusBarH)
#define ASTabBarHeight                          (ASPhoneX ? 83.0 : 49.0)

// Device Type
#define ASIpad                                  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define ASPhone                                 UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define ASPhoneS                                (ASPhone && (ASScreenMaxLength / ASScreenMinLength == 736.0 / 414.0))
#define ASPhoneX                                (ASPhone && ASScreenWidth >= 375.0f && ASScreenHeight >= 812.0f)
#define ASSystemAvailable(version)              @available(iOS version, *)

// Weak
#define ASWeak(type)                          __weak typeof(type) weak##type = type

// UIFont
#define ASFont(font)                            [UIFont systemFontOfSize:font]
#define ASBFont(font)                           [UIFont boldSystemFontOfSize:font]

// UIColor
#define ASColor(r, g, b, a)                     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ASColorHexAlpha(hexNumber, a)           [UIColor colorWithRed:(((float)((hexNumber & 0xFF0000) >> 16)) / 255.0) \
                                                green:(((float)((hexNumber & 0xFF00) >> 8)) / 255.0) \
                                                blue:(((float)(hexNumber & 0xFF)) / 255.0) alpha:a]
#define ASColorHex(hexNumber)                   ASColorHexAlpha(hexNumber, 1.0)
#define ASColorRandom                           ASColor(arc4random_uniform(256),\
                                                        arc4random_uniform(256),\
                                                        arc4random_uniform(256), 1.0)

// NSString
#define ASStringFormat(format, ...)             [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define ASStringEmpty(string)                   ([string isKindOfClass:NSNull.class] || string.length == 0)

// NSArray
#define ASArrayEmpty(array)                     ([array isKindOfClass:NSNull.class] || array.count == 0)

// NSDictionary
#define ASDictionaryEmpty(dic)                  ([dic isKindOfClass:NSNull.class] || dic.allKeys == 0)

// UIImage
#define ASImage(name)                           [UIImage imageNamed:name]
#define ASImageWithHexColor(hexNumber, alpha)              \
({\
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);\
    UIGraphicsBeginImageContext(rect.size);\
    CGContextRef context = UIGraphicsGetCurrentContext();\
    CGContextSetFillColorWithColor(context, [[ASColorHex(hexNumber) colorWithAlphaComponent:alpha] CGColor]);\
    CGContextFillRect(context, rect);\
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();\
    UIGraphicsEndImageContext();\
    image;\
})
#define ASImageOriginal(name)                   [ASImage(name) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
#define ASImageStretch(name, wscale, hscale)    \
({\
    UIImage *image = ASImage(name); \
    [image stretchableImageWithLeftCapWidth:image.size.width * wscale \
    topCapHeight:image.size.height * hscale];\
})

//====Macro====================

#define GP_ISPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 判断是否为iPhone X 系列
 */
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/**
 判断是否为iPad
 */
#define GP_ISPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 获取沙盒Document路径
 */
#define GP_DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

/**
 获取Document 里文件
 
 @param _fileOrFolder_ 文件名
 @return 文件路径
 */
#define GP_Document_path(_fileOrFolder_) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:_fileOrFolder_]

/**
 获取沙盒Cache路径
 */
#define GP_CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/**
 获取Library/cache 里文件
 
 @param _fileOrFolder_ 文件名
 @return 文件路径
 */
#define GP_Cache_Path(_fileOrFolder_) [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:_fileOrFolder_]

/**
 获取沙盒temp路径
 */
#define GP_TempPath NSTemporaryDirectory()

/**
 字符串是否为空
 
 @param str 字符串
 @return YES:空  NO:非空
 */
#define GP_StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

/**
 数组是否为空
 
 @param array 数组
 @return YES:空  NO:非空
 */
#define GP_ArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

/**
 字典是否为空
 
 @param dic 字典
 @return YES:空  NO:非空
 */
#define GP_DictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0)

/**
 是否是空对象
 
 @param _object 对象
 @return YES:空  NO:非空
 */
#define GP_ObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


//解决MJRefresh偏移问题
#define GP_AdjustsScrollViewInsetNever(controller,view) if(@available(iOS 11.0, *)) {view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;} else if([controller isKindOfClass:[UIViewController class]]) {((UIViewController *)controller).automaticallyAdjustsScrollViewInsets = false;}


// 字体、宽、高适配（以6为基准）
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width     // 屏幕宽度
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height    // 屏幕高度
#define kWidthRatio         (kScreenWidth / 375.0)          // 宽度基准
#define kHeightRatio        (kScreenHeight / 667.0)         // 高度基准
#define kAdaptedWidth(x)    ceilf((x) * kWidthRatio)        // 适配屏幕宽度
#define kAdaptedHeight(x)   ceilf((x) * kHeightRatio)       // 屏幕比例高度（注意！仅用于设置不固定宽高比的控件，如tableview、view等，保证高度占屏幕高度的百分比即可；不推荐用于设置需要固定宽高比缩放的控件，如imageview，可能导致宽高缩放不是1:1）
#define kAdaptedSize(x)     ceilf((x) * kWidthRatio)        // 适配大小
#define kAdaptedFontSize(R) ceilf((R) * kWidthRatio)        // 适配字号

// Status bar & navigation bar height.
#define  KStatusBarAndNavigationBarHeight  (IPHONE_X ? 88.f : 64.f)
// Tabbar safe bottom margin.
#define  KTabbarSafeBottomMargin         (IPHONE_X ? 34.f : 0.f)
// Status bar height.
#define KStatusheight (IPHONE_X ? 44.f : 20.f)
// Navigation bar height.
#define  KNavigationBarHeight  44.f
// Tabbar height.
#define  KTabbarHeight         (IPHONE_X ? (49.f+34.f) : 49.f)

#pragma mark -懒加载
#define GOLazyGetMethod(type,attribute)                \
- (type *)attribute                                     \
{                                                       \
    if(_##attribute){                                   \
        return _##attribute;                            \
    }                                                   \
    _##attribute = [[type alloc] init];                 \
    return _##attribute;                                \
}



#define kFontNameRegular    @"PingFangSC-Regular"
#define kFontNameMedium     @"PingFangSC-Medium"
#define kFontNameBold       @"PingFangSC-Bold"

// 登录模块里的圆角大小
#define GOCornerRadius      12.f
// 登录模块里手机号位数限制
#define GOPhoneNumCount     11
// 登录模块里密码最小限制
#define GOPwdMinCount       6
// 登录模块里密码最大限制
#define GOPwdMaxCount       16
