//
//  ShopingMallManager.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShopingMallManager.h"
#import "GoodsModel.h"
#import "ShopCartModel.h"
#import "CataLogModel.h"

@implementation ShopingMallManager

- (void)getShopingMallTopCategoryDataWithTypeID:(NSString*)typeID andPID:(NSString*)pID isSon:(BOOL)flag successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail {
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (!flag) {
        params[@"type"] = typeID;
    }else{
        params[@"id"] = typeID;
    }
    
    params[@"p_id"] = pID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/catalog/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                CataLogModel *model = [[CataLogModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            
            if (resultArrM.count>0&&[pID isEqualToString:@"0"]) {
                CataLogModel *model = [resultArrM firstObject];
                model.hadSelect = YES;
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

- (void)getShopingMallGoodsListDataWithCataLogId:(NSString*)catalogID andPriceOrder:(NSString*)priceOrder andSaleOrder:(NSString*)saleOrder successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"catalog_id"] = catalogID;
    params[@"price_order"] = priceOrder;
    params[@"sale_order"] = saleOrder;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/product/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                GoodsModel *model = [[GoodsModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

- (void)getShopCartListDataSuccessBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/ordercar/" parameters:nil result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                ShopCartModel *model = [[ShopCartModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)addGoodsToShopCartWithProductId:(NSString*)product_id isAdd:(BOOL)flag andAmount:(NSString*)amount{
    
    if (flag) {
        [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (flag) {
        params[@"product_id"] = product_id;
    }else{
        params[@"id"] = product_id;
    }
    
    params[@"amount"] = amount;
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/service/ordercar/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            if (flag) {
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"添加成功"];
            }
            
        }else{
            
            if (flag) {
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            }
            
        }
        
    }];
}

+ (void)cancelShopCartGoodsWithIDString:(NSString*)IDString successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = IDString;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/ordercar_delete/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)commitOrderWithAddressID:(NSString*)addressID andShopCartID:(NSString*)shopCartID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"address_id"] = addressID;
    params[@"order_car_list"] = shopCartID;
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/service/order/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            NSString  *ID = [NSString stringWithFormat:@"%ld",[obj[@"id"] integerValue]];
            success(ID);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

@end
