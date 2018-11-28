//
//  MyMaintainModel.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/13.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyMaintainModel.h"

@implementation MyMaintainModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

- (void)setIs_setting:(NSString *)is_setting{
    _is_setting = is_setting;
    
    if (_state == MaintainTypeWaitPay&&[_type isEqualToString:@"maintain"]) {
        if ([_is_setting isEqualToString:@"0"]) {
            _state = MaintainTypeHasReceived;
        }else{
            _state = MaintainTypeWaitPay;
        }
    }
}

- (void)setType:(NSString *)type{
    _type = type;
    
    if (_state == MaintainTypeWaitPay&&[_type isEqualToString:@"maintain"]) {
        if ([_is_setting isEqualToString:@"0"]) {
            _state = MaintainTypeHasReceived;
        }else{
            _state = MaintainTypeWaitPay;
        }
    }
}

@end
