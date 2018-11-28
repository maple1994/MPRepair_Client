//
//  VehicleViolationInfoModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/11.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VehicleViolationInfoModel : JSONModel
/// 创建时间
@property (nonatomic ,copy)NSString *create_time;
/// 修改时间
@property (nonatomic ,copy)NSString *update_time;

/// 扣分
@property (nonatomic ,copy)NSString *score;
/// 罚款
@property (nonatomic ,copy)NSString *price;
/// id
@property (nonatomic ,copy)NSString *ID;
/// 车辆信息
@property (nonatomic ,copy)NSString *car_brand;
/// 违章次数
@property (nonatomic ,copy)NSString *amount;
@property (nonatomic ,copy)NSString *car_code;
@property (nonatomic ,copy)NSString *car_pic_url;

@end

