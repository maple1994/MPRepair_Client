//
//  AnnualInspectionNoteInfoModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/10/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnnualInspectionNoteInfoModel : JSONModel
+ (AnnualInspectionNoteInfoModel *)noteInfo;
- (void)clean;
///
@property (nonatomic ,copy)NSString *name;
///
@property (nonatomic ,copy)NSString *phone;
///
@property (nonatomic ,copy)NSString *car_name;
///
@property (nonatomic ,copy)NSString *car_brand;
///
@property (nonatomic ,copy)NSString *car_code;

@end

NS_ASSUME_NONNULL_END
