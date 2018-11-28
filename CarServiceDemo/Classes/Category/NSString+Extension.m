
/**
 *  NSString+Extension.m
 *  
 *  NSString的category,项目网络数据传输加密算法、写入系统偏好等
 *  Created by yang on 14/6/8.
 *  Copyright © 2016年 . All rights reserved.
 */

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Extension)

#pragma mark - MD5 16位加密
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%2s",result];
    }
    return ret;
}

+ (NSString *)getBeautifulTimeWithSlash:(NSString *)time{
    if (time.length ==0 || time ==nil) {
        return time;
    }
    if (time.length >10) {
        time=[time substringToIndex:11];
    }
    time=[time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    return time;
}

+ (NSString *)getBeautifulTimeWithBrached:(NSString *)time{
    if (time.length ==0 || time ==nil) {
        return time;
    }
    if (time.length >10) {
        time=[time substringToIndex:11];
    }
    return time;
}





#pragma mark - 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 获取uuid
+ (NSString *)getUUIDString

{
    CFUUIDRef uuidObj    = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
    
}


- (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size{
    
    CGSize retSize = CGSizeZero;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        
        CGRect rect =  [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
        retSize.width = ceil(rect.size.width);
        retSize.height = ceil(rect.size.height);
        
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        retSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    return retSize;
}


/**
 *  计算字符串的字符数(中文算2个)
 *
 *  @return 字符数
 */
- (NSUInteger) unicodeLengthOfString {
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

+(NSString*)timerFireMethod:(long long)time{
    
    NSDate *today = [NSDate date];//得到当前时间
    NSDate *startDate=[NSDate dateWithTimeIntervalSince1970:time+[today timeIntervalSince1970]];
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
    NSUInteger unitFlags =
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay;
    NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:today  toDate: startDate options:0];
    NSInteger diffDay   = [cps day]>0 ? [cps day] : 0;
    NSInteger diffHour = [cps hour]>0 ? [cps hour] : 0;
    NSInteger diffMin    = [cps minute]>0 ? [cps minute] : 0;
    NSInteger diffSec   = [cps second]>0 ? [cps second] : 0;
    
    NSString* countDown = [NSString stringWithFormat:@"%02ld天 %02ld:%02ld:%02ld", diffDay, diffHour, diffMin, diffSec];
    
    return countDown;
}


+ (BOOL)isMobile:(NSString *)mobileNum
{
    if (mobileNum==nil) {
        return NO;
    }
    
    //11位数字，且必须为13、14、15、17、18开头
    NSString * MOBILE = @"^1(3|4|5|7|8)\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    }
    
    return NO;
}


+ (BOOL)isNumText:(NSString *)str {
    NSString * regex = @"[0-9]*";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

// 获取HTML富文本
- (NSAttributedString *)HTMLAttributeString
{
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrStr;
}

//获取今天时间，格式 2018-04-01
+ (NSString*)getNowDateStringWithType:(NSString *)tye{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:tye];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}
//获取今天前30天
+ (NSString*)getOldNDayDateString:(NSInteger)n{
    
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    
    if(n!=0){
        
        NSTimeInterval  oneDay = -24*60*60*1;  //1天的长度  负的往前，正的往后
        theDate = [nowDate initWithTimeIntervalSinceNow:oneDay*n];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
        
    }else{
        theDate = nowDate;
    }
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    
    return the_date_str;
}

/**
 时间戳转换时间
 
 @param timeStamp 时间戳
 @param type 格式，自定义如： yyyy-MM-dd HH:mm:ss
 @return 时间
 */
+ (NSString *)getTimeFromTimestamp:(NSString*)timeStamp andType:(NSString*)type{
    //将对象类型的时间转换为NSDate类型

    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    //设置时间格式
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:type];
    //将时间转换为字符串
    NSString *timeStr=[formatter stringFromDate:myDate];
    return timeStr;
}

+ (NSString *)dictionaryToJsonString:(id)dictM
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - json字符串转字典
+ (NSDictionary *)jsonStringToDictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - 字典转json字符串,自动去除换行符
+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

#pragma mark 一串字符在固定宽度下，正常显示所需要的高度 method
+ (CGFloat)autoHeightWithString:(NSString *)string Width:(CGFloat)width Font:(UIFont *)font {
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;//行间距
    paragraph.paragraphSpacing = 50;//段落间隔
    paragraph.firstLineHeadIndent = 50;//首行缩近
    //绘制属性（字典）
    NSDictionary * dictA = @{NSFontAttributeName:font,
                             NSForegroundColorAttributeName:[UIColor greenColor],
                             NSBackgroundColorAttributeName:[UIColor grayColor],
                             NSParagraphStyleAttributeName:paragraph,
                             //                             NSObliquenessAttributeName:@0.5 //斜体
                             //                             NSStrokeColorAttributeName:[UIColor whiteColor],
                             //                             NSStrokeWidthAttributeName:@2,//描边
                             //                             NSKernAttributeName:@20,//字间距
                             //                             NSStrikethroughStyleAttributeName:@2//删除线
                             //                             NSUnderlineStyleAttributeName:@1,//下划线
                             };
    
    //大小
    CGSize boundRectSize = CGSizeMake(width, MAXFLOAT);
    
    //调用方法,得到高度
    CGFloat newFloat = [string boundingRectWithSize:boundRectSize
                                            options: NSStringDrawingUsesLineFragmentOrigin
                        | NSStringDrawingUsesFontLeading
                                         attributes:dictA context:nil].size.height;
    return newFloat;
}

#pragma mark 一串字符在一行中正常显示所需要的宽度 method
+ (CGFloat)autoWidthWithString:(NSString *)string Font:(UIFont *)font {
    
    //大小
    CGSize boundRectSize = CGSizeMake(MAXFLOAT, font.lineHeight);
    //绘制属性（字典）
    NSDictionary *fontDict = @{ NSFontAttributeName: font };
    //调用方法,得到高度
    CGFloat newFloat = [string boundingRectWithSize:boundRectSize
                                            options: NSStringDrawingUsesLineFragmentOrigin
                        | NSStringDrawingUsesFontLeading
                                         attributes:fontDict context:nil].size.width;
    return newFloat;
}

@end
