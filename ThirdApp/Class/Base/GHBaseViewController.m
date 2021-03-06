//
//  GHBaseViewController.m
//  GHome
//
//  Created by Qincc on 2020/12/14.
//

#import "GHBaseViewController.h"

@interface GHBaseViewController ()
@end

@implementation GHBaseViewController

- (void)dealloc {
	NSLog(@"dealloc = %@", self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.view.backgroundColor = UIColor.whiteColor;
//    self.view.backgroundColor = ASColor(239, 239, 239, 1);
	
	[self setHbd_titleTextAttributes:@{NSForegroundColorAttributeName:ASColor(48, 51, 51, 1),NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
}


@end
