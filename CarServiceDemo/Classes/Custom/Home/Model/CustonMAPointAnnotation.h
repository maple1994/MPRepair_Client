//
//  CustonMAPointAnnotation.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustonMAPointAnnotation : MAPointAnnotation

@property (nonatomic ,copy)NSString *address;
@property (nonatomic ,copy)NSString *star;
@property (nonatomic ,copy)NSString *juli;
@property (nonatomic ,copy)NSString *mobi;
@property (nonatomic ,copy)NSString *ID;
/// 0 可维修，可保养， 1维修，2保养
@property (nonatomic, assign) NSInteger type;

@end
