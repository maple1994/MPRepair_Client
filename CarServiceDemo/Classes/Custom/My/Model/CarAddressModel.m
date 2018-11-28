//
//  CarAddressModel.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/11.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "CarAddressModel.h"

@implementation CarAddressModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation CarAddressChildModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
