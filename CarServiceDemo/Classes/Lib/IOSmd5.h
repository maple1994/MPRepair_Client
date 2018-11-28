//
//  IOSmd5.h
//  Agencies
//
//  Created by mac on 15/12/31.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSmd5 : NSObject

/**
 *  对字符串进行md5加密，
 *
 *  @param inPutText 原字符串
 *
 *  @return 加密后的字符串（32位小写）
 */
+(NSString *) md5: (NSString *) inPutText ;

/**
 *  对字符串进行md5加密，
 *
 *  @param inPutText 原字符串
 *
 *  @return 加密后的字符串（32位大写）
 */
+(NSString *) md5Big: (NSString *) inPutText; // 返回大写字母


// 32位小写
+(NSString *)MD5ForLower32Bate:(NSString *)str;
// 32位大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str;
@end
