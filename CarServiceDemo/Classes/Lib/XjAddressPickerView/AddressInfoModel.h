//
//  AddressInfoModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/25.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AddressInfoModel <NSObject>
@end

@interface AddressInfoModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<AddressInfoModel> *children;

@end
