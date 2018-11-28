//
//  ValidateUtil.m
//  Agencies
//
//  Created by mac on 15/12/31.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "ValidateUtil.h"

@implementation ValidateUtil


/**
 *  中国大陆固定电话的验证(不包括分机号)
 *
 *  @param telphone 固定电话号码
 *
 *  @return BOOL
 */
+ (BOOL)isTelphone:(NSString *)telphone {
    if (telphone==nil) {
        return NO;
    }
    
    //3-4位区号，7-8位直播号码，1－4位分机号
    //如：12345678901、1234-12345678-1234
    /*
     中国大陆固定*****格式可以这么说，以“-”分割，
     
     前3后8，如021-31263126
     
     前4后7，如0319-6073123
     
     前4后8，如0755-83515316
     */
    NSString *phoneRegex = @"\\d{3}\\d{8}\\d{0,4}|\\d{4}\\d{7,8}\\d{0,4}";
   
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:telphone];
}
/**
 *  身份证号码的校验
 *
 *  @param IDNumber 身份证号码
 *
 *  @return BOOL
 */
+ (BOOL)isIDNumber:(NSString *)IDNumber {
    if (IDNumber==nil) {
        return NO;
    }
    
    BOOL flag;
    if (IDNumber.length <= 0) {
        
        flag = NO;
        return flag;
        
    }
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [identityCardPredicate evaluateWithObject:IDNumber];
    
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    if (mobileNum==nil) {
        return NO;
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1\\d{10}$";
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        //        if([regextestcm evaluateWithObject:mobileNum] == YES) {
        //            NSLog(@"China Mobile");
        //        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
        //            NSLog(@"China Telecom");
        //        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
        //            NSLog(@"China Unicom");
        //        } else {
        //            NSLog(@"Unknow");
        //        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)checkUserName:(NSString*)userName {
    if (userName==nil) {
        return NO;
    }
    
    //当用户名少于4个字符时，提示用户重新输入
    NSString *regex = @"^[a-zA-Z][a-zA-Z0-9_]{3,14}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [predicate evaluateWithObject:userName];
}

//+(BOOL) isEmptyStr:(NSString*)str {
//    if (str==nil || [@"" isEqualToString:str] || str == [NSNull null]) {
//        return YES;
//    }
//    return NO;
//}

+(BOOL) isEmptyStr:(NSString*)str {
    if (str==nil) {
        return YES;
    }
    
    BOOL isEmpty = NO;
    NSString *copyStr = [str copy];
    
    if((![copyStr isKindOfClass:[NSNull class]]) && (![copyStr isKindOfClass:[NSString class]]) && (![copyStr isKindOfClass:[NSMutableString class]]))
    {
        copyStr = [NSString stringWithFormat:@"%@", copyStr];
    }
    
    if (copyStr == nil || [@"" isEqualToString:copyStr] || [@" " isEqualToString:copyStr]|| [copyStr isKindOfClass:[NSNull class]]) {
        return YES;
    } else if ([[copyStr substringToIndex:1] isEqualToString:@" "]) {
        isEmpty = [self isEmptyStr:[copyStr substringFromIndex:1]];
    }
    
    return isEmpty;
}

+(BOOL) isNum:(NSString *)str
{
    if (str==nil) {
        return NO;
    }
    
    if ([ValidateUtil isEmptyStr:str]) {
        return NO;
    }
    
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str];
}

/**
 *  计算字符串的字符数(中文算2个)
 *
 *  @param str 要计算的字符串
 *
 *  @return 字符数
 */
+(NSUInteger) unicodeLengthOfString: (NSString *) str {
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
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

//+ (CGSize)sizeWithFont:(UIFont *)font constrainedSize:(CGSize)size originString:(NSString*)originString{
//    
//    CGSize retSize = CGSizeZero;
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
//        
//        CGRect rect =  [originString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
//        retSize.width = ceil(rect.size.width);
//        retSize.height = ceil(rect.size.height);
//        
//    }else{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated"
//        retSize = [originString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//#pragma clang diagnostic pop
//    }
//    return retSize;
//}

+(BOOL) isMoney:(NSString *)str{
    if ([ValidateUtil isEmptyStr:str]) {
        return NO;
    }
    
//    NSString *regex = @"^(([0]{1})|([1-9]\\d{0,}))(.\\d{0,2}){0,1}$";
    NSString *regex = @"^(([1-9]\\d{0,9})|0)(\\.\\d{1,2})?$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)isMobile:(NSString *)mobile {
    if (mobile==nil) {
        return NO;
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1\\d{10}$";
    //    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    
    NSString * CU = @"^1[34578][0-9]{9}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)) {
        if (([regextestcu evaluateWithObject:mobile] == YES))
        {
            
            return YES;
        }else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

@end
