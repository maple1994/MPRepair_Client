//
//  XFBTextField.m
//  
//  调换UITextField的 leftView的位置
//  Created by  on 16/9/20.
//  Copyright © 2016年 . All rights reserved.
//

#import "QMTextField.h"

@implementation QMTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"icon_magnifier_search"];
//    searchIcon.width = 12;
//    searchIcon.height = 12;
    searchIcon.contentMode = UIViewContentModeCenter;
    self.leftView = searchIcon;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    return iconRect;
}


- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 0);
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 30, 0);
}


@end
