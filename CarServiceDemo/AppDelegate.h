//
//  AppDelegate.h
//  CarServiceDemo
//
//  Created by  on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "NavigationController.h"

typedef void(^RootVCCompletionBlock)(void);

//RootViewControllerType
typedef NS_ENUM(NSInteger,RootViewControllerType){
    RootViewControllerTypeMain,
    RootViewControllerTypeLogin,
    RootViewControllerTypeTabBar,
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) TabBarViewController *tabBarVC;
@property(nonatomic,strong)NavigationController *mainNavC;
@property(nonatomic,strong)NSDictionary *userInfo;
/**
 *  切换根控制器
 */
- (void)switchRootViewControllerWithType:(RootViewControllerType)rootViewControllerType;

- (void)switchRootViewControllerWithType:(RootViewControllerType)rootViewControllerType completed:(RootVCCompletionBlock)completedBlock;
// 处理推送跳转
- (void)dealRemoteNotificationPush;

///
@property (nonatomic ,assign,readonly)RootViewControllerType rootViewControllerType;

@end

