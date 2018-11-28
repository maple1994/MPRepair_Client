//
//  ImageObjectModel.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ImageObjectModel <NSObject>
@end

@interface ImageObjectModel : JSONModel

@property (copy, nonatomic) NSString *pic_url;
@property (copy, nonatomic) NSString *note;

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *price;

@end
