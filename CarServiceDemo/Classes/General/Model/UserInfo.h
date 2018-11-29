//
//  UserInfo.h
//  Agencies
//
//  Created by mac on 15/12/31.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"


//@protocol UserPermissionInfo <NSObject>
//@end

@interface UserInfo: JSONModel

+ (UserInfo *)userInfo;

/// 显示用的id
@property (nonatomic, copy) NSString *user_id;
/// 登录token
@property (nonatomic, copy) NSString *token;
/// 密码
@property (nonatomic, copy) NSString *password;
/// 时间戳
@property (nonatomic, copy) NSString *timestamp;
/// 签名
@property (nonatomic, copy) NSString *sign;
/// 电话
@property(nonatomic,copy)NSString *phone;//电话
/// 名字
@property(nonatomic,copy)NSString *name;
/// 头像
@property(nonatomic,copy)NSString *pic_url;
/// 性别
@property (nonatomic, assign) Sex sex;
/// 座机
@property(nonatomic,copy)NSString *telephone;
/// 积分
@property(nonatomic,copy)NSString *point;
/// 是否过审
@property(nonatomic,assign)BOOL is_pass;
/// 电话
@property(nonatomic,copy)NSString *account;
/// 所在城市
@property(nonatomic,copy)NSString *currentCity;
/// 是否登录
@property (nonatomic, assign) BOOL isLogin;
/// 纬度
@property (nonatomic, assign) double latitude;
/// 经度
@property (nonatomic, assign) double longtitude;

/// 序列化
- (void)serilization;
/// 读取本地用户数据
- (void)readLocalData;
/// 移除用户数据
- (void)removeUserInfo;
@end

