//
//  AfterServiceDetailTableView.h
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AfterServiceDetailTableView : UITableView

@property (strong,nonatomic) AfterServiceModel *model;
@property (copy ,nonatomic) void (^dataChangeBlock) (void);

@end

NS_ASSUME_NONNULL_END
