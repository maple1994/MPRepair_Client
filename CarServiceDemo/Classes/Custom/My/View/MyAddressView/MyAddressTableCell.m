//
//  MyAddressTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyAddressTableCell.h"
#import "AddAddressController.h"
#import "MyAddressModel.h"

@implementation MyAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setNowModel:(MyAddressModel *)nowModel{
    _nowModel = nowModel;
    if (!nowModel.is_default) {
        _defaultIconImageWidth.constant = 0;
        _addressLeftConstant.constant = 0;
    }else{
        _defaultIconImageWidth.constant = 28;
        _addressLeftConstant.constant = 6;
    }
}

- (IBAction)editeAddressButtonAction:(id)sender {
    AddAddressController *editeAddressVC = [[AddAddressController alloc] init];
    editeAddressVC.isEdite = YES;
    editeAddressVC.addressModel = self.nowModel;
    [self.viewController.navigationController pushViewController:editeAddressVC animated:YES];
    kWeakSelf(weakSelf)
    editeAddressVC.saveBtnBlock = ^{
        if (weakSelf.changeBlock) {
            weakSelf.changeBlock();
        }
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
