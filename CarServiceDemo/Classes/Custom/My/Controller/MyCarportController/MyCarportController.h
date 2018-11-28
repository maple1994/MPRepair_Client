//
//  MyCarportController.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
@class CarModel;

@interface MyCarportController : QMBaseVC

@property (assign, nonatomic) BOOL isSelect;
@property (copy, nonatomic) void (^selectMyCarBlock) (CarModel *carModel);

@end
