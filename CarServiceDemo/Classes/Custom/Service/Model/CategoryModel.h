//
//  CategoryModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryModel : JSONModel

@property (copy, nonatomic) NSString *titleString;
@property (assign, nonatomic) BOOL hadSelected;

@end
