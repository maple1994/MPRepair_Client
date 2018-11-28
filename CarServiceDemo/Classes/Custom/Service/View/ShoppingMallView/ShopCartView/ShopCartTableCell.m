//
//  ShopCartTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShopCartTableCell.h"
#import "ShopCartModel.h"
#import "ShopingMallManager.h"

@implementation ShopCartTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [UIView setViewBoardLine:@[_reduceButton,_numberLabel,_addButton] boardWidth:0.5 boardColor:[UIColor colorwithHexString:@"#5B5B5B"]];
    [_selectButton setEnlargeEdge:20];
    [_reduceButton setEnlargeEdge:10];
    [_addButton setEnlargeEdge:10];
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
    
    [ShopingMallManager addGoodsToShopCartWithProductId:_nowModel.ID isAdd:NO andAmount:_numberLabel.text];
    
    if (self.nowModel.product.hadSelect) {
        if (self.selectChangeBlock) {
            _selectChangeBlock();
        }
    }
}

- (IBAction)addButtonAction:(id)sender {
    NSInteger number = [_nowModel.amount integerValue];
    number++;
    _nowModel.amount = [NSString stringWithFormat:@"%ld",number];
    _numberLabel.text = [NSString stringWithFormat:@"%ld",number];
    
    [ShopingMallManager addGoodsToShopCartWithProductId:_nowModel.ID isAdd:NO andAmount:_numberLabel.text];
    
    if (self.nowModel.product.hadSelect) {
        if (self.selectChangeBlock) {
            _selectChangeBlock();
        }
    }
}

- (IBAction)selectButtonAction:(id)sender {
    _selectButton.selected = !_selectButton.selected;
    _nowModel.product.hadSelect = _selectButton.selected;
    
    if (self.selectChangeBlock) {
        _selectChangeBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
