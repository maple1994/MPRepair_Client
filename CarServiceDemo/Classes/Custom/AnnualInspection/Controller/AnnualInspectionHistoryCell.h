//
//  AnnualInspectionHistoryCell.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnualInspectionHistoryModel.h"

@interface AnnualInspectionHistoryCell : UITableViewCell
///
@property (nonatomic ,strong)AnnualInspectionHistoryModel *model;

/// 筛选条件
@property (nonatomic ,copy)NSString *orderby;

@end