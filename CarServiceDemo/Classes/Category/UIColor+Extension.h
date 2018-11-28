
/**
 *  UIColor+Extension.h
 *  
 *  UIColor的category
 *  Created by yang on 14/6/8.
 *  Copyright © 2016年 . All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface UIColor (Extension)


/**
 *  16进制颜色(html颜色值)字符串转为UIColor
 *
 *  @param stringToConvert 16进制颜色字符
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexStringToRGB: (NSString *) stringToConvert NS_AVAILABLE_IOS(5_0);


@end
