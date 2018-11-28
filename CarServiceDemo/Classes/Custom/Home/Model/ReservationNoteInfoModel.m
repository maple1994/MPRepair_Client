//
//  ReservationNoteInfoModel.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/10/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ReservationNoteInfoModel.h"

@implementation ReservationNoteInfoModel

#pragma mark - 单例设计
static ReservationNoteInfoModel *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (ReservationNoteInfoModel *)noteInfo
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
    self.subscribe_time = @"";
    self.longitude = @"";
    self.latitude = @"";
    self.address = @"";
    self.name = @"";

}


+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end
