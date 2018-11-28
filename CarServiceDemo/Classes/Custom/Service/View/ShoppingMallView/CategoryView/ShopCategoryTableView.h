//
//  ShopCategoryTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCategoryTableView : UITableView

@property (assign, nonatomic) BOOL isLeft;
@property (strong,nonatomic) NSMutableArray *dataArrM;
@property (copy, nonatomic) void (^selectBlock) (NSString *categoryID);
@property (copy, nonatomic) void (^selectDetailBlock) (NSString *categoryID);

@end
