
//
//  AfterServiceTableCell.m
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AfterServiceTableCell.h"
#import "AfterServiceModel.h"

@implementation AfterServiceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)affirmButtonAction:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.nowModel.ID;
    params[@"method"] = @"finish";
    
    NSString *url = @"";
    if ([self.nowModel.type isEqualToString:@"upkeep_aftersales"]) {
        url = @"/api/maintain/upkeep_aftersales_method/";
    }else if ([self.nowModel.type isEqualToString:@"maintain_aftersales"]) {
        url = @"/api/maintain/maintain_aftersales_method/";
    }
    
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/maintain/maintain_aftersales_method/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            if (weakSelf.changeBlock) {
                weakSelf.changeBlock();
            }
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
        }
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
