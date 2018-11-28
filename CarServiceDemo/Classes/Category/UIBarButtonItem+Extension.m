
/**
 *  UIBarButtonItem+Extension.m
 *  
 *  UIBarButtonItem的category
 *  Created by yang on 14/6/8.
 *  Copyright © 2016年 . All rights reserved.
 */

#import "UIBarButtonItem+Extension.h"
#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)


#pragma mark - 创建一个UIBarButtonItem

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[self imageRenderingModeWithImageName:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageRenderingModeWithImageName:image] forState:UIControlStateHighlighted];
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIImage *)imageRenderingModeWithImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

@end
