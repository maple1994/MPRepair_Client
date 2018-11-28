//
//  CarAddressModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/11.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CarAddressChildModel : JSONModel

@property (assign, nonatomic) BOOL hadSelect;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *city_name;
@property (copy, nonatomic) NSString *city_code;

@end

@protocol CarAddressChildModel <NSObject>
@end

@interface CarAddressModel : JSONModel

@property (assign, nonatomic) BOOL hadSelect;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *province;
@property (strong, nonatomic) NSMutableArray<CarAddressChildModel> *carcity_set;

@end

