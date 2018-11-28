//
//  ProductModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/14.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}


@end
