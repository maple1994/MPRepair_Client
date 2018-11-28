//
//  MyAddressTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAddressModel;

@interface MyAddressTableCell : UITableViewCell

@property (strong, nonatomic) MyAddressModel *nowModel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultIconImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeftConstant;

@property (copy, nonatomic) void (^changeBlock) (void);

@end
