//
//  ApplyAfterServiceController.h
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyAfterServiceController : QMBaseVC

@property (copy ,nonatomic) NSString *orderID;
@property (assign ,nonatomic) NSInteger typeID;  //1.保养，2.维修

@end

NS_ASSUME_NONNULL_END