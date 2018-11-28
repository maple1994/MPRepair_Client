//
//  ServiceManager.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ServiceManager.h"

@implementation ServiceManager

+ (void)getServiceHomePictureDataSuccessBlock:(GetBackDictionaryBlock)success failBlock:(GetFailBlock)fail{
    
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/system/serviceimg/" parameters:nil result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            success(obj);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

+ (void)getAboutOurUrlStrSuccessBlock:(GetBackStringBlock)success failBlock:(GetFailBlock)fail{
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/system/serviceimg/" parameters:nil result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            success(obj[@"url"]);
        }else{
            fail(nil);
        }
        
    }];
}

@end
