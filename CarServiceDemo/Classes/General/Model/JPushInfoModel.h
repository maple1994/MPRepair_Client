//
//  JPushInfoModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/10/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JPushInfoDataModel : JSONModel

/// ids
@property (nonatomic ,copy)NSString *ID;
/// 信息
@property (nonatomic ,copy)NSString *msg;
/// 是否接单
@property (nonatomic ,copy)NSString *state;

@end

@interface JPushInfoModel : JSONModel

/// 类型
@property (nonatomic ,copy)NSString *type;

///
@property (nonatomic ,strong)JPushInfoDataModel *data;

@end

