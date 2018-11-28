//
//  XFBButton.m
//  
//  调换image和title的位置
//  Created by  on 16/9/20.
//  Copyright © 2016年 . All rights reserved.
//

#import "XFBButton.h"


#define MARGIN 3

@implementation XFBButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setupCommon];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupCommon];
    }
    return self;
}

- (void)setupCommon {
    
//    self.backgroundColor = [UIColor yellowColor];
    self.midSpacing = MARGIN;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    switch (self.layoutStyle) {
        case XFBButtonStyleLeftImageRightTitle:
            [self layoutHorizontalWithLeftView:self.imageView rightView:self.titleLabel];
            break;
        case XFBButtonStyleLeftTitleRightImage:
            [self layoutHorizontalWithLeftView:self.titleLabel rightView:self.imageView];
            break;
        case XFBButtonStyleUpImageDownTitle:
            [self layoutVerticalWithUpView:self.imageView downView:self.titleLabel];
            break;
        case XFBButtonStyleUpTitleDownImage:
            [self layoutVerticalWithUpView:self.titleLabel downView:self.imageView];
            break;
        default:
            break;
    }
}


- (void)layoutHorizontalWithLeftView:(UIView *)leftView rightView:(UIView *)rightView {
    CGRect leftViewFrame = leftView.frame;
    CGRect rightViewFrame = rightView.frame;
    
    CGFloat totalWidth = CGRectGetWidth(leftViewFrame) + self.midSpacing + CGRectGetWidth(rightViewFrame);//0
    
    leftViewFrame.origin.x = (CGRectGetWidth(self.frame) - totalWidth) / 2.0;
    leftViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(leftViewFrame)) / 2.0;
    
    
    CGFloat maxWidth = CGRectGetWidth(self.frame) - rightViewFrame.size.width - self.midSpacing;
    if (leftViewFrame.size.width > maxWidth) {
        
        leftViewFrame.size.width = maxWidth;
    }
    
    leftView.frame = leftViewFrame;
    
    rightViewFrame.origin.x = CGRectGetMaxX(leftViewFrame) + self.midSpacing;
    rightViewFrame.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(rightViewFrame)) / 2.0;
    rightView.frame = rightViewFrame;
    
//    leftView.backgroundColor = [UIColor yellowColor];
//    rightView.backgroundColor = [UIColor greenColor];
}

- (void)layoutVerticalWithUpView:(UIView *)upView downView:(UIView *)downView {
    CGRect upViewFrame = upView.frame;
    CGRect downViewFrame = downView.frame;
    
    CGFloat totalHeight = CGRectGetHeight(upViewFrame) + self.midSpacing + CGRectGetHeight(downViewFrame);
    
    upViewFrame.origin.y = (CGRectGetHeight(self.frame) - totalHeight) / 2.0;
    upViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(upViewFrame)) / 2.0;
    upView.frame = upViewFrame;
    
    downViewFrame.origin.y = CGRectGetMaxY(upViewFrame) + self.midSpacing;
    downViewFrame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(downViewFrame)) / 2.0;
    downView.frame = downViewFrame;
}

//-(void)layoutBtnWithBtn:(UIButton *)button {
//    
////    button.titleLabel.backgroundColor = button.backgroundColor;
////    button.imageView.backgroundColor = button.backgroundColor;
//    
//    CGSize titleSize = button.titleLabel.bounds.size;
//    CGSize imageSize = button.imageView.bounds.size;
//    
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
//    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + MARGIN, 0, -titleSize.width - MARGIN);
//}

- (void)setMidSpacing:(CGFloat)midSpacing {
    
    _midSpacing = midSpacing;
    [self setNeedsLayout];
    [self layoutSubviews];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self setNeedsLayout];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setNeedsLayout];
}

@end
