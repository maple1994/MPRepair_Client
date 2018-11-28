//
//  AfterServiceModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/10/26.
//  Copyright © 2018 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ImageObjectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AfterServiceModel : JSONModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSString *car_code;
@property (copy, nonatomic) NSString *car_type;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *create_time;
@property (copy, nonatomic) NSString *state;

@property (strong, nonatomic) NSArray<ImageObjectModel> *pic_list;

@end

NS_ASSUME_NONNULL_END
