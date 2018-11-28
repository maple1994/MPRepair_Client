//
//  AnnualInspectionNoteInfoModel.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/10/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionNoteInfoModel.h"

@implementation AnnualInspectionNoteInfoModel

#pragma mark - 单例设计
static AnnualInspectionNoteInfoModel *_instance;
static dispatch_once_t onceToken;

+ (id)allocWithZone:(NSZone *)zone
{
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (AnnualInspectionNoteInfoModel *)noteInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)clean{
    self.name = @"";
    self.phone = @"";
    self.car_name = @"";
    self.car_brand = @"";
    self.car_code = @"";
}


+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
