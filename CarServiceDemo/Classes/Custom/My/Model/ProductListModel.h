//
//  ProductListModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/14.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductModel.h"

@protocol ProductModel <NSObject>
@end

@interface ProductListModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (strong, nonatomic) ProductModel *product;
@property (copy, nonatomic) NSString *amount;
@property (copy, nonatomic) NSString *price;

@end
