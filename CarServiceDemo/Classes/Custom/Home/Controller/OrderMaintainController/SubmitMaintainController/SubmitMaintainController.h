//
//  SubmitMaintainController.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"
@class RepairShopInfoModel;

@interface SubmitMaintainController : QMBaseVC

@property (copy, nonatomic) NSString *oilID;
@property (copy, nonatomic) NSString *oilAmount;
@property (copy, nonatomic) NSString *oilNumber;
@property (nonatomic ,strong)RepairShopInfoModel *repairModel;
@property (copy, nonatomic) NSString *price;
//维修进入
@property (assign,nonatomic) BOOL isMaintain;
@property (strong,nonatomic) NSMutableDictionary *maintainDictM;

@end
