//
//  PackageSelectionModel.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "PackageSelectionModel.h"


@implementation PackageSelectionComboitemSetModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

@end


@implementation PackageSelectionModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

@end
