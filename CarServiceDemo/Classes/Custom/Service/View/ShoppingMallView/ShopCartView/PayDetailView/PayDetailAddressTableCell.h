//
//  PayDetailAddressTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayDetailAddressTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *addAddressBackView;
@property (weak, nonatomic) IBOutlet UIView *addressDetailView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultIconImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeftConstant;

@end
