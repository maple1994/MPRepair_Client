//
//  OrderMaintainDetailTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "OrderMaintainDetailTableCell.h"
#import "OilModel.h"

@implementation OrderMaintainDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [UIView setViewBoardLine:@[_reduceButton,_numberLabel,_addButton] boardWidth:0.5 boardColor:[UIColor colorwithHexString:@"#5B5B5B"]];
    [_selectButton setEnlargeEdge:20];
    [_reduceButton setEnlargeEdge:10];
    [_addButton setEnlargeEdge:10];
}

- (IBAction)selectButtonAction:(id)sender {
    if (sender) {
        _selectButton.selected = !_selectButton.selected;
        _nowModel.hadSelect = _selectButton.selected;
    }
    
    if ([ValidateUtil isEmptyStr:_nowModel.amount]||[_nowModel.amount isEqualToString:@"0"]) {
        _nowModel.amount = @"1";
    }
    if (self.selectBlock) {
        self.selectBlock();
    }
}

- (IBAction)reduceButtonAction:(id)sender {
    NSInteger number = [_nowModel.amount integerValue];
    if (number==1) {
        return;
    }else{
        number--;
        _nowModel.amount = [NSString stringWithFormat:@"%ld",number];
        _numberLabel.text = [NSString stringWithFormat:@"%ld",number];
    }
    [self selectButtonAction:nil];
}

- (IBAction)addButtonAction:(id)sender {
    NSInteger number = [_nowModel.amount integerValue];
    number++;
    _nowModel.amount = [NSString stringWithFormat:@"%ld",number];
    _numberLabel.text = [NSString stringWithFormat:@"%ld",number];
    
    [self selectButtonAction:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
