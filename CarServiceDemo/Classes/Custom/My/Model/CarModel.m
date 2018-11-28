//
//  CarModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/10.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
