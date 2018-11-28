//
//  UIImageView+Extension.h
//  
//
//  Created by yang on 2017/7/12.
//  Copyright © 2017年 com.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)


/**
 UIImageView打开交互并设置交互的方法

 @param frame frame
 @param image image
 @param selector 交互的方法
 @return UIImageView
 */
- (UIImageView *)initWithFrame:(CGRect)frame image:(UIImage *)image selector:(SEL)selector target:(id)target;

@end
