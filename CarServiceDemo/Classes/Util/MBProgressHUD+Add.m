////
////  MBProgressHUD+Add.m
////  视频客户端
////
////  Created by mj on 13-4-18.
////  Copyright (c) 2013年 itcast. All rights reserved.
////
//
//#import "MBProgressHUD+Add.h"
//
//#define KDuration 1.5 //提示时间
//#define kOpacity   0.65 //透明度
//#define KFontSize   15 //显示字体大小
//#define KCornerRadius   10 //圆角
//#define KBGColor   15 //显示背景颜色
//
//static NSMutableDictionary *HUDCount = nil;
//
//@implementation MBProgressHUD (Add)
//
//#pragma mark 显示信息
//+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
//{
//    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
//    // 再设置模式
//    hud.mode = MBProgressHUDModeCustomView;
//    // 隐藏时候从父控件中移除
//    hud.removeFromSuperViewOnHide = YES;
//    
//    ///样式设置
//    hud.label.text = text;
//    hud.label.font = [UIFont systemFontOfSize:KFontSize];
//    hud.label.numberOfLines = 0;
//    hud.label.textColor = [UIColor whiteColor];
//    hud.bezelView.layer.cornerRadius = KCornerRadius;
//    hud.bezelView.layer.masksToBounds = YES;
//    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:kOpacity];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//
//    // 1.5秒之后再消失
//    [hud hideAnimated:YES afterDelay:KDuration];
//}
//
//#pragma mark 显示错误信息
//+ (void)showErrorOnView:(UIView *)view withMessage:(NSString *)message {
//    [self show:message icon:@"error.png" view:view];
//}
//
//+ (void)showSuccessOnView:(UIView *)view withMessage:(NSString *)message {
//    [self show:message icon:@"success.png" view:view];
//}
//
//
//+ (NSString*)HUDCountKeyForView:(UIView*)view {
//    
//    NSString *key;
//    if ([view isKindOfClass:[UIWindow class]]) {
//        
//        NSObject *obj = [view valueForKeyPath:@"delegate"];
//        key = [NSString stringWithFormat:@"%p", obj];
//    }else {
//    
//        NSObject *obj = [view valueForKeyPath:@"viewDelegate"];
//        key = [NSString stringWithFormat:@"%p", obj];
//    }
//    
//    return key;
//    
//}
//
//static dispatch_once_t onceToken;
//+ (MB_INSTANCETYPE)showStatusOnView:(UIView *)view withMessage:(NSString *)message {
//    
//    dispatch_once(&onceToken, ^{
//        HUDCount = [NSMutableDictionary dictionary];
//    });
//    
//    NSString *key = [self HUDCountKeyForView:view];
//    NSNumber *count = [HUDCount objectForKey:key];
//    if (count) {
//        [HUDCount removeObjectForKey:key];
//        HUDCount[key] = [NSNumber numberWithInteger:count.integerValue+1];
//        
//        return nil;
//    }else {
//        HUDCount[key] = [NSNumber numberWithInteger:1];
//    }
//    
//    MBProgressHUD *hud = [[self alloc] initWithView:view];
//    hud.removeFromSuperViewOnHide = YES;
//    
//    ///样式设置
//    hud.label.text = message;
//    hud.label.font = [UIFont systemFontOfSize:KFontSize];
//    hud.label.numberOfLines = 0;
//    hud.label.textColor = [UIColor whiteColor];
//    hud.bezelView.layer.cornerRadius = KCornerRadius;
//    hud.bezelView.layer.masksToBounds = YES;
//    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:kOpacity];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//    
//    [view addSubview:hud];
//    [hud showAnimated:YES];
//    return hud;
//}
//
//
//+ (BOOL)dismissHUDForView:(UIView *)view {
//    
//    NSString *key = [self HUDCountKeyForView:view];
//    NSNumber *count = [HUDCount objectForKey:key];
//    [HUDCount removeObjectForKey:key];
//    if (count) {
//        
//        NSInteger num = count.integerValue;
//        if (num-1<=0) {
//            
//            MBProgressHUD *hud = [self HUDForView:view];
//            if (hud != nil) {
//                hud.removeFromSuperViewOnHide = YES;
//                [hud hideAnimated:YES];
//                return YES;
//            }
//        }else {
//            
//            HUDCount[key] = [NSNumber numberWithInteger:num-1];
//            
//        }
//        
//    }
//    
//    return NO;
//}
//
//+ (BOOL)dismissHUDForView:(UIView *)view withError:(NSString *)error {
//    
//    NSString *key = [self HUDCountKeyForView:view];
//    NSNumber *count = [HUDCount objectForKey:key];
//    [HUDCount removeObjectForKey:key];
//    if (count) {
//        
//        NSInteger num = count.integerValue;
//        if (num-1<=0) {
//            
//            MBProgressHUD *hud = [self HUDForView:view];
//            if (hud != nil) {
//                // 设置图片
//                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"error.png"]]];
//                // 再设置模式
//                hud.mode = MBProgressHUDModeCustomView;
//                // 隐藏时候从父控件中移除
//                hud.removeFromSuperViewOnHide = YES;
//                
//                ///样式设置
//                hud.label.text = error;
//                hud.label.font = [UIFont systemFontOfSize:KFontSize];
//                hud.label.numberOfLines = 0;
//                hud.label.textColor = [UIColor whiteColor];
//                hud.bezelView.layer.cornerRadius = KCornerRadius;
//                hud.bezelView.layer.masksToBounds = YES;
//                hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:kOpacity];
//                hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//                [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//                
//                // 1.0秒之后再消失
//                [hud hideAnimated:YES afterDelay:KDuration];
//                return YES;
//            }
//            
//        }else {
//            
//            HUDCount[key] = [NSNumber numberWithInteger:num-1];
//            
//        }
//        
//    }
//    
//    return NO;
//}
//
//+ (BOOL)dismissHUDForView:(UIView *)view withsuccess:(NSString *)success {
//    
//    NSString *key = [self HUDCountKeyForView:view];
//    NSNumber *count = [HUDCount objectForKey:key];
//    [HUDCount removeObjectForKey:key];
//    if (count) {
//        
//        NSInteger num = count.integerValue;
//        if (num-1<=0) {
//            
//            MBProgressHUD *hud = [self HUDForView:view];
//            if (hud != nil) {
//                // 设置图片
//                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"success.png"]]];
//                // 再设置模式
//                hud.mode = MBProgressHUDModeCustomView;
//                // 隐藏时候从父控件中移除
//                hud.removeFromSuperViewOnHide = YES;
//                
//                ///样式设置
//                hud.label.text = success;
//                hud.label.font = [UIFont systemFontOfSize:KFontSize];
//                hud.label.numberOfLines = 0;
//                hud.label.textColor = [UIColor whiteColor];
//                hud.bezelView.layer.cornerRadius = KCornerRadius;
//                hud.bezelView.layer.masksToBounds = YES;
//                hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:kOpacity];
//                hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//                [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
//                
//                // 1.0秒之后再消失
//                [hud hideAnimated:YES afterDelay:KDuration];
//                return YES;
//            }
//            
//        }else {
//            
//            HUDCount[key] = [NSNumber numberWithInteger:num-1];
//            
//        }
//        
//    }
//
//    return NO;
//}
//
//#pragma mark 显示一些信息
//+ (void)showMessagOnView:(UIView *)view withMessage:(NSString *)message {
//    [self show:message icon:nil view:view];
//}
//
//@end
