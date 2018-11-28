//
//  MyHeadTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeadTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *myIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myIntegralLabel;

@property (copy, nonatomic) void (^setBlock) (void);

@end
