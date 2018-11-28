//
//  OrderMaintainDetailTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OilModel;

@interface OrderMaintainDetailTableCell : UITableViewCell

@property (strong, nonatomic) OilModel *nowModel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (copy, nonatomic) void (^selectBlock) ();

@end
