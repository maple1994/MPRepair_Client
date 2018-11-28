//
//  PackageSelectionModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol PackageSelectionComboitemSetModel
@end

@interface PackageSelectionComboitemSetModel : JSONModel
/// id
@property (nonatomic ,copy)NSString *ID;
/// 名称
@property (nonatomic ,copy)NSString *name;
/// 价格
@property (nonatomic ,copy)NSString *price;

///
@property (nonatomic ,assign)BOOL isSelect;

@end


@interface PackageSelectionModel : JSONModel
/// id
@property (nonatomic ,copy)NSString *ID;
/// 创建时间
@property (nonatomic ,copy)NSString *create_time;
/// 修改时间
@property (nonatomic ,copy)NSString *update_time;
/// 名称
@property (nonatomic ,copy)NSString *name;
/// 套餐内容
@property (nonatomic ,copy)NSString *comboitem_set;


@end
