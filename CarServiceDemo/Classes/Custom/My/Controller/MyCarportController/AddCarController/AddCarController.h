//
//  AddCarController.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
@class CarModel;

@interface AddCarController : QMBaseVC

@property (strong, nonatomic) CarModel *carModel;
@property (assign, nonatomic) BOOL isEdite;
@property (copy, nonatomic) NSString *carStyleID;
@property (copy, nonatomic) NSString *carName;
@property (copy, nonatomic) void (^addCarBlock) (void);

@end
