//
//  PayModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/25.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSUInteger, PayType) {
    PayTypeMallOrder,
    PayTypeUpKeepOrder,
    PayTypeMaintainOrder,
    PayTypeSelfSurvey,//自驾年检
    PayTypeReplaceSurvey,//代驾年检
};

@interface PayModel : JSONModel

@property (assign, nonatomic) NSInteger status;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *to;
@property (copy, nonatomic) NSString *order_code;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *params;

@end
