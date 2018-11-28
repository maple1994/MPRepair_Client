//
//  WKBaseVC.m
//  2.0
//
//  Created by mac on 16/5/4.
//  Copyright © 2016年 Ajin. All rights reserved.
//
/**
 *  说明：项目的主要基础控制器，主要处理一下通用的功能，如返回导航栏等
 *
 *  Created 
 */


#import "QMBaseVC.h"
#import "AppDelegate.h"


@interface QMBaseVC ()

@end

@implementation QMBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [UserInfo userInfo];
    self.util = [NetWorkingUtil netWorkingUtil];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (@available(iOS 11.0, *)) {//防止Y轴偏移64像素
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:60/255.0 green:173/255.0 blue:255/255.0 alpha:1]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //消失所有的提示框
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [MBProgressHUD dismissHUDForView:self.view];
        }
    }
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - 设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
