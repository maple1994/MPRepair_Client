//
//  ShopCartTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartTableView : UITableView

@property (strong,nonatomic) NSMutableArray *dataArrM;

@property (copy, nonatomic) void (^priceChangeBlock) (CGFloat price,BOOL isAll);

- (void)changeShopSelectState:(BOOL)state;
- (void)cancelShopAction;
- (NSMutableArray*)commitOrderAction;

@end
