//
//  KeyboardLaunch.m
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import "KeyboardLaunch.h"
#import <IQKeyboardManager.h>
#import "ASMacros.h"

@implementation KeyboardLaunch

+ (instancetype)shareLaunch {
    static KeyboardLaunch *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


// MARK: Protocol
- (void)executeCommand {
    
    // 全局键盘配置
    IQKeyboardManager *manager = IQKeyboardManager.sharedManager;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
//    NSArray *ignores = @[NSClassFromString(@"GHVerificationCodeViewController")
//                         ];
//    [[manager disabledToolbarClasses] addObjectsFromArray:ignores];
//    [[manager disabledDistanceHandlingClasses] addObjectsFromArray:ignores];
	manager.placeholderColor = ASColorHex(0xC1CCC9);
	manager.placeholderFont = ASFont(14.0);
	manager.keyboardDistanceFromTextField = 50;
	manager.toolbarDoneBarButtonItemText = NSLocalizedString(@"Complete", nil);
}

- (void)updateAPPLanguage {
    
}

@end
