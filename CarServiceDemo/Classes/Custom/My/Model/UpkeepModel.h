//
//  UpkeepModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GarageModel.h"
#import "ImageObjectModel.h"

typedef NS_ENUM(NSUInteger, UpkeepState) {
    UpkeepStateWaitReceived,
    UpkeepStateWaitPay,
    UpkeepStateWaitService,
    UpkeepStateServiceing,
    UpkeepStateSuccess,
};

@interface UpkeepModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (strong, nonatomic) GarageModel *garage;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *subscribe_time;
@property (copy, nonatomic) NSString *filter_price;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *discounts;
@property (copy, nonatomic) NSString *now_price;
@property (assign, nonatomic) UpkeepState state;
@property (copy, nonatomic) NSString *is_delete;
@property (copy, nonatomic) NSString *is_comment;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *order_time;
@property (copy, nonatomic) NSString *pay_time;
@property (copy, nonatomic) NSString *service_time;
@property (copy, nonatomic) NSString *comment_time;
@property (copy, nonatomic) NSString *over_time;
@property (copy, nonatomic) NSString *service_item;
@property (copy, nonatomic) NSString *service_materials;
@property (copy, nonatomic) NSString *deal_id;
@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSString *oil_name;
@property (copy, nonatomic) NSString *oil_L;
@property (copy, nonatomic) NSString *oil_price;
@property (copy, nonatomic) NSString *oil_new_price;
@property (copy, nonatomic) NSString *car_brand;
@property (copy, nonatomic) NSString *car_code;
@property (copy, nonatomic) NSString *project_material;
/// 是否可以售后
@property (copy, nonatomic) NSString *is_aftersales;
@property (strong, nonatomic) NSArray<ImageObjectModel> *upkeeppic_set;

@end
