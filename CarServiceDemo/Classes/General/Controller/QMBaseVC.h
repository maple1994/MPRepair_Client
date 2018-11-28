//
//  WKBaseVC.h
//  2.0
//
//  Created by mac on 16/5/4.
//  Copyright © 2016年 Ajin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "BackButtonHandlerProtocol.h"

//导航条返回按钮的标题
#define NavigationBackTitle  @"返回"

@interface QMBaseVC : UIViewController <BackButtonHandlerProtocol>

///用户信息
@property (nonatomic, strong) UserInfo *user;

///网络工具
@property (nonatomic, strong) NetWorkingUtil *util;
/// 是否横屏
@property (nonatomic, assign) BOOL isLandscapeRight;

///
@property (nonatomic ,strong)AppDelegate *appDelegate;
@end
