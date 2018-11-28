
//
//  NewsManager.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "NewsManager.h"
#import "NewsModel.h"
#import "CataLogModel.h"

@implementation NewsManager

- (void)getNewsCategoryDataSuccessBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/newscatalog/" parameters:nil result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                CataLogModel *model = [[CataLogModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

- (void)getNewsScrollViewDataSuccessBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/newsinfo/" parameters:nil result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                NewsModel *model = [[NewsModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

- (void)getNewsDataWithCatalogID:(NSString*)catalogID successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"news_catalog_id"] = catalogID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/service/news/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                NewsModel *model = [[NewsModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            success(resultArrM);
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            fail(nil);
        }
        
    }];
}

@end
