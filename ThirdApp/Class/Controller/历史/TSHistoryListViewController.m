//
//  TSHistoryListViewController.m
//  ThirdApp
//
//  Created by Qincc on 2021/3/10.
//

#import "TSHistoryListViewController.h"
#import "TSHistoryListTableViewCell.h"

@interface TSHistoryListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TSHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.hbd_barAlpha = 0.0;
	self.hbd_barShadowHidden = YES;
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBtn:)];
	[item setTitleTextAttributes:@{
		NSForegroundColorAttributeName:UIColor.blackColor,
		NSFontAttributeName:ASFont(16)
	} forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = item;
	
	[self viewsLayout];
}

- (void)clickRightBtn:(id)sender {
	//编辑
}

- (void)viewsLayout {
	UILabel *timeLabel = UILabel.alloc.init;
	timeLabel.textColor = UIColor.blackColor;
	timeLabel.textAlignment = NSTextAlignmentCenter;
	timeLabel.text = @"测量时间";
	timeLabel.font = ASFont(14);
	[self.view addSubview:timeLabel];
	[timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(0);
		make.width.mas_equalTo(self.view.mas_width).multipliedBy(1/3.0);
		make.height.mas_equalTo(40);
		make.top.mas_equalTo(ASNavBarHeight);
	}];
	
	UILabel *shesiduLabel = UILabel.alloc.init;
	shesiduLabel.textColor = UIColor.blackColor;
	shesiduLabel.textAlignment = NSTextAlignmentCenter;
	shesiduLabel.text = @"摄氏度(°C)";
	shesiduLabel.font = ASFont(14);
	[self.view addSubview:shesiduLabel];
	[shesiduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.width.mas_equalTo(self.view.mas_width).multipliedBy(1/3.0);
		make.height.mas_equalTo(40);
		make.top.mas_equalTo(ASNavBarHeight);
	}];
	
	UILabel *huashiduLabel = UILabel.alloc.init;
	huashiduLabel.textColor = UIColor.blackColor;
	huashiduLabel.textAlignment = NSTextAlignmentCenter;
	huashiduLabel.text = @"华氏度(°F)";
	huashiduLabel.font = ASFont(14);
	[self.view addSubview:huashiduLabel];
	[huashiduLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(0);
		make.width.mas_equalTo(self.view.mas_width).multipliedBy(1/3.0);
		make.height.mas_equalTo(40);
		make.top.mas_equalTo(ASNavBarHeight);
	}];
	
	UIView *bottomLineView = UIView.alloc.init;
	bottomLineView.backgroundColor = UIColor.blackColor;
	[self.view addSubview:bottomLineView];
	[bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(0);
		make.height.mas_equalTo(1);
		make.bottom.mas_equalTo(timeLabel.mas_bottom).offset(0);
	}];
	
	UIView *firstLineView = UIView.alloc.init;
	firstLineView.backgroundColor = UIColor.lightGrayColor;
	[self.view addSubview:firstLineView];
	[firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(timeLabel.mas_right);
		make.height.mas_equalTo(25);
		make.width.mas_equalTo(0.5);
		make.centerY.mas_equalTo(timeLabel.mas_centerY);
	}];
	
	UIView *secondLineView = UIView.alloc.init;
	secondLineView.backgroundColor = UIColor.lightGrayColor;
	[self.view addSubview:secondLineView];
	[secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(shesiduLabel.mas_right);
		make.height.mas_equalTo(25);
		make.width.mas_equalTo(0.5);
		make.centerY.mas_equalTo(shesiduLabel.mas_centerY);
	}];
	
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(UIEdgeInsetsMake(ASNavBarHeight + 40, 0, 0, 0));
	}];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TSHistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSHistoryListTableViewCell"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.separatorColor = UIColor.lightGrayColor;
		_tableView.backgroundColor = UIColor.whiteColor;
		_tableView.rowHeight = UITableViewAutomaticDimension;
		_tableView.estimatedRowHeight = 56;
		_tableView.tableFooterView = UIView.alloc.init;
		_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		[_tableView registerClass:TSHistoryListTableViewCell.class forCellReuseIdentifier:@"TSHistoryListTableViewCell"];
	}
	return _tableView;
}

@end
