//
//  NetWorkingUtil.h
//  Agencies
//
//  Created by mac on 16/1/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

#define NetWorkErrorMsg @"网络异常，请稍后再试！"

typedef void(^NetWorkStateChangeBlcok)(AFNetworkReachabilityStatus status);

@class InfoMsg;
@interface NetWorkingUtil : NSObject

+ (void)reach;

+ (NetWorkingUtil *)netWorkingUtil;

/**
 //检测当前网络
 AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
 AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
 */
+ (AFNetworkReachabilityStatus)netWorkState;

//是否有网络 YES，有，NO,没有
+ (BOOL)netWorkWhetherConnect;


/**
 * 网络状态改变BLCOK
 */
@property (nonatomic ,copy)NetWorkStateChangeBlcok netWorkStateChangeBlcok;


/**
 get请求一个Dictionary 或 array
 */
- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result;

/**
 post请求一个Dictionary 或 array
 */
- (void)postDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg))result;
/**
 *  上传文件到服务器（带有上传进度和进度条展示）
 *
 *  @param urlString  url
 *  @param parameters 参数
 *  @param imageData  
 *  @param view       进度条所展示的view
 *  @param result     回调block
 */
-(void)postImageToServerWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters view:(UIView *)view result:(void (^)(id obj,int  status,NSString *msg))result;
/**
 *  上传文件到服务器（不带有上传进度和进度条展示）
 *
 *  @param urlString  url
 *  @param parameters 参数
 *  @param imageData
 *  @param view       进度条所展示的view
 *  @param result     回调block
 */
-(void)postImageToServerNoProgressWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters view:(UIView *)view result:(void (^)(id obj,int  status,NSString *msg))result;

/**
 描述：加载网络图片资源
 imageView：需要加载的图片view
 imageUrl : 图片地址
 */
+ (void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl defaultIconName:(NSString*)defaultIconName;

+(void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl defaultIconName:(NSString*)defaultIconName completed:(SDExternalCompletionBlock)webImageCompletionBlock;//SDWebImageCompletionBlock


/**
 根据绝对路径 get请求一个Dictionary 或 array
 */
- (void)getDataWithAbsolutePath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result;

/**
 根据绝对路径 post请求一个Dictionary 或 array
 */
- (void)postDataWithAbsolutePath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg))result;


///给webview的url添加一个版本号
+ (NSString*)webViewUrlAppendVersion:(NSString*)url;

- (void)refreshToken;

@end

