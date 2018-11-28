//
//  PayManager.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "PayModel.h"

@protocol PayManagerDelegate <NSObject>

@optional

@end

@interface PayManager : NSObject<WXApiDelegate>

/**
 代理
 */
@property (nonatomic, assign) id<PayManagerDelegate> delegate;

/**
 单例

 @return 单例
 */
+ (instancetype)sharedManager;

/**
 查询交易状态

 @param orderID 订单id
 @param success PayModel返回
 @param fail 失败返回
 */
- (void)getOrderDetailDataWithOrderID:(NSString*)orderID andPayType:(PayType)payType successBlock:(GetBackIDBlock)success failBlock:(GetBackBoolBlock)fail;

/**
 微信支付

 @param orderID 订单ID
 @param success 成功回调
 @param fail 失败回调
 */
- (void)payWithWeChatMethod:(NSString*)orderID andPayType:(PayType)payType successBlock:(GetBackBoolBlock)success failBlock:(GetBackBoolBlock)fail;

/**
 支付宝支付

 @param orderID 订单ID
 @param success 成功回调
 @param fail 失败回调
 */
- (void)payWithZhifubaoMethod:(NSString*)orderID andPayType:(PayType)payType successBlock:(GetBackBoolBlock)success failBlock:(GetBackBoolBlock)fail;

/**
 支付宝支付回调

 @param resultDict 回调字典参数
 */
- (void)handleOpenURL:(NSDictionary *)resultDict;

@end
