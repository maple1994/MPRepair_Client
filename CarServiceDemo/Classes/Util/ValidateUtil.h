//
//  ValidateUtil.h
//  Agencies
//
//  Created by mac on 15/12/31.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateUtil : NSObject
//检验手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//校验用户名
+(BOOL)checkUserName:(NSString*)userName;

/**
 *  空字符串
 */
+(BOOL) isEmptyStr:(NSString*)str;

/**
 *  数字字符串
 */
+(BOOL) isNum:(NSString*)str;
/**
 *  身份证号码的校验
 *
 *  @param IDNumber 身份证号码
 *
 *  @return BOOL
 */
+ (BOOL)isIDNumber:(NSString *)IDNumber;

/**
 *  中国大陆固定电话的验证(不包括分机号)
 *
 *  @param telphone 固定电话号码
 *
 *  @return BOOL
 */
+ (BOOL)isTelphone:(NSString *)telphone;

//检查字符串的字符数(英文、数字、符号算1个，中文2个)
+(NSUInteger) unicodeLengthOfString: (NSString *)str;

//+ (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size originString:(NSString*)originString;

+(BOOL) isMoney:(NSString *)str;

//检验手机号码
+ (BOOL)isMobile:(NSString *)mobile;

@end
