//
//  GHThirdKey.m
//  GPlus
//
//  Created by Jun on 2018/9/17.
//  Copyright © 2018年 Galanz. All rights reserved.
//

#import "GHThirdKey.h"

@implementation GHThirdKey

/// 房间添加， 删除， 移动的通知
NSString *const GHRoomOperationNotify = @"GHRoomOperationNotify";
NSString *const GHAlexaBindNotify = @"GHAlexaBindNotify";
NSString *const GHOTASuccessNotify = @"GHOTASuccessNotify";

NSString *const GHTCloudAppKey = @"6221edcd516c4535877997fd6a0bd692";
NSString *const GHTCloudURLScheme = @"tingyun.42001";

/// 保存用户选择的账号类型 0Email。1Phone
NSString *const GHSelectedInfo = @"GHSelectedInfo";

NSString *const GH_Bugly = @"5690596c57";

NSString *const GH_AppStore = @"https://apps.apple.com/cn/app/ghome/id1514575123";

NSString *const GH_CucoMall = @"https://cdniot.gosund.com/mall?os=1";

NSString *const GHBuglyAppID = @"a639d37e87";

/// 用户条款地址
NSString *const GHServiceAgreement  = @"https://cdniot.gosund.com/terms-user.html";

/// 隐私条约
NSString *const GHPrivacyPolicy  = @"https://cdniot.gosund.com/privacy.html";

/// 登录
NSString *const GH_Bbtain_Jwt_Auth = @"/v1.1/obtain_jwt_auth/";

/// 区域配置
NSString *const GH_Common_Config = @"/common/config/";

/// 国家列表
NSString *const GH_Country = @"/v1.1/country/";

/// 获取验证码
NSString *const GH_Codes = @"/v1.1/codes/";

/// 验证验证码
NSString *const GH_Codes_Verify = @"/v1.1/codes/verify/";

/// 获取用户信息
NSString *const GH_Users_1 = @"/v1.1/users/1/";

/// 注册
NSString *const GH_Users = @"/v1.1/users/";

/// 主页列表
NSString *const GH_App_Room_Device = @"/v1.1/app/room/device/";

/// STS
NSString *const GH_USers_STS = @"/v1.1/users/sts/";

//配网设备列表
NSString *const GH_Device_Category = @"/v1.1/devices/category/";

//房间列表
NSString *const GH_App_Room = @"/v1.1/app/room/";

NSString *const GH_Device_ConfigToken = @"/v1.1/devices/token/";

//房间改名/房间设备排序/移除房间
NSString *const GH_App_Room_RoomID = @"/v1.1/app/room/%@/";

//时区
NSString *const GH_Timezone = @"/v1.1/timezone/";

// OTA升级-ota升级设备列表
NSString *const GH_Devices_OTA_LIST = @"/v1.1/devices/ota_list/";

// OTA升级-ota升级设备列表
NSString *const GH_Devices_OTA_Status = @"/v1.1/devices/ota_status/";

// OTA升级  查询升级进度
NSString *const GH_Devices_OTA_Process = @"/v1.1/devices/ota_process/";

// 更新头像
NSString *const GH_Users_Headimg = @"/v1.1/users/headimg/";

// 忘记密码
NSString *const GH_Resetpasswd = @"/v1.1/resetpasswd/";

//配网引导信息
NSString *const GH_ConfigGuideInfo =@"/v1.1/product/info/";

// 更多服务
NSString *const GH_Outer_Services = @"/v1.1/outer/services/";

// 更多服务
NSString *const GH_Outer_Google_Info = @"/v1.1/outer/google_info/";

// 启用alexa技能
NSString *const GH_Outer_Alexa_Bind = @"/v1.1/outer/alexa_bind/";

//auth登录 从Alexa主动绑定GHome账号
NSString *const GH_Outer_Outer_login = @"/v1.1/outer/oauth_login/";

//APP升级
NSString *const GH_Common_Upgrade = @"/common/upgrade/";

// 刷新 token
NSString *const GH_Refresh_Jwt_Token = @"/v1.1/refresh_jwt_token/";

//获取推荐房间列表
NSString *const GH_Recommand_Room_List = @"/v1.1/app/room/";

//分配房间
NSString *const GH_Select_Room_List = @"/v1.1/app/room/device/";

//设备改名
NSString *const GH_Rename_Device = @"/v1.1/devices/%@/rename/";

//设备改名
NSString *const GH_Delete_Devices = @"/v1.1/devices/%@/";

@end
