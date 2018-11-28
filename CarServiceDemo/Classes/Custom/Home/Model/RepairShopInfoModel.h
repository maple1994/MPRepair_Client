//
//  RepairShopInfoModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/11.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface RepairShopInfoModel : JSONModel

/// id
@property (nonatomic ,copy)NSString *ID;
/// 创建时间
@property (nonatomic ,copy)NSString *create_time;
/// 修改时间
@property (nonatomic ,copy)NSString *update_time;
/// 名称
@property (nonatomic ,copy)NSString *name;
/// 负责人名称
@property (nonatomic ,copy)NSString *user_name;
/// 经度
@property (nonatomic ,copy)NSString *longitude;
/// 纬度
@property (nonatomic ,copy)NSString *latitude;
/// 地址
@property (nonatomic ,copy)NSString *address;
/// 手机号码
@property (nonatomic ,copy)NSString *mobile_phone;
/// 固定电话
@property (nonatomic ,copy)NSString *phone;
/// 机油格价格 保养使用
@property (nonatomic ,copy)NSString *oil_block;
/// 工时费 保养使用
@property (nonatomic ,copy)NSString *work_price;
/// 人气
@property (nonatomic ,copy)NSString *popular;
/// 封面url
@property (nonatomic ,copy)NSString *pic_url;
/// 过滤格费用
@property (nonatomic ,copy)NSString *filter_price;
/// 距离
@property (nonatomic ,copy)NSString *distance;

@property (nonatomic ,copy)NSString *score;
@end
