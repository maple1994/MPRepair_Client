//
//  CarBrandModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/28.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarBrandModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *year;

@end
