//
//  AddCarAddressView.h
//  CarServiceDemo
//
//  Created by superButton on 2018/9/10.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCarAddressView : UIView

@property (copy, nonatomic) void (^affirmBlock) (NSString *cityName,NSString *cityCode);

@end
