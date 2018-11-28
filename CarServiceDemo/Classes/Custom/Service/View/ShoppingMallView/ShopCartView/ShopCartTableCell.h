//
//  ShopCartTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"

@interface ShopCartTableCell : UITableViewCell

@property (strong, nonatomic) ShopCartModel *nowModel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (copy, nonatomic) void (^selectChangeBlock) (void);

@end
