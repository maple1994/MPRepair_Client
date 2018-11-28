//
//  IntegralHintView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "IntegralHintView.h"

@interface IntegralHintView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation IntegralHintView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"IntegralHintView" owner:self options:nil]lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    _backView.cornerRadius = 8;
}

- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}

@end
