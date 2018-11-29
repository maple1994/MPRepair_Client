//
//  UserInfo.m
//  Agencies
//
//  Created by mac on 15/12/31.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "UserInfo.h"
#import "CommonFunc.h"
#import "IOSmd5.h"

#define USEROFNAME @"username"
#define MOBILE @"mobile"
#define TOKEN @"token"
#define ACCOUNT @"account"
#define PASSWORD @"password"



@implementation UserInfo
{
    NSString *_timestamp;
    NSString * _sign;
    BOOL _isLogin;
}

#pragma mark - 单例设计
static UserInfo *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (UserInfo *)userInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (BOOL)isLogin {
    if (_user_id.length > 0) {
        return YES;
    }else {
        return NO;
    }
}

- (NSString *)timestamp{
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    return timestamp;
}

- (void)setTimestamp:(NSString *)timestamp{
    _timestamp = timestamp;
}

- (NSString *)sign{
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
//    NSString *timestamp = self.timestamp;
    NSString *token = self.token;
    NSString *signStr = [NSString stringWithFormat:@"%@%@", token,timestamp];
    NSString *md5Str = [NSString stringWithFormat:@"%@",[IOSmd5 MD5ForLower32Bate:signStr]];
    return md5Str;
}

- (void)setSign:(NSString *)sign{
    _sign = sign;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

#pragma mark - 序列化与反序列化
/// 序列化
- (void)serilization {
    NSString *jsonStr = [self toJSONString];
    [kUserDefault setObject:jsonStr forKey: @"MP_USER_INFO_KEY"];
}
/// 读取本地用户数据
- (void)readLocalData {
    NSString *jsonStr = [kUserDefault objectForKey:@"MP_USER_INFO_KEY"];
    if (jsonStr != nil && jsonStr.length > 0) {
        UserInfo *info = [[UserInfo alloc] initWithString:jsonStr error:nil];
        self.user_id = info.user_id;
        self.token = info.token;
        self.phone = info.phone;
        self.name = info.name;
        self.pic_url = info.pic_url;
        self.sex = info.sex;
        self.telephone = info.telephone;
        self.point = info.point;
        self.is_pass = info.is_pass;
        self.account = info.account;
        self.currentCity = info.currentCity;
    }
}

/// 移除用户数据
- (void)removeUserInfo {
    [kUserDefault setObject:nil forKey:@"MP_USER_INFO_KEY"];
    self.user_id = @"";
    self.token = @"";
    self.phone = @"";
    self.name = @"";
    self.pic_url = @"";
    self.telephone = @"";
    self.point = @"";
    self.is_pass = false;
    self.account = @"";
    self.currentCity = @"";
}

@end


