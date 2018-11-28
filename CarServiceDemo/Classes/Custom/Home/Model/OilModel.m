//
//  OilModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/20.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "OilModel.h"

@implementation OilModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id",@"nowPrice":@"new_price"}];
}

@end
