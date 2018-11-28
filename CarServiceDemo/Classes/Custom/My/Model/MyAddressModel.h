//
//  MyAddressModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CityModel :JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *p_id;

@end

@protocol CityModel <NSObject>
@end

@interface MyAddressModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (strong, nonatomic) CityModel *node1;
@property (strong, nonatomic) CityModel *node2;
@property (strong, nonatomic) CityModel *node3;
@property (assign, nonatomic) BOOL is_default;
@property (copy, nonatomic) NSString *address;

@end

