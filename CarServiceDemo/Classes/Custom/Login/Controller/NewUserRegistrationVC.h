//
//  NewUserRegistrationVC.h
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"

@interface NewUserRegistrationVC : QMBaseVC
/// 是否注册
@property (nonatomic, assign)BOOL isRegistration;
/// 注册完的回调
@property (nonatomic, copy) void (^confirmBlock)(NSString *phone, NSString *pwd);
@end
