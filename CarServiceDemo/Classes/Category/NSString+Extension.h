
/**
 *  NSString+Extension.h
 *  
 *  NSString的category,项目网络数据传输加密算法、写入系统偏好等
 *  Created by yang on 14/6/8.
 *  Copyright © 2016年 . All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  MD5 16位加密
 */
+ (NSString *)md5HexDigest:(NSString*)input;

/**
 *  写入系统偏好
 *
 *  @param key 写入键值
 */
- (void)saveToNSDefaultsWithKey:(NSString *)key;


/**
 *  获取uuid
 */
+ (NSString *)getUUIDString;


/* 获取日期格式为2016/08/08类型的日期*/
+ (NSString *)getBeautifulTimeWithSlash:(NSString *)time;

/* 获取日期格式为2016-08-08类型的日期*/
+ (NSString *)getBeautifulTimeWithBrached:(NSString *)time;

- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size;

//- (NSString *)restTimeWithSecond:(NSInteger)timeSecond;
+(NSString*)timerFireMethod:(long long)time;

// 判断并合成分享url
- (NSString *)createShareUrl;

+ (BOOL)isMobile:(NSString *)mobileNum;

// 判断是否纯数字
+ (BOOL)isNumText:(NSString *)str;

// 获取HTML富文本
- (NSAttributedString *)HTMLAttributeString;

//获取今天时间，格式自定义 yyyy-MM-dd HH:mm:ss
+ (NSString*)getNowDateStringWithType:(NSString*)tye;

//获取今天前N天日期
+ (NSString*)getOldNDayDateString:(NSInteger)n;

/**
 时间戳转换时间

 @param timeStamp 时间戳
 @param type 格式，自定义如： yyyy-MM-dd HH:mm:ss
 @return 时间
 */
+ (NSString *)getTimeFromTimestamp:(NSString*)timeStamp andType:(NSString*)type;

//对象转换为json字符串
+ (NSString *)dictionaryToJsonString:(id)dictM;

/**
 json字符串转字典
 
 @param jsonString json字符串
 @return 字典
 */
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString;

/**
 字典转json字符串,自动去除换行符

 @param dict 字典
 @return 返回去除换行符的字符串
 */
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

/**
 *  一串字符在固定宽度下，正常显示所需要的高度
 *  @param string：文本内容
 *  @param width：每一行的宽度
 *  @param 字体大小
 */
+ (CGFloat)autoHeightWithString:(NSString *)string
                          Width:(CGFloat)width
                           Font:(UIFont *)font;

/**
 *  一串字符在一行中正常显示所需要的宽度
 *  @param string：文本内容
 *  @param 字体大小
 */
+ (CGFloat)autoWidthWithString:(NSString *)string
                          Font:(UIFont *)font;

@end


