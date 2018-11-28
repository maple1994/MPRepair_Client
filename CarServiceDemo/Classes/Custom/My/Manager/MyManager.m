//
//  MyManager.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyManager.h"
#import "MyMenuModel.h"
#import "CarModel.h"
#import "OilModel.h"

@implementation MyManager

#pragma mark -获取个人中心菜单数据
- (NSMutableArray*)getMyMenuData{
    NSMutableArray *returnArrM = [NSMutableArray array];
    for (int i=1; i<=6; i++) {
        MyMenuModel *model = [[MyMenuModel alloc] init];
        model.imageUrl = [NSString stringWithFormat:@"mySonMenu%d",i];
        if (i==1) {
            model.title = @"我的车库";
        }else if (i==2){
            model.title = @"年检记录";
        }
        else if (i==3){
            model.title = @"商城订单";
        }
        else if (i==4){
            model.title = @"收货地址";
        }
        else if (i==5){
            model.title = @"售后服务";
        }else if (i==6){
            model.title = @"客服";
        }
        [returnArrM addObject:model];
        if (![UserInfo userInfo].is_pass) {
            if (i == 3 || i == 4) {
                [returnArrM removeObject:model];
            }
        }
        
        
    }
    return returnArrM;
}

+ (void)modificationUserMessageWithImage:(UIImage*)userImage anduserName:(NSString*)userName andPhone:(NSString*)phone successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSData *data = [UIImage imageWithImage:userImage limitCompactionImageLength:200];
    //使用0或以下来控制线结束后的最大线长度。默认情况下没有插入任何行的结尾
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = userName;
    params[@"phone"] = phone;
    params[@"id"] = [NSString stringWithFormat:@"%ld", [UserInfo userInfo].uid];
    params[@"pic"] = encodedImageStr;
    
    //    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/user/user/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"修改成功"];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getCarportListDataIsDefault:(BOOL)isDefault successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isDefault) {
        params[@"is_default"] = @(isDefault);
    }
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/car/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                CarModel *model = [[CarModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)addCarMessageWithParams:(NSMutableDictionary*)params successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/user/car/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"添加成功"];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)cancelCarWithCarID:(NSString*)carID successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = carID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/car_delete/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"删除成功"];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getMaintainOilListDataWithID:(NSString*)ID  successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"garage_id"] = ID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/maintain/oil/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                OilModel *model = [[OilModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)affirmPayMaintainOrderWithParams:(NSMutableDictionary*)params isUpKeep:(BOOL)isUpkeep successBlock:(GetBackStringBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSString *urlStr = @"";
    if (isUpkeep) {
        urlStr = @"/api/maintain/upkeep/";
    }else{
        urlStr = @"/api/maintain/maintain/";
    }
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:urlStr parameters:params result:^(id obj, int status, NSString *msg) {
        
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
