//
//  XJLocationPickerView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/14.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedLocation)(NSArray *locationArray,NSString*addressString);

@interface XJLocationPickerView : UIView

@property (copy, nonatomic)SelectedLocation selectedLocation;

//初始化回传
- (instancetype)initWithSlectedLocation:(SelectedLocation)selectedLocation;
//显示
- (void)show;


@end
