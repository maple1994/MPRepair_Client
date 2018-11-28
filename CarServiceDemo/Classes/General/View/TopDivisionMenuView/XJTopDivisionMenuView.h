//
//  XJTopDivisionMenuView.h
//  SavingBarrel
//
//  Created by xj_love on 2018/1/3.
//  Copyright © 2018年 xj_love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJTopDivisionMenuView : UIView

@property (strong,nonatomic) UIColor *topLineColor;
@property (strong,nonatomic) UIColor *bottomLineColor;
@property (strong,nonatomic) UIColor *slideLineColor;
@property (strong,nonatomic) UIColor *selectColor;
@property (strong,nonatomic) UIColor *titleTextColor;
@property (strong,nonatomic) UIFont *titleFont;
@property (strong,nonatomic) NSMutableArray *titleArrM;//如若设置arr以上的参数🔼，arr最后传值

@property (copy,nonatomic) void (^topMenuSelectBlock)(NSInteger selectIndex);

/**
 *  移动下划线
 *  @param page 当前页码
 */
- (void)moveDetailHeadSlideLineViewWithPage:(NSInteger)page;

@end
