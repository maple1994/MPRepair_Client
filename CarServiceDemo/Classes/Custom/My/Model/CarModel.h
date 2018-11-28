//
//  CarModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/10.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *brand_name;
@property (copy, nonatomic) NSString *car_brand_id;
@property (copy, nonatomic) NSString *car_type_id;
@property (copy, nonatomic) NSString *car_style_id;
@property (copy, nonatomic) NSString *buy_time;
@property (copy, nonatomic) NSString *engine;
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *pic_url;
@property (copy, nonatomic) NSString *city_code;
@property (copy, nonatomic) NSString *classsno;
@property (copy, nonatomic) NSString *hpzl;
@property (copy, nonatomic) NSString *city_name;
@property (copy, nonatomic) NSString *province_name;
@property (assign, nonatomic) BOOL is_default;

@end
