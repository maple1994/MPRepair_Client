//
//  CataLogModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CataLogModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *p_id;
@property (copy, nonatomic) NSString *type;
@property (assign, nonatomic) BOOL hadSelect;

@end
