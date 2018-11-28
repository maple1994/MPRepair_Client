//
//  UITabBar+Badge.m
//  
//
//  Created by  on 17/3/24.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "UITabBar+Badge.h"

#define TabbarItemNums 5.0

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index badgeNum:(NSString *)num
{
    //移除之前的红点数字
    [self removeBadgeOnItemIndex:index];
    
    //新建红点数字
    UILabel *badgeLabel = [[UILabel alloc]init];
    badgeLabel.tag = 888 + index;
    badgeLabel.layer.cornerRadius = 10;
    badgeLabel.clipsToBounds = YES;
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.text = num;
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = [UIFont systemFontOfSize:10];
    CGRect tabFrame = self.frame;
    
    //确定红点数字的位置
    float percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeLabel.frame = CGRectMake(x, y, 20, 20);
    [self addSubview:badgeLabel];
    
}

- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}

@end
