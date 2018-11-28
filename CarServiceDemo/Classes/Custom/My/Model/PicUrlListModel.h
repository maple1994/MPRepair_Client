//
//  PicUrlListModel.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/13.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PicUrlListModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *update_time;
@property (copy, nonatomic) NSString *pic_url;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *state;

@end
