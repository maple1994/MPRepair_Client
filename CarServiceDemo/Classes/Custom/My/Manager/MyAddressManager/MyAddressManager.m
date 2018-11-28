//
//  MyAddressManager.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyAddressManager.h"
#import "MyAddressModel.h"

@implementation MyAddressManager

+ (void)getMyAddressListDataIsDefault:(BOOL)isDefault successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (isDefault) {
     params[@"is_default"] = @(isDefault);
    }
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/address/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                MyAddressModel *model = [[MyAddressModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

- (void)addMyAddressWithModel:(MyAddressModel*)model successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = model.name;
    params[@"phone"] = model.phone;
    params[@"node1"] = model.node1.ID;
    params[@"node2"] = model.node2.ID;
    params[@"node3"] = model.node3.ID;
    params[@"address"] = model.address;
    params[@"is_default"] = @(model.is_default);
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/user/address/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"添加成功"];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

- (void)editeMyAddressWithModel:(MyAddressModel*)model successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = model.ID;
    params[@"name"] = model.name;
    params[@"phone"] = model.phone;
    params[@"node1"] = model.node1.ID;
    params[@"node2"] = model.node2.ID;
    params[@"node3"] = model.node3.ID;
    params[@"address"] = model.address;
    params[@"is_default"] = @(model.is_default);
    
    [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/user/address/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"修改成功"];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

- (void)cancenlMyAddressWithID:(NSString*)ID successBlock:(GetBackBoolBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = ID;
    
    //    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/address_delete/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"删除成功"];
            success(YES);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

@end
