//
//  OilModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/20.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OilModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *L;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *nowPrice;
@property (copy, nonatomic) NSString *pic_url;
@property (copy, nonatomic) NSString *amount;
@property (assign, nonatomic) BOOL hadSelect;

@end
