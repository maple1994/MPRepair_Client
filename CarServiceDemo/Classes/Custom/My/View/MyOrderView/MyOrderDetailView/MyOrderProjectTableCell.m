
//
//  MyOrderProjectTableCell.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderProjectTableCell.h"

@implementation MyOrderProjectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)cancelVButtonAction:(id)sender {
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock(self.nowModel);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
