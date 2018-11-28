//
//  UIImageView+Extension.m
//  
//
//  Created by yang on 2017/7/12.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)


- (UIImageView *)initWithFrame:(CGRect)frame image:(UIImage *)image selector:(SEL)selector target:(id)target {
    
    UIImageView *imagev = [[UIImageView alloc] init];
    imagev.image = image;
    imagev.contentMode = UIViewContentModeScaleAspectFit;
    imagev.userInteractionEnabled = YES;
    imagev.frame = frame;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    [imagev addGestureRecognizer:tap];
    return imagev;
}


@end
