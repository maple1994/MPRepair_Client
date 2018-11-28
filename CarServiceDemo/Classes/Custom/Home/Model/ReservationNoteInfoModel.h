//
//  ReservationNoteInfoModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/10/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReservationNoteInfoModel : JSONModel
+ (ReservationNoteInfoModel *)noteInfo;
- (void)clean;
///
@property (nonatomic ,copy)NSString *name;
///
@property (nonatomic ,copy)NSString *phone;
///
@property (nonatomic ,copy)NSString *subscribe_time;
///
@property (nonatomic ,copy)NSString *longitude;
///
@property (nonatomic ,copy)NSString *latitude;
///
@property (nonatomic ,copy)NSString *address;
@end

NS_ASSUME_NONNULL_END
