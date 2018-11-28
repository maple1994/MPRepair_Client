//
//  PaymentController.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
#import "PayModel.h"

@interface PaymentController : QMBaseVC

@property (assign,nonatomic) BOOL isOredrDetail;
@property (strong,nonatomic) NSString *orderID;
@property (assign,nonatomic) PayType payType;

@end
