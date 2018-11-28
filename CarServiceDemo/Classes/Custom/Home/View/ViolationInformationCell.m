//
//  ViolationInformationCell.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ViolationInformationCell.h"

@interface ViolationInformationCell()
///  违章
@property (weak, nonatomic) IBOutlet UILabel *numberOfViolationsLabel;
/// 扣分
@property (weak, nonatomic) IBOutlet UILabel *deductionPointsLabel;
/// 扣款
@property (weak, nonatomic) IBOutlet UILabel *totalDeductionsLabel;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *carIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *carCodeLabel;

@end


@implementation ViolationInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(VehicleViolationInfoModel *)model{
    [NetWorkingUtil setImage:self.carIconImageView url:model.car_pic_url defaultIconName:KDefaultImage completed:nil];
    self.carCodeLabel.text = model.car_code;
    self.numberOfViolationsLabel.text = model.amount;
    self.deductionPointsLabel.text = model.score;
    self.totalDeductionsLabel.text = model.price;
    self.nameLabel.text = model.car_brand;
    
}

@end
