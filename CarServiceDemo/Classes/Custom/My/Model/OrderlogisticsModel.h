//
//  OrderlogisticsModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/12.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OrderlogisticsModel : JSONModel

@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *status;

@end
