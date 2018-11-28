//
//  ServiceManager.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceManager : NSObject

+ (void)getServiceHomePictureDataSuccessBlock:(GetBackDictionaryBlock)success failBlock:(GetFailBlock)fail;
+ (void)getAboutOurUrlStrSuccessBlock:(GetBackStringBlock)success failBlock:(GetFailBlock)fail;

@end
