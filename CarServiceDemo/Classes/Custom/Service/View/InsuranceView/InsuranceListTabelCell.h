//
//  InsuranceListTabelCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsuranceListTabelCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *insuranceImageView;
@property (weak, nonatomic) IBOutlet UILabel *insuranceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceIntroduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *insurancePriceLabel;

@end
