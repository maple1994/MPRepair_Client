//
//  MyMaintainModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/13.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GarageModel.h"
#import "PicUrlListModel.h"
#import "ImageObjectModel.h"

typedef NS_ENUM(NSUInteger, MaintainType) {
    ///等待接单
    MaintainTypeWaitReceived = 0,
    ///等待支付
    MaintainTypeWaitPay,
    ///等待服务
    MaintainTypeWaitService,
    ///服务中
    MaintainTypeServiceNow,
    //已完成
    MaintainTypeSuccess,
    ///已接单
    MaintainTypeHasReceived,
};

@interface MyMaintainModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (strong, nonatomic) GarageModel *garage;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *subscribe_time;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *pic_url_list;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *discounts;
@property (copy, nonatomic) NSString *now_price;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) MaintainType state;
@property (copy, nonatomic) NSString *is_delete;
@property (assign, nonatomic) BOOL is_comment;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *order_time;
@property (copy, nonatomic) NSString *pay_time;
@property (copy, nonatomic) NSString *service_time;
@property (copy, nonatomic) NSString *comment_time;
@property (copy, nonatomic) NSString *over_time;
@property (copy, nonatomic) NSString *car_code;
@property (copy, nonatomic) NSString *car_type;
@property (copy, nonatomic) NSString *service_item;
@property (copy, nonatomic) NSString *service_materials;
@property (copy, nonatomic) NSString *deal_id;
@property (copy, nonatomic) NSString *order_id;
/// 是否设置维修清单
@property (copy, nonatomic) NSString *is_setting;
/// 是否可以售后
@property (copy, nonatomic) NSString *is_aftersales;
@property (copy, nonatomic) NSString *order_name;
@property (copy, nonatomic) NSString *order_pic_url;

@property (strong, nonatomic) NSArray<ImageObjectModel> *maintainpic_set;
@property (strong, nonatomic) NSMutableArray<ImageObjectModel> *maintainitem_set;
@property (strong, nonatomic) NSArray<ImageObjectModel> *maintainitem_set_now;

@end
