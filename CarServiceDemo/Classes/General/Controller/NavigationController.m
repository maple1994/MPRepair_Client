
/**
 *  XFBNavigationController.m
 *  
 *  Created by yang on 16-8-30.
 *  自定义导航栏（继承UINavigationController类）
 *  Copyright © 2016年 . All rights reserved.
 */


#import "NavigationController.h"
#import "UIBarButtonItem+Extension.h"
#import "BackButtonHandlerProtocol.h"

@interface NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationController

+ (void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:[UIColor colorWithRed:60/255.0 green:173/255.0 blue:255/255.0 alpha:1]];
    [navBar setTranslucent:NO];
    NSMutableDictionary *textAttributes            = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttributes[NSFontAttributeName]            = [UIFont systemFontOfSize:18.0];
    [navBar setTitleTextAttributes:textAttributes];
    navBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) { 
        
        //返回按钮
        UIButton *navItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [navItem setImage:[UIImage imageNamed:@"icon_return-1"] forState:UIControlStateNormal];
        [navItem setImage:[UIImage imageNamed:@"icon_return-1"] forState:UIControlStateHighlighted];
        [navItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        navItem.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        navItem.frame = CGRectMake(0, 0, 50, 40);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navItem];
        self.interactivePopGestureRecognizer.enabled = YES;
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    
    if (self.gobackBlock) {
        self.gobackBlock();
    }else{
        UIViewController* controller = self.topViewController;
        if ([controller conformsToProtocol:@protocol(BackButtonHandlerProtocol)] && [controller respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
            
            BOOL canPopBack = [(id<BackButtonHandlerProtocol>)controller navigationShouldPopOnBackButton];
            if (canPopBack == NO) {
                return;
            }
            
        }
        
        [self popViewControllerAnimated:YES];
    }

}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
