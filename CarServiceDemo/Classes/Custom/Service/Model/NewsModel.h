//
//  NewsModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/9.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CataLogModel.h"

@protocol CataLogModel <NSObject>
@end

@interface NewsModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *pic_url;
@property (copy, nonatomic) NSString *detail_url;
@property (strong, nonatomic) CataLogModel *catalog;
@property (copy, nonatomic) NSArray *pic_url_list;

@end
