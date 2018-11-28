//
//  OrderEvaluateView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderEvaluateView : UIView

@property (copy, nonatomic) void (^affirmBlock) (NSString *star);
@property (copy ,nonatomic) void (^cancelBlock) (void);

@end
