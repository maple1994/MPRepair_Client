//
//  MyOrderMainteDetailTableCell.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyMaintainModel;

@interface MyOrderMainteDetailTableCell : UITableViewCell

@property (strong,nonatomic) MyMaintainModel *maintainModel;
@property (copy, nonatomic) void (^orderChangeBlock) (BOOL isDelete);

@end
