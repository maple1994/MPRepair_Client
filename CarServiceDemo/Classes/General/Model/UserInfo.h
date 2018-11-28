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

@interface UserInfo:JSONModel

+ (UserInfo *)userInfo;

@property (nonatomic, assign) NSInteger uid;// id
@property (nonatomic, copy) NSString *user_id;// 显示用的id

@property (nonatomic, copy) NSString *token;// 登录token
@property (nonatomic, copy) NSString *password;// 登录token

/// 时间戳
@property (nonatomic, copy) NSString *timestamp;
/// 签名
@property (nonatomic, copy) NSString *sign;

@property(nonatomic,copy)NSString *phone;//电话
@property(nonatomic,copy)NSString *name;//名字
@property(nonatomic,copy)NSString *pic_url;//头像
@property (nonatomic, assign) Sex sex;//性别
@property(nonatomic,copy)NSString *telephone;//座机
@property(nonatomic,copy)NSString *point;//积分
@property(nonatomic,assign)BOOL is_pass;//是否过审
@property(nonatomic,copy)NSString *account;//电话
@property(nonatomic,copy)NSString *currentCity;
@property (nonatomic, assign) BOOL isLogin;//是否登录
@end

