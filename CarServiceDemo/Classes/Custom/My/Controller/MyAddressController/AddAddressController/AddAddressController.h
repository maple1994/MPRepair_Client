//
//  AddAddressController.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
@class MyAddressModel;

@interface AddAddressController : QMBaseVC

@property (strong, nonatomic) MyAddressModel *addressModel;

@property (assign, nonatomic) BOOL isEdite;

@property (copy, nonatomic) void (^saveBtnBlock) (void);
@end
