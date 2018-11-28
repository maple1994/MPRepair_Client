//
//  OrderManager.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "OrderManager.h"
#import "MyMaintainModel.h"
#import "MallOrderModel.h"
#import "UpkeepModel.h"
#import "OrderlogisticsModel.h"

@implementation OrderManager

+ (void)getMallOrderListDataWithState:(NSString*)state  isComment:(BOOL)flag successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = state;
    if (flag) {
        params[@"is_comment"] = @"0";
    }
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/order/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                MallOrderModel *model = [[MallOrderModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getOrderLogisticsDataWithID:(NSString*)orderID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = orderID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/orderlogistics/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            OrderlogisticsModel *model = [[OrderlogisticsModel alloc] init];
            NSArray *dataArr = obj;
            if (dataArr.count > 0) {
                NSDictionary *lastDict = [obj lastObject];
                model = [[OrderlogisticsModel alloc] initWithDictionary:lastDict error:nil];
            }
            
            success(model);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}


+ (void)getMallOrderListDataWithID:(NSString*)ID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = ID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/order/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            MallOrderModel *model = [[MallOrderModel alloc] initWithDictionary:obj error:nil];
            success(model);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getMyOrderListDataWithState:(NSString*)state isComment:(BOOL)flag successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"state"] = state;
    if (flag) {
        params[@"is_comment"] = @"0";
    }
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/maintain/list/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                MyMaintainModel *model = [[MyMaintainModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getMyMaintenanceRecordDataWithState:(NSString*)state successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"finish"] = state;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/maintain/maintain/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                MyMaintainModel *model = [[MyMaintainModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)commitUserStarToOrderWithStar:(NSString*)star andID:(NSString*)ID andMethod:(NSString*)method successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = ID;
    params[@"method"] = method;
    if ([method isEqualToString:@"comment"]) {
        params[@"score"] = star;
    }
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/service/order_method/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            if ([method isEqualToString:@"comment"]) {
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"评价成功"];
            }else{
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            }
            
            success(@"1");
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)deleteUserMallOrderWIthID:(NSString*)ID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = ID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/order_delete/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"删除成功"];
            success(@"1");
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)upkeepOrMaintainEvaluateOrPayActionIsUpkeep:(BOOL)isUpkeep andMethodIsFinish:(BOOL)isFinish andID:(NSString*)ID andScroe:(NSString*)scroe successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSString *url = @"";
    if (isUpkeep) {
        url = @"/api/maintain/upkeep_method/";
    }else{
        url = @"/api/maintain/maintain_method/";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = ID;
    if (isFinish) {
        params[@"method"] = @"finish";
    }else {
        params[@"method"] = @"comment";
        params[@"score"] = scroe;
    }
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:url parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            if (isFinish) {
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"确认成功"];
            }else{
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            }
            success(@"1");
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)deleteUpkeepMraintainOrderIsUpKeep:(BOOL)isUpKeep andID:(NSString*)ID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSString *url = @"";
    if (isUpKeep) {
        url = @"/api/maintain/upkeep_delete/";
    }else{
        url = @"/api/maintain/maintain_delete/";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = ID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:url parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"删除成功"];
            success(@"1");
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getMaintainDetailDataWithID:(NSString*)maintainID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = maintainID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/maintain/maintain/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            MyMaintainModel *model = [[MyMaintainModel alloc] initWithDictionary:obj error:nil];
            model.type = @"maintain";
            success(model);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)changeMaintainOrderProjectWithID:(NSString*)orderID andItem_list:(NSString*)item_listStr successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = orderID;
    params[@"item_list"] = item_listStr;
    params[@"method"] = @"item_list";
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/maintain/maintain_method/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getUpkeepDetailDataWithID:(NSString*)upkeepID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = upkeepID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/maintain/upkeep/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            UpkeepModel *model = [[UpkeepModel alloc] initWithDictionary:obj error:nil];
            success(model);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

@end
