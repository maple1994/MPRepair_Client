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
#pragma mark 自定义归档
#pragma mark NSCoding协议方法

//对属性编码，归档的时候会调用
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.real_name forKey:USEROFNAME];
    
    [aCoder encodeObject:_phone forKey:MOBILE];
    [aCoder encodeObject:_account forKey:ACCOUNT];
    ///不要把密码存明文
    if (![ValidateUtil isEmptyStr:_token]) {
        
        NSInteger index = arc4random()%10;
        NSArray *arr = @[@"953",@"123",@"468",@"325",@"795",@"279",@"635",@"852",@"614",@"753"];
        NSString *tmp = [NSString stringWithFormat:@"%@%@", arr[index], _token];
        [aCoder encodeObject:[CommonFunc base64StringFromText:tmp] forKey:TOKEN];
    }else {
        
        [aCoder encodeObject:_token forKey:TOKEN];
    }
    
    ///不要把密码存明文
    if (![ValidateUtil isEmptyStr:_password]) {
        
        NSInteger index = arc4random()%10;
        NSArray *arr = @[@"953",@"123",@"468",@"325",@"795",@"279",@"635",@"852",@"614",@"753"];
        NSString *tmp1 = [NSString stringWithFormat:@"%@%@", arr[index], _password];
        [aCoder encodeObject:[CommonFunc base64StringFromText:tmp1] forKey:PASSWORD];
    }else {
        
        [aCoder encodeObject:_password forKey:PASSWORD];
    }
}

//对属性解码，解归档调用
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        
//        self.auth_login_token=[CommonFunc textFromBase64String:[aDecoder decodeObjectForKey:TOKEN]] ;
        self.phone = [aDecoder decodeObjectForKey:MOBILE];
        self.account = [aDecoder decodeObjectForKey:ACCOUNT];
        NSString *tmp = [CommonFunc textFromBase64String:[aDecoder decodeObjectForKey:TOKEN]];
        if (![ValidateUtil isEmptyStr:tmp]) {
            self.token = [tmp substringFromIndex:3];
        }
        NSString *tmp1 = [CommonFunc textFromBase64String:[aDecoder decodeObjectForKey:PASSWORD]];
        if (![ValidateUtil isEmptyStr:tmp1]) {
            self.password = [tmp1 substringFromIndex:3];
        }
        
    }
    return self;
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
    if (_uid>0) {
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

+ (JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"uid":@"id"}];
}


@end


