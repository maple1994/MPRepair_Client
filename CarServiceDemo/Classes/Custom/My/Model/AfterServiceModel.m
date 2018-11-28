//
//  AfterServiceModel.m
//  CarServiceDemo
//
//  Created by superButton on 2018/10/26.
//  Copyright © 2018 com.from. All rights reserved.
//

#import "AfterServiceModel.h"

@implementation AfterServiceModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
