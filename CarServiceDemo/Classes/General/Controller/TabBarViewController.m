
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
#import "LoginVC.h"

///判断当前状态的Key,上线状态：1
extern BOOL kCurrentState;

@interface TabBarViewController ()<UITabBarControllerDelegate>
@end


@implementation TabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.delegate = self;
    [self addChildVc:[[HomePageVC alloc] init] title:@"首页" image:@"tab_Home" selectedImage:@"tab_Home_sl"];
    [self addChildVc:[[AnnualInspectionVC alloc] init] title:@"年检" image:@"tab_AnnualInspection" selectedImage:@"tab_AnnualInspection_sl"];
    [self addChildVc:[[ServiceVC alloc] init] title:@"服务" image:@"tab_service" selectedImage:@"tab_service_sl"];
    [self addChildVc:[[MyVC alloc] init] title:@"我的" image:@"tab_my" selectedImage:@"tab_my_sl"];
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UINavigationController *nav = (UINavigationController *)self.childViewControllers[i];
        [nav.tabBarItem setTitlePositionAdjustment: UIOffsetMake(0, -4)];
    }
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
    textAttrs[NSForegroundColorAttributeName]       = [UIColor colorwithHexString:@"#5B5B5B"];
    NSMutableDictionary *selectTextAttrs            = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorwithHexString:@"#3CADFF"];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *topVc = nav.topViewController;
    if ([topVc isKindOfClass:[MyVC class]] || [topVc isKindOfClass:[HomePageVC class]]) {
        [topVc.navigationController setNavigationBarHidden:YES animated:NO];
    }
    if ([topVc isKindOfClass: [MyVC class]] && ![UserInfo userInfo].isLogin) {
        LoginVC *vc = [[LoginVC alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:true completion:nil];
        return false;
    }
    return true;
}



@end
