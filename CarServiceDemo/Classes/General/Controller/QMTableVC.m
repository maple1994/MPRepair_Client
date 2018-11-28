//
//  WKTableVC.m
//  2.0
//
//  Created by mac on 16/5/10.
//  Copyright © 2016年 Ajin. All rights reserved.
//
/**
 *  说明：项目的主要基础tableview控制器，主要处理一下通用的功能，如返回导航栏等
 *
 *  Created
 */

#import "QMTableVC.h"

@interface QMTableVC ()

@end

@implementation QMTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.user = [UserInfo userInfo];
//    self.util = [NetWorkingUtil netWorkingUtil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //消失所有的提示框
//    for (id obj in self.view.subviews) {
//        if ([obj isKindOfClass:[MBProgressHUD class]]) {
//            [MBProgressHUD dismissHUDForView:self.view];
//        }
//    }
    
    [super viewWillDisappear:animated];
}
@end
