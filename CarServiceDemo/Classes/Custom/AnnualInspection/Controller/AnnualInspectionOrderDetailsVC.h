//
//  AnnualInspectionOrderDetailsVC.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
#import "AnnualInspectionHistoryModel.h"

typedef enum : NSUInteger {
//    OrderDetailsStatusNote = 0,//填写信息
    OrderDetailsStatusPickUpTheCar = 2,//代驾取车
    OrderDetailsStatusStartAnnualInspection = 3,//开始年检
    OrderDetailsStatusStartAnnualInspectionAndReturn = 7,//检完还车
} OrderDetailsStatus;

@interface AnnualInspectionOrderDetailsVC : QMBaseVC

@property (nonatomic ,assign)OrderDetailsStatus orderStatus;

/// 列表页传过来的订单详情
@property (nonatomic ,strong)AnnualInspectionHistoryModel *dataModel;
@end
