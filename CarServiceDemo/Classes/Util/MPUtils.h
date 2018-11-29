//
//  MPUtils.h
//  CarServiceDemo
//
//  Created by Maple on 2018/11/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 工具类
@interface MPUtils : NSObject

+ (void)showNavWithSourceLatitude: (double)sLatitude Sourcelongtitude: (double)sLongtitude desLatitude: (double)dLatitude desLongtitude: (double)dLongtitude desName: (NSString *)desName;

@end

NS_ASSUME_NONNULL_END
