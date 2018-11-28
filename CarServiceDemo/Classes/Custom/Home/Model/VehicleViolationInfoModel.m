//
//  VehicleViolationInfoModel.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/11.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "VehicleViolationInfoModel.h"

@implementation VehicleViolationInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end
