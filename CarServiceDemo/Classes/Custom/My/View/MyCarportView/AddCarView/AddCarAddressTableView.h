//
//  AddCarAddressTableView.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/10.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarAddressModel.h"

@interface AddCarAddressTableView : UITableView

@property (assign, nonatomic) BOOL isLeft;
@property (strong,nonatomic) NSMutableArray *dataArrM;

@property (copy, nonatomic) void (^leftSelectBlock) (NSString *provinceName,NSMutableArray *rightArrM);
@property (copy, nonatomic) void (^rightSelectBlock) (NSString *cityName,NSString *cityCode);
@property (copy,nonatomic) NSString *nowCityCode;
@property (copy,nonatomic) NSString *nowCityName;

@end
