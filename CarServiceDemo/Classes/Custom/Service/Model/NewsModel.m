//
//  NewsModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
