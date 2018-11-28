//
//  ShopCartModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShopCartModel.h"

@implementation ShopCartModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation ShopCartProductModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
