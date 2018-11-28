
/**
 *  UIBarButtonItem+Extension.h
 *  
 *  UIBarButtonItem的category
 *  Created by yang on 14/6/8.
 *  Copyright © 2016年 . All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  创建一个UIBarButtonItem
 *
 *  @param target    target
 *  @param action    点击item后调用target的哪个方法
 *  @param image     图片
 *  @param highImage 高亮的图片
 *
 *  @return 创建完的item
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end
