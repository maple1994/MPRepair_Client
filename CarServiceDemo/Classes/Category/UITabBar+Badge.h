//
//  UITabBar+Badge.h
//  
//
//  Created by  on 17/3/24.
//  Copyright © 2017年 com.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index badgeNum:(NSString *)num;

- (void)showBadgeOnItemIndex:(int)index; //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end