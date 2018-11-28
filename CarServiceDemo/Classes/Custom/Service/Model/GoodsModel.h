//
//  GoodsModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CataLogModel.h"

@protocol CataLogModel <NSObject>
@end

@interface GoodsModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *pic_url;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *special_price;
@property (copy, nonatomic) NSString *param;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *detail_url;
@property (strong, nonatomic) CataLogModel *catalog;
@property (copy, nonatomic) NSString *amount;
@property (copy, nonatomic) NSString *sale;
@property (copy, nonatomic) NSArray *pic_url_list;

@end
