//
//  UpkeepModel.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "UpkeepModel.h"

@implementation UpkeepModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
