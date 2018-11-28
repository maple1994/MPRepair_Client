//
//  AnnualInspectionOrderDetailsInfoVC.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/22.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
#import "AnnualInspectionHistoryModel.h"

@interface AnnualInspectionOrderDetailsInfoVC : QMBaseVC
/// 列表页传过来的订单详情
@property (nonatomic ,strong)AnnualInspectionHistoryModel *dataModel;

@property (copy ,nonatomic) void (^changeBlock) (void);
@end
