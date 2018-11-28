//
//  ShopingMallManager.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopingMallManager : NSObject

- (void)getShopingMallTopCategoryDataWithTypeID:(NSString*)typeID andPID:(NSString*)pID isSon:(BOOL)flag successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
- (void)getShopingMallGoodsListDataWithCataLogId:(NSString*)catalogID andPriceOrder:(NSString*)priceOrder andSaleOrder:(NSString*)saleOrder successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;

- (void)getShopCartListDataSuccessBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
+ (void)addGoodsToShopCartWithProductId:(NSString*)product_id isAdd:(BOOL)flag andAmount:(NSString*)amount;
+ (void)cancelShopCartGoodsWithIDString:(NSString*)IDString successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail;

+ (void)commitOrderWithAddressID:(NSString*)addressID andShopCartID:(NSString*)shopCartID successBlock:(GetBackIDBlock)success failBlock:(GetFailBlock)fail;

@end
