//
//  AnnualInspectionStationInfoModel.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/15.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionStationInfoModel.h"

@implementation AnnualInspectionStationInfoModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
