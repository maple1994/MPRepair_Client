//
//  NewsManager.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsManager : NSObject

- (void)getNewsCategoryDataSuccessBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
- (void)getNewsScrollViewDataSuccessBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;
- (void)getNewsDataWithCatalogID:(NSString*)catalogID successBlock:(GetBackArrayMBlock)success failBlock:(GetFailBlock)fail;

@end
