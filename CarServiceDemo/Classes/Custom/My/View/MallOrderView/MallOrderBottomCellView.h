//
//  MallOrderBottomCellView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MallOrderModel;

@interface MallOrderBottomCellView : UIView

@property (assign, nonatomic) MallOrderModel *nowModel;
@property (weak, nonatomic) IBOutlet UILabel *orderAllAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAllPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (copy, nonatomic) void (^menuChangeBlock) (void);

@end
