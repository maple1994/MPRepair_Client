//
//  MyOrderProjectTableCell.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageObjectModel.h"

@interface MyOrderProjectTableCell : UITableViewCell

@property (strong, nonatomic) ImageObjectModel *nowModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonWidth;

@property (copy,nonatomic) void (^cancelBtnBlock) (ImageObjectModel *cancelModel);

@end
