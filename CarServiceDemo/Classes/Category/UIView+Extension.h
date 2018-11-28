
/**
 *  UIView+Extension.h
 *  
 *  UIView的category,用setter、getter方法，获取UIView的CGFloat、CGSize、CGPoint等属性
 *  Created by yang on 14/6/8.
 *  Copyright © 2016年 . All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
///圆形控件
- (void)roundView;

///设置UIImageView的圆角属性
@property (nonatomic, assign) CGFloat cornerRadius;

- (UIViewController*)viewController;

+ (void)setViewBoardLine:(NSArray*)viewArr boardWidth:(CGFloat)width boardColor:(UIColor*)boardColor;

@end
