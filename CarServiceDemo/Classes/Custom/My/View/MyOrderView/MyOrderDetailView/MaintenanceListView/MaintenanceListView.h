//
//  MaintenanceListView.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintenanceListView : UIView

@property (copy,nonatomic) NSString *orderID;
@property (assign,nonatomic) BOOL isChange;
@property (strong,nonatomic) NSMutableArray *dataArr;

@property (copy,nonatomic) void (^projectChangeBlock) (void);

@end
