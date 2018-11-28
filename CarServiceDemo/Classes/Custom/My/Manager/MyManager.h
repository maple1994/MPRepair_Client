//
//  MyManager.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyManager : NSObject


/**
 获取个人中心菜单数据

 @return 数据数组
 */
- (NSMutableArray*)getMyMenuData;

+ (void)modificationUserMessageWithImage:(UIImage*)userImage anduserName:(NSString*)userName andPhone:(NSString*)phone successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail;
+ (void)getCarportListDataIsDefault:(BOOL)isDefault successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
+ (void)addCarMessageWithParams:(NSMutableDictionary*)params successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail;
+ (void)cancelCarWithCarID:(NSString*)carID successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail;

+ (void)getMaintainOilListDataWithID:(NSString*)ID successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
+ (void)affirmPayMaintainOrderWithParams:(NSMutableDictionary*)params isUpKeep:(BOOL)isUpkeep successBlock:(GetBackStringBlock)success failBlock:(GetFailBlock)fail;

@end
