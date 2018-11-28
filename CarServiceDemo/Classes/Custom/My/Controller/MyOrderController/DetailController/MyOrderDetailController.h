//
//  MyOrderDetailController.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"

@interface MyOrderDetailController : QMBaseVC

@property (copy, nonatomic) NSString *orderID;
@property (assign, nonatomic) BOOL isUpkeep;

@property (copy, nonatomic) void (^orderChangeBlock) (void);

@end
