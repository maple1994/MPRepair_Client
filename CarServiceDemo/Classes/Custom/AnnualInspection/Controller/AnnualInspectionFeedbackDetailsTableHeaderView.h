//
//  AnnualInspectionFeedbackDetailsTableHeaderView.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnualInspectionHistoryModel.h"


typedef void(^PayBlockCompleted)(void);

@interface AnnualInspectionFeedbackDetailsTableHeaderView : UITableViewHeaderFooterView

+ (instancetype)annualInspectionFeedbackDetailsTableHeaderViewCompleted:(PayBlockCompleted)payBlockCompleted;

/// 列表页传过来的订单详情
@property (nonatomic ,strong)AnnualInspectionHistoryModel *dataModel;
@end
