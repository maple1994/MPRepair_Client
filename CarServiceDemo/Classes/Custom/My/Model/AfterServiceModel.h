//
//  AfterServiceModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/10/26.
//  Copyright © 2018 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ImageObjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AfterServiceModel : JSONModel

@property (copy, nonatomic) NSString *ID;
/// 订单单号
@property (copy, nonatomic) NSString *order_id;
/// 车辆号码
@property (copy, nonatomic) NSString *car_code;
/// 车辆型号
@property (copy, nonatomic) NSString *car_type;
/// 类型 upkeep:保养，maintain:维修
@property (copy, nonatomic) NSString *type;
/// 申请时间
@property (copy, nonatomic) NSString *create_time;
/// 状态 0服务中，1以完成
@property (copy, nonatomic) NSString *state;
/// 图片对象列表
@property (strong, nonatomic) NSArray<ImageObjectModel> *pic_list;

@end

NS_ASSUME_NONNULL_END
