//
//  AnnualInspectionStationInfoModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/15.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AnnualInspectionStationInfoModel : JSONModel

/**
 * id
 */
@property (nonatomic ,copy)NSString *ID;
/// 创建时间
@property (nonatomic ,copy)NSString *create_time;
/// 修改时间
@property (nonatomic ,copy)NSString *update_time;
/// 名称
@property (nonatomic ,copy)NSString *name;
/// 经度
@property (nonatomic ,copy)NSString *longitude;
/// 纬度
@property (nonatomic ,copy)NSString *latitude;
/// 地址
@property (nonatomic ,copy)NSString *address;

@end
