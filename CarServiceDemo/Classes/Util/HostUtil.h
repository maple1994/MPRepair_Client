//
//  HostUtil.h
//  
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 com.. All rights reserved.
//

#import <Foundation/Foundation.h>


/// 传入子路径(子路径前面不要加“/”) 获取 绝对路劲
#define UrlCar(...)\
[NSString stringWithFormat:@"%@%@", [HostUtil getBaseUrl],\
[NSString stringWithFormat:__VA_ARGS__]]




typedef NS_ENUM(NSUInteger, WebViewLoadStatus) {
    webViewLoadStatusLoading =0,
    webViewLoadStatusError = 1,
    webViewLoadStatusSuccess = 2,
};


@interface HostUtil : NSObject

/// 配置域名的环境
+ (void)configureBuildType:(ConfigureBuildType)buildType;

/// 传入子路径(子路径前面不要加“/”) 获取 绝对路劲
+ (NSString*)getAbsoluteUrl:(NSString*)subUrl;

/// 获取主域名
+ (NSString*)getBaseUrl;


@end
