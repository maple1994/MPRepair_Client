//
//  MyTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableView : UITableView

@property (strong,nonatomic) NSMutableArray *dataArrM;

@property (copy, nonatomic) void (^settingBlock) (void);

@end
