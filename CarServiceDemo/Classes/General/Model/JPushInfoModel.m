//
//  JPushInfoModel.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/10/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "JPushInfoModel.h"


@implementation JPushInfoDataModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

@end


@implementation JPushInfoModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
