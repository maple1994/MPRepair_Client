//
//  ShopCategoryView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCategoryView : UIView

@property (copy, nonatomic) void (^categorySelectBlock) (NSString *cateforyID);

@end
