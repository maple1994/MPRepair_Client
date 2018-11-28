//
//  MyOrderDetailTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UpkeepModel;
@class MyMaintainModel;

@interface MyOrderDetailTableView : UITableView

@property (strong,nonatomic) UpkeepModel *upkeepModel;
@property (strong,nonatomic) MyMaintainModel *maintainModel;

@property (copy, nonatomic) void (^tableChangeBlock) (BOOL isDelete);

@end
