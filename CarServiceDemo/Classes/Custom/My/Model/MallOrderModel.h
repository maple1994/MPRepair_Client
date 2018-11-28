//
//  MallOrderModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/13.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductListModel.h"

typedef NS_ENUM(NSUInteger, MallOrderState) {
    MallOrderStateWaitPay,
    MallOrderStateWaitDeliver,
    MallOrderStateWaitReceive,
    MallOrderStateSuccess,
};

@protocol ProductListModel <NSObject>
@end

@interface MallOrderModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *order_code;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) MallOrderState status;
@property (assign, nonatomic) BOOL is_delete;
@property (assign, nonatomic) BOOL is_comment;
@property (copy, nonatomic) NSString *logistics_info;
@property (copy, nonatomic) NSString *all_price;
@property (copy, nonatomic) NSString *point_price;
@property (copy, nonatomic) NSString *now_price;
@property (copy, nonatomic) NSString *cost_point;
@property (copy, nonatomic) NSString *order_time;
@property (copy, nonatomic) NSString *wait_time;
@property (copy, nonatomic) NSString *send_time;
@property (copy, nonatomic) NSString *receive_time;
@property (copy, nonatomic) NSString *confirm_time;
@property (strong, nonatomic) NSArray<ProductListModel> *orderproduct_set;

@end
