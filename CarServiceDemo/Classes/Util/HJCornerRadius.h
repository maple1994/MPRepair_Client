//
//  HJCornerRadius.h
//  HJImageViewDemo
//
//  Created by haijiao on 16/3/10.
//  Copyright © 2016年 olinone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HJCornerRadius)

///设置UIImageView圆形
- (void)roundView;

///设置UIImageView的圆角属性
@property (nonatomic, assign) CGFloat cornerRadius;

@end
