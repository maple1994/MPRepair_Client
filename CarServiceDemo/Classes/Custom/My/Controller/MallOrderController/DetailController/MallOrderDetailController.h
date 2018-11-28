//
//  MallOrderDetailController.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
@class MallOrderModel;

@interface MallOrderDetailController : QMBaseVC

@property (strong, nonatomic) MallOrderModel *orderModel;

@property (copy, nonatomic) void (^orderChangeBlock) (void);

@end
