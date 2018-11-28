//
//  MyMenuModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MyMenuModel : JSONModel

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *imageUrl;

@end
