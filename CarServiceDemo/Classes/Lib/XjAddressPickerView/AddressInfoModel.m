//
//  AddressInfoModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/25.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AddressInfoModel.h"

@implementation AddressInfoModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
