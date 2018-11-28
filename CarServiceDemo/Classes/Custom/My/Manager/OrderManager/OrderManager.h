//
//  OrderManager.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderManager : NSObject

+ (void)getMallOrderListDataWithState:(NSString*)state isComment:(BOOL)flag successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
+ (void)getOrderLogisticsDataWithID:(NSString*)orderID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;
+ (void)getMallOrderListDataWithID:(NSString*)ID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;
+ (void)getMyOrderListDataWithState:(NSString*)state isComment:(BOOL)flag successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
+ (void)getMyMaintenanceRecordDataWithState:(NSString*)state successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
+ (void)commitUserStarToOrderWithStar:(NSString*)star andID:(NSString*)ID andMethod:(NSString*)method successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;
+ (void)deleteUserMallOrderWIthID:(NSString*)ID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;

+ (void)upkeepOrMaintainEvaluateOrPayActionIsUpkeep:(BOOL)isUpkeep andMethodIsFinish:(BOOL)isFinish andID:(NSString*)ID andScroe:(NSString*)scroe successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;
+ (void)deleteUpkeepMraintainOrderIsUpKeep:(BOOL)isUpKeep andID:(NSString*)ID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;
+ (void)affirmCollectionCarWithOrderID:(NSString*)orderID successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail;
+ (void)changeMaintainOrderProjectWithID:(NSString*)orderID andItem_list:(NSString*)item_listStr successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail;

+ (void)getMaintainDetailDataWithID:(NSString*)maintainID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;

+ (void)getUpkeepDetailDataWithID:(NSString*)upkeepID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;
@end
