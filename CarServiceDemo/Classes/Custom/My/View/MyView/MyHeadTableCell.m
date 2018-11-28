//
//  MyHeadTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyHeadTableCell.h"
#import "SettingController.h"
#import "MyOrderController.h"

@implementation MyHeadTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)settingButtonAction:(id)sender {
    SettingController *settingVC = [[SettingController alloc] init];
    [self.viewController.navigationController pushViewController:settingVC animated:YES];
    
    kWeakSelf(weakSelf)
    settingVC.settingSuccessBlock = ^{
        if (weakSelf.setBlock) {
            weakSelf.setBlock();
        }
    };
}

- (IBAction)orderButtonAction:(UIButton*)sender {
    MyOrderController *myOrderVC = [[MyOrderController alloc] init];
    myOrderVC.selectIndex = sender.tag-100;
    [self.viewController.navigationController pushViewController:myOrderVC animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
