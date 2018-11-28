//
//  CarBrandModel.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/28.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "CarBrandModel.h"

@implementation CarBrandModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}


@end
