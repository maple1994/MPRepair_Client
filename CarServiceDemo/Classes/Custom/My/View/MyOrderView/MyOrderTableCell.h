//
//  MyOrderTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyMaintainModel;

@interface MyOrderTableCell : UITableViewCell

@property (strong, nonatomic) MyMaintainModel *nowModel;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (copy, nonatomic) void (^orderChangeBlock) (void);

@end
