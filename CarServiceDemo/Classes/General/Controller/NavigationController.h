
/**
 *  XFBNavigationController.h
 *  
 *  Created by yang on 16-8-30.
 *  自定义导航栏（继承UINavigationController类）
 *  Copyright © 2016年 . All rights reserved.
 */


#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController

@property (copy,nonatomic) void (^gobackBlock) (void);

@end
