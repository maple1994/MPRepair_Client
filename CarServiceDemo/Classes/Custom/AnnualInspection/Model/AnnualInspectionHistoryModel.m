//
//  AnnualInspectionHistoryModel.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/16.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionHistoryModel.h"

@implementation obj_list
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation image_list
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end



@implementation failureitem_list
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation failure_object
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end


@implementation surveypic_list
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation surveycomboitem_set
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation surveystation
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

@end

@implementation AnnualInspectionHistoryModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

@end
