//
//  GarageModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/13.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GarageModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *user_name;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *mobile_phone;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *oil_block;
@property (copy, nonatomic) NSString *work_price;
@property (copy, nonatomic) NSString *pic_url;
@property (copy, nonatomic) NSString *filter_price;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *popular;
@property (copy, nonatomic) NSString *distance;
@property (copy, nonatomic) NSString *type;

@end
