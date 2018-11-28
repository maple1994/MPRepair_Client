//
//  MyCarportTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarModel;

@interface MyCarportTableView : UITableView

@property (strong,nonatomic) NSMutableArray *dataArrM;

@property (assign, nonatomic) BOOL isSelect;
@property (copy, nonatomic) void ( ^changCarBlock) (void);
@property (copy, nonatomic) void (^selectCarBlock) (CarModel *selectModel);

@end
