//
//  PayDetailBottomTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "PayDetailBottomTableCell.h"
#import "IntegralHintView.h"

@implementation PayDetailBottomTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)hintButtonAction:(id)sender {
    IntegralHintView *integralHintView = [[IntegralHintView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.window addSubview:integralHintView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
