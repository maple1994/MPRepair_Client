//
//  MallOrderModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/13.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MallOrderModel.h"

@implementation MallOrderModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
