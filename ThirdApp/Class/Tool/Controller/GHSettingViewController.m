//
//  GHSettingViewController.m
//  GHome
//
//  Created by Qincc on 2020/12/18.
//

#import "GHSettingViewController.h"
#import "GHSettingTableViewCell.h"
#import <GHAlertView.h>
#import "GHListView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "GHLogoutTableViewFooterView.h"
#import "GHMoreViewModel.h"
#import "GHHudTip.h"
#import "GHStatesListViewController.h"
#import "GHLoginHomeViewModel.h"
#import "GHUserInfo.h"
#import "GHCucoMQTTService.h"
#import "GHUserSelectedInfo.h"
#import "GHLoginViewModel.h"
#import "GHUserSelectedInfo.h"
#import "NSString+GHCategory.h"
#import "GHBLEClient.h"

@interface GHSettingViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) GHSetingViewModel *viewModel;
@property (nonatomic, strong) GHMoreViewModel *moreViewModel;

@property (nonatomic, strong) GHLoginHomeViewModel *loginHomeViewModel;
@property (nonatomic, strong) GHLoginViewModel *loginViewModel;

@end

@implementation GHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
	self.view.backgroundColor = UIColor.whiteColor;
	self.hbd_barShadowHidden = YES;
	self.navigationItem.title = NSLocalizedString(@"Personal Setting", nil);
	
	[self viewsLayout];
	[self bindSignals];
}

- (void)viewsLayout {
	[self.view addSubview:self.tableView];
	AS_AdjustsScrollViewInsetNever(self, self.tableView);
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(0);
	}];
}

- (void)bindSignals {
	@weakify(self);
	[self.moreViewModel.modifyUserInfoCommand.errors subscribeNext:^(NSError * _Nullable x) {
		@strongify(self);
		[GHHudTip showTips:x.domain inView:self.view];
	}];
}

- (void)fetchPhotoAlbum {
	ASWeak(self);
	void(^controlAction)(void) = ^(void) {
		[weakself.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		[weakself presentViewController:weakself.imagePicker animated:YES completion:nil];
	};
	
	PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
	if (status == PHAuthorizationStatusAuthorized) {
		controlAction();
	}
	if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
		[GHAlertView showWithView:self.view.window imageName:nil title:nil message:NSLocalizedString(@"The album has not been authorized, please set up permission first if you need to access it!", nil) okBtnTitle:NSLocalizedString(@"Setting", nil) cancelBtnTitle:NSLocalizedString(@"Cancel", nil) configBlock:nil btnBlock:^(GHAlertView *alertView, NSInteger tag) {
			[weakself.imagePicker dismissViewControllerAnimated:YES completion:nil];
			if (tag == 1) {
				[UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
			}
		}];
		return;
	}
	
	[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (status == PHAuthorizationStatusAuthorized) {
				controlAction();
			}
		});
	}];
}

- (void)fetchCamera {
	@weakify(self)
	AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
	switch (status) {
		case AVAuthorizationStatusNotDetermined:{
			// 许可对话没有出现，发起授权许可
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
				if (granted) {
					@strongify(self)
					dispatch_async(dispatch_get_main_queue(), ^{
						if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
							[self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
							[self presentViewController:self.imagePicker animated:YES completion:nil];
						} else {
							NSLog(@"模拟器不支持拍照功能");
						}
					});
				}
			}];
			break;
		}
		case AVAuthorizationStatusAuthorized:{
			// 已经开启授权，可继续
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				[self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
				[self presentViewController:self.imagePicker animated:YES completion:nil];
			} else {
				NSLog(@"模拟器不支持拍照功能");
			}
			break;
		}
		case AVAuthorizationStatusDenied:
		case AVAuthorizationStatusRestricted:
		{
			dispatch_async(dispatch_get_main_queue(), ^{ // 用户明确地拒绝授权，或者相机设备无法访问
				ASWeak(self);
				[GHAlertView showWithView:self.view.window imageName:nil title:nil message:NSLocalizedString(@"The camera has not been authorized, please set up permission first if you need to access it!", nil) okBtnTitle:NSLocalizedString(@"Setting", nil) cancelBtnTitle:NSLocalizedString(@"Cancel", nil) configBlock:nil btnBlock:^(GHAlertView *alertView, NSInteger tag) {
					[weakself.imagePicker dismissViewControllerAnimated:YES completion:nil];
					if (tag == 1) {
						[UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:nil];
					}
				}];
			});
		}
			break;
		default:
			break;
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
	UIImage *outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
	if (outputImage == nil) {
		outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	}
	
	@weakify(self)
	[picker dismissViewControllerAnimated:YES completion:^{
		@strongify(self);
		[GHHudTip showHUDWithMessage:nil inView:self.view];
		NSData *imageData = UIImageJPEGRepresentation(outputImage, 0.5);
		GHUploadUserHeaderImageRequest *request = GHUploadUserHeaderImageRequest.alloc.init;
		RACTuple *tuple = [RACTuple tupleWithObjects:request, imageData, nil];
		[[self.moreViewModel.uploadUserHeadImageCommand execute:tuple] subscribeNext:^(id  _Nullable x) {
			@strongify(self);
			[GHHudTip hideHUDWithView:self.view];
		} error:^(NSError * _Nullable error) {
			[GHHudTip showTips:error.domain];
		}];
	}];
}

#pragma mark - lazy

- (UIImagePickerController *)imagePicker {
	if (_imagePicker == nil) {
		_imagePicker = UIImagePickerController.alloc.init;
		_imagePicker.delegate = self;
		_imagePicker.allowsEditing = true;
		_imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
	}
	return _imagePicker;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [UITableView.alloc initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.rowHeight = UITableViewAutomaticDimension;
		_tableView.estimatedRowHeight = 56;
		_tableView.backgroundColor = ASColorHex(0xEFF2F3);
		_tableView.separatorStyle = UITableViewCellSelectionStyleNone;
		_tableView.tableFooterView = UIView.alloc.init;
		[_tableView registerClass:GHSettingTableViewCell.class forCellReuseIdentifier:@"GHSettingTableViewCell"];
		[_tableView registerClass:GHSettingUserIconTabelViewCell.class forCellReuseIdentifier:@"GHSettingUserIconTabelViewCell"];
		[_tableView registerClass:GHLogoutTableViewFooterView.class forHeaderFooterViewReuseIdentifier:@"GHLogoutTableViewFooterView"];
	}
	return _tableView;
}

- (GHSetingViewModel *)viewModel {
	if (!_viewModel) {
		_viewModel = GHSetingViewModel.alloc.init;
	}
	return _viewModel;
}

- (GHMoreViewModel *)moreViewModel {
	if (!_moreViewModel) {
		_moreViewModel = GHMoreViewModel.alloc.init;
	}
	return _moreViewModel;
}

- (GHLoginHomeViewModel *)loginHomeViewModel {
	if (!_loginHomeViewModel) {
		_loginHomeViewModel = GHLoginHomeViewModel.alloc.init;
	}
	return _loginHomeViewModel;
}

- (GHLoginViewModel *)loginViewModel {
	if (!_loginViewModel) {
		_loginViewModel = GHLoginViewModel.alloc.init;
	}
	return _loginViewModel;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.viewModel.dataSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GHMoreCellViewModel *cellViewModel = self.viewModel.dataSource[indexPath.section][indexPath.row];
	GHCornerTableViewCell *cornerCell;
	if (indexPath.section == 0 && indexPath.row == 0) {
		GHSettingUserIconTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHSettingUserIconTabelViewCell"];
		cell.cellViewModel = cellViewModel;
		cornerCell = cell;
	} else {
		GHSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHSettingTableViewCell"];
		cell.cellViewModel = cellViewModel;
		cornerCell = cell;
	}
	cornerCell.selectionStyle = UITableViewCellSelectionStyleNone;
	cornerCell.cornerRadius = 8;
	cornerCell.contentEdge = UIEdgeInsetsMake(0, 12, 0, 12);
	cornerCell.backgroundColor = UIColor.whiteColor;
	if ([tableView numberOfRowsInSection:indexPath.section] == 1)  {
		cornerCell.cornerType = GHCornerTypeAll;
	} else {
		if (indexPath.row == 0) {
			cornerCell.cornerType = GHCornerTypeTop;
		} else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1){
			cornerCell.cornerType = GHCornerTypeBottom;
		} else {
			cornerCell.cornerType = GHCornerTypeNone;
		}
	}
	return cornerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	GHMoreCellViewModel *cellViewModel = self.viewModel.dataSource[indexPath.section][indexPath.row];
	if ([cellViewModel.className length] > 0) {
		NSInteger seciton = indexPath.section;
		NSInteger row = indexPath.row;
		if ([cellViewModel.className isEqualToString:@"GHStatesListViewController"]) {
			ASWeak(self);
			if (cellViewModel.moreType == GHMoreDataTypeTimeZone) {
				GHStatesListViewController *vc = GHStatesListViewController.alloc.init;
				vc.showRegionCode = cellViewModel.accessoryTitle;
				vc.searchType = GHSearchTypeTimezone;
				vc.selectedState = ^(NSString * _Nonnull reginCode, NSString * _Nonnull phoneCode, NSString * _Nonnull reginName) {
					//切换Timezone
					NSString *selectedTimezone = reginCode;
					GHMoreCellViewModel *currCellViewModel = weakself.viewModel.dataSource[seciton][row];
					if ([selectedTimezone isEqualToString:currCellViewModel.accessoryTitle]) {
						return;
					}
					
					GHModfifyUserInfoRequest *reqeust = GHModfifyUserInfoRequest.alloc.init;
					reqeust.timezone = selectedTimezone;
					[weakself.moreViewModel.modifyUserInfoCommand execute:reqeust];
				};
				[self.navigationController pushViewController:vc animated:YES];
				
			} else {
				GHStatesListViewController *vc = GHStatesListViewController.alloc.init;
				vc.searchType = GHSearchTypeRegin;
				vc.showRegionCode = cellViewModel.accessoryTitle;
				vc.selectedState = ^(NSString * _Nonnull reginCode, NSString * _Nonnull phoneCode, NSString * _Nonnull reginName) {
					//切换regin  需要重新登陆， 获取主页列表， 区域配置， MQTT断开后重新连接，等等
					NSString *selectedRegionCode = reginCode;
					if ([selectedRegionCode isEqualToString:GHUserInfo.share.region]) {
						return;
					}
					
					[GHHudTip showHUDWithMessage:nil inView:weakself.view.window];
					//第一步更新区域配置
					GHConfigRequest *request = GHConfigRequest.alloc.init;
					request.country_code = reginCode;
					[[weakself.loginHomeViewModel.configCommand execute:request] subscribeNext:^(id  _Nullable x) {
						[GHHudTip hideHUDWithView:weakself.view.window];
						// 切换服务器地址

						GHUserInfo.share.api_server = x;
						GHUserSelectedInfo.share.region_name = reginName;
						GHUserSelectedInfo.share.region_code = reginCode;
						[GHUserSelectedInfo saveUserSelectedInfo];

						// 清空用户信息其他信息（api_server，已经更新）
						[GHUserInfo.share modifyRegin:reginCode phoneCode:phoneCode reginName:reginName];
						
						[GHHudTip showSuccessWithTips:NSLocalizedString(@"After switching the server, please log in again.", nil) imageName:nil];
						
//						GHUserInfo.share.token = nil;
					
//						//登录新的服务器，获取token
//						GHLoginRequest *loginRequest = GHLoginRequest.alloc.init;
//						if ([GHUserInfo.share.username containsString:@"@"]) {
//							loginRequest.username = GHUserInfo.share.username;
//						} else {
//							NSArray *namesArray = [GHUserInfo.share.username componentsSeparatedByString:@"-"];
//							loginRequest.username = namesArray.lastObject;
//						}
//						loginRequest.password = GHUserInfo.share.password;
//						loginRequest.phone_code = @([GHUserSelectedInfo.share.phone_code integerValue]);
//						loginRequest.region_code = reginCode;
//						[[weakself.loginViewModel.loginCommand execute:loginRequest] subscribeNext:^(id  _Nullable x) {
//							dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//								[GHHudTip hideHUDWithView:weakself.view];
//								//保存用户选择的区域信息
//								GHUserSelectedInfo.share.region_name = reginName;
//								GHUserSelectedInfo.share.region_code = reginCode;
//								[GHUserSelectedInfo saveUserSelectedInfo];
//
//								// 清空用户信息其他信息（api_server，已经更新）
//								[GHUserInfo.share modifyRegin:reginCode phoneCode:phoneCode reginName:reginName];
//							});
//
//							//直接重新请求接口
//
//						} error:^(NSError * _Nullable error) {
//							[GHHudTip showTips:error.domain];
//						}];
						
					} error:^(NSError * _Nullable error) {
						//切换失败，给出提示
						[GHHudTip showTips:error.domain inView:weakself.view.window];
					}];
				};
				[self.navigationController pushViewController:vc animated:YES];
			}
			return;
		}
	
		NSString *className = cellViewModel.className;
		[self.navigationController pushViewController:[[NSClassFromString(className) alloc] init] animated:YES];
		return;
	}
	
	if (cellViewModel.moreType == GHMoreDataTypeHeadImage) {
		GHListConifg *config = GHListConifg.alloc.init;
		config.dataSource = @[@[NSLocalizedString(@"Take Photo", nil),NSLocalizedString(@"Choose from Album", nil)],@[NSLocalizedString(@"Cancel", nil)]];
		GHListView *listView = [GHListView.alloc initWithConfig:config];
		ASWeak(self);
		listView.listViewSelectedIndexPath = ^(NSIndexPath *indexPath, NSString *selelctedValue) {
			if (indexPath.section == 0) {
				if (indexPath.row == 0) {
					[weakself fetchCamera];
				} else {
					[weakself fetchPhotoAlbum];
				}
			} else {
				
			}
		};
		[listView showWithView:self.view.window animation:YES];
	} else if (cellViewModel.moreType == GHMoreDataTypeNickName) {
		ASWeak(self);
		[GHAlertView showWithView:self.view.window title:NSLocalizedString(@"Nickname", nil) textFieldPlace:NSLocalizedString(@"Nickname", nil) okBtnTitle:NSLocalizedString(@"Save", nil) cancelBtnTitle:NSLocalizedString(@"Cancel", nil) configBlock:^(GHAlertView *alertView) {
			ASWeak(alertView);
			alertView.inputTextField.text = weakself.viewModel.dataSource[indexPath.section][indexPath.row].accessoryTitle;
			alertView.inputTextField.delegate = weakself;
			[[alertView.inputTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
				//昵称的长度范围1～20个字符
				[weakalertView.okBtn setTitleColor:(weakalertView.inputTextField.text.length == 0 || weakalertView.inputTextField.text.length > 20) ? ASColorHex(0xC1CCC9) : ASColorHex(0x0BD087) forState:UIControlStateNormal];
				weakalertView.okBtn.enabled = (x.length == 0) ? NO : YES;
			}];
		} btnBlock:^(GHAlertView *alertView, NSInteger tag) {
			if (tag == 0) {
				return;
			}
			
			//不做任何修改
			if ([alertView.inputTextField.text isEqualToString:cellViewModel.accessoryTitle]) {
				return;
			}
			
			NSString *nickName = [alertView.inputTextField.text removeBlankCharacter];
			if (nickName.length == 0) {
				[GHHudTip showTips:NSLocalizedString(@"Name is Empty", nil)];
				return;
			}
			
			// 修改昵称
			GHModfifyUserInfoRequest *request = GHModfifyUserInfoRequest.alloc.init;
			request.nickname = nickName;
			[weakself.moreViewModel.modifyUserInfoCommand execute:request];
		}];
	} else if (cellViewModel.moreType == GHMoreDataTypeTemp) {  //温度单位
		ASWeak(self);
		GHListConifg *config = GHListConifg.alloc.init;
		config.dataSource = @[@[@"°C",@"°F"],@[@"Cancel"]];
		config.selectedIndexPath = [NSIndexPath indexPathForRow:[cellViewModel.accessoryTitle isEqualToString:@"F"] ? 1 : 0 inSection:0];
		GHListView *listView = [GHListView.alloc initWithConfig:config];
		ASWeak(config);
		listView.listViewSelectedIndexPath = ^(NSIndexPath *indexPath, NSString *selelctedValue) {
			if (indexPath.section == 0) {
				if (weakconfig.selectedIndexPath.section == indexPath.section && weakconfig.selectedIndexPath.row == indexPath.row) {
					return;
				}
				
				NSString * tempunit = @"F";
				if (indexPath.row == 0) { //选择摄氏度
					tempunit = @"C";
				}
				GHModfifyUserInfoRequest *request = GHModfifyUserInfoRequest.alloc.init;
				request.tempunit = tempunit;
				[weakself.moreViewModel.modifyUserInfoCommand execute:request];
			} else {
				
			}
		};
		[listView showWithView:self.view.window animation:YES];
	} else {
		UIViewController *vc = [[NSClassFromString(@"TSBezierPathViewController") alloc] init];
		[self.navigationController pushViewController:vc animated:YES];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = UIView.alloc.init;
	view.backgroundColor = UIColor.clearColor;
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 16;
}

//增加一个退出登录的按钮
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == self.viewModel.dataSource.count - 1) {
		GHLogoutTableViewFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GHLogoutTableViewFooterView"];
		view.contentView.backgroundColor = UIColor.clearColor;
		ASWeak(self);
		view.clickLogoutFooterView = ^(id sender) {
			[GHAlertView showWithView:weakself.view.window imageName:nil title:nil message:NSLocalizedString(@"Comfirm logout?", nil) okBtnTitle:NSLocalizedString(@"Logout", nil) cancelBtnTitle:NSLocalizedString(@"Cancel", nil) configBlock:nil btnBlock:^(GHAlertView *alertView, NSInteger tag) {
				if (tag == 1) {
					//调用登录接口
					[weakself.viewModel logout];
				}
			}];
		};
		return view;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == self.viewModel.dataSource.count - 1) {
		NSInteger rowCount = 0;
		for (NSArray *item in self.viewModel.dataSource) {
			rowCount += item.count;
		}
		
		CGFloat height = 80 * 1 + 56 * (rowCount - 1) + 16 * self.viewModel.dataSource.count;
		if (self.view.frame.size.height  - height  < 16 + 56) {
			return 16 + 56;
		} else {
			return self.view.frame.size.height - height;
		}
	}
	return 0.0001;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSMutableString *str = textField.text.mutableCopy;
	[str replaceCharactersInRange:range withString:string];
	if (str.length > 20) {
		return NO;
	} else {
		return YES;
	}
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	textField.layer.borderColor = ASColorHex(0x0BD087).CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	textField.layer.borderColor = [UIColor colorWithRed:220/255.0 green:230/255.0 blue:226/255.0 alpha:1].CGColor;
}


@end
