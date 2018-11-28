//
//  PayManager.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "PayManager.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PayManager ()

@property (copy,nonatomic) GetBackBoolBlock successBlock;
@property (copy,nonatomic) GetBackBoolBlock failBlock;

@end

@implementation PayManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PayManager alloc] init];
    });
    return instance;
}

#pragma mark - 查询交易状态
- (void)getOrderDetailDataWithOrderID:(NSString*)orderID andPayType:(PayType)payType successBlock:(GetBackIDBlock)success failBlock:(GetBackBoolBlock)fail{
    
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = orderID;
    params[@"method"] = @"order_status";
    
    NSString *urlStr = @"";
    if (payType == PayTypeMallOrder) {
        urlStr = @"/api/service/order_method/";
    }else if (payType == PayTypeUpKeepOrder){
        urlStr = @"/api/maintain/upkeep_method/";
    }else if (payType == PayTypeMaintainOrder){
        urlStr = @"/api/maintain/maintain_method/";
    }else if (payType == PayTypeSelfSurvey){
        urlStr = @"/api/survey/survey_selfmethod/";
    }else if (payType == PayTypeReplaceSurvey){
        urlStr = @"/api/survey/survey_behalfmethod/";
    }

    [[NetWorkingUtil netWorkingUtil] postDataWithPath:urlStr parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            PayModel *model = [[PayModel alloc] initWithDictionary:obj error:nil];
            success(model);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(NO);
        }
        
    }];
}

#pragma mark - 微信支付
- (void)payWithWeChatMethod:(NSString*)orderID andPayType:(PayType)payType successBlock:(GetBackBoolBlock)success failBlock:(GetBackBoolBlock)fail{
    
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = orderID;
    params[@"method"] = @"pay";
    params[@"order_method"] = @"weixin";
    
    NSString *urlStr = @"";
    if (payType == PayTypeMallOrder) {
        urlStr = @"/api/service/order_method/";
    }else if (payType == PayTypeUpKeepOrder){
        urlStr = @"/api/maintain/upkeep_method/";
    }else if (payType == PayTypeMaintainOrder){
        urlStr = @"/api/maintain/maintain_method/";
    }else if (payType == PayTypeSelfSurvey){
        urlStr = @"/api/survey/survey_selfmethod/";
    }else if (payType == PayTypeReplaceSurvey){
        urlStr = @"/api/survey/survey_behalfmethod/";
    }
    
    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:urlStr parameters:params result:^(id obj, int status, NSString *msg) {
        
        [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
        if (status == 1) {
            
            NSData *jsonData = [obj[@"params"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            
            weakSelf.successBlock = success;
            weakSelf.failBlock = fail;
            
            if(obj != nil){
                NSMutableString *retcode = [dic objectForKey:@"retcode"];
                if (retcode.intValue == 0){
                    NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = kWeXinKeyID;
                    req.partnerId           = [dic objectForKey:@"partnerid"];
                    req.prepayId            = [dic objectForKey:@"prepayid"];
                    req.nonceStr            = [dic objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dic objectForKey:@"package"];
                    req.sign                = [dic objectForKey:@"sign"];
                    
                    if (![WXApi sendReq:req]) {
                        //微信调起支付失败
                        if (weakSelf.failBlock) {
                            
                            weakSelf.failBlock(NO);
                        }
                    }
                    //日志输出
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                }
            }else{
                fail(NO);
            }
        }else{
            fail(NO);
        }
        
    }];
}

#pragma mark - 支付宝支付
- (void)payWithZhifubaoMethod:(NSString*)orderID andPayType:(PayType)payType successBlock:(GetBackBoolBlock)success failBlock:(GetBackBoolBlock)fail{
    
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = orderID;
    params[@"method"] = @"pay";
    params[@"order_method"] = @"alipay";
    
    NSString *urlStr = @"";
    if (payType == PayTypeMallOrder) {
        urlStr = @"/api/service/order_method/";
    }else if (payType == PayTypeUpKeepOrder){
        urlStr = @"/api/maintain/upkeep_method/";
    }else if (payType == PayTypeMaintainOrder){
        urlStr = @"/api/maintain/maintain_method/";
    }else if (payType == PayTypeSelfSurvey){
        urlStr = @"/api/survey/survey_selfmethod/";
    }else if (payType == PayTypeReplaceSurvey){
        urlStr = @"/api/survey/survey_behalfmethod/";
    }
    
    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:urlStr parameters:params result:^(id obj, int status, NSString *msg) {
        
        [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
        
        if (status == 1) {
            
            weakSelf.successBlock = success;
            weakSelf.failBlock = fail;
            
            if(obj != nil){
                
                NSString *appScheme = @"CarServiceDemo";
                
                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *sdkParam = obj[@"params"];
                NSString *orderString = [NSString stringWithFormat:@"%@",sdkParam];
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"payOrder reslut = %@",resultDic);
                    //h5走这个回调
                    [weakSelf handleOpenURL:resultDic];
                }];
                
            }else{
                fail(NO);
            }
        }else{
            fail(NO);
        }
    }];
}

#pragma mark - WXApiDelegate
//收到微信回调
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                if (_successBlock) {
                    _successBlock(YES);
                }
            }
                break;
                
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                if (_failBlock) {
                    _failBlock(NO);
                }
            }
                break;
        }
    }else {
    }
}

///给微信发回调
- (void)onReq:(BaseReq *)req {
    
}

#pragma mark = 支付宝客户端支付后回调
- (void)handleOpenURL:(NSDictionary *)resultDict {
    
    NSString *resultStatus = [NSString stringWithFormat:@"%@", [resultDict objectForKey:@"resultStatus"]];
    NSInteger statusCode = [resultStatus integerValue];
    
    switch (statusCode) {
        case 9000://成功
        {
            
            if (_successBlock) {
                _successBlock(YES);
            }
        }
            break;
        case 4000://失败
        {
            
            if (_failBlock) {
                _failBlock(NO);
            }
        }
            break;
        default://其它
        {
            
            if (_failBlock) {
                _failBlock(NO);
            }
        }
            break;
    }
}

@end
