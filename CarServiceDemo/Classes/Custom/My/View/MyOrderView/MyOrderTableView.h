//
//  MyOrderTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableView : UITableView

@property (strong,nonatomic) NSMutableArray *dataArrM;

@property (copy, nonatomic) void (^tableChangeBlock) (void);

@end
