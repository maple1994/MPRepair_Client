//
//  ImageObjectModel.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ImageObjectModel.h"

@implementation ImageObjectModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
