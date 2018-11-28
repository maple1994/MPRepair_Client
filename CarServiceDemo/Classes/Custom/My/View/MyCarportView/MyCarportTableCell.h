//
//  MyCarportTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarportTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *carCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carMileageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;

@end
