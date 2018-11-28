
/**
 *  XFBTabBarViewController.m
 *  
 *  Created by yang on 16-8-30.
 *  自定义tabBar（继承UITabBarController类）
 *  Copyright © 2016年 . All rights reserved.
 */

#import "TabBarViewController.h"
#import "NavigationController.h"
#import "HomePageVC.h"
#import "AnnualInspectionVC.h"
#import "ServiceVC.h"
#import "MyVC.h"

///判断当前状态的Key,上线状态：1
extern BOOL kCurrentState;

@interface TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewController



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarDidSelectItemNoti" object:nil userInfo:@{@"TabBarDidSelectItemIndex":@(tabIndex)}];
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.rootViewControllerType == RootViewControllerTypeMain && tabIndex == 3) {
        [delegate switchRootViewControllerWithType:RootViewControllerTypeLogin];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    self.delegate = self;
    
    [self addChildVc:[[HomePageVC alloc] init] title:@"首页" image:@"tab_Home" selectedImage:@"tab_Home_sl"];
    
    [self addChildVc:[[AnnualInspectionVC alloc] init] title:@"年检" image:@"tab_AnnualInspection" selectedImage:@"tab_AnnualInspection_sl"];
    
    [self addChildVc:[[ServiceVC alloc] init] title:@"服务" image:@"tab_service" selectedImage:@"tab_service_sl"];
    
    [self addChildVc:[[MyVC alloc] init] title:@"我的" image:@"tab_my" selectedImage:@"tab_my_sl"];

}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
   
    childVc.title = title;
    
    childVc.tabBarItem.image         = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs                  = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName]       = [UIColor blackColor];
    NSMutableDictionary *selectTextAttrs            = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = COLOR_RGB(54, 155, 242);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}



@end
