
/**
 *  UIView+Extension.m
 *  
 *  UIView的category,用setter、getter方法，获取UIView的CGFloat、CGSize、CGPoint等属性
 *  Created by yang on 14/6/8.
 *  Copyright © 2016年 . All rights reserved.
 */

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame   = self.frame;
    frame.origin.x = x;
    self.frame     = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame   = self.frame;
    frame.origin.y = y;
    self.frame     = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x       = centerX;
    self.center    = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y       = centerY;
    self.center    = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame     = self.frame;
    frame.size.width = width;
    self.frame       = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size   = size;
    self.frame   = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame   = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


/** 把View切为圆形 */
- (void)roundView {
    
    CGFloat tmp = (self.width > self.height)? self.height : self.width;
    self.bounds = CGRectMake(0, 0, tmp, tmp);
    
    self.layer.cornerRadius = tmp / 2.0;
    self.layer.masksToBounds = YES;
}



static char * kCornerRadiusKey = "kCornerRadiusKey";
- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, kCornerRadiusKey) floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    objc_setAssociatedObject(self, kCornerRadiusKey, @(cornerRadius), OBJC_ASSOCIATION_ASSIGN);
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

+ (void)setViewBoardLine:(NSArray*)viewArr boardWidth:(CGFloat)width boardColor:(UIColor*)boardColor{
    for (UIView *view in viewArr) {
        view.layer.borderWidth = width;
        view.layer.borderColor = boardColor.CGColor;
    }
}

@end
