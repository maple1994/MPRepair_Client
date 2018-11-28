//
//  PayDetailTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAddressModel;

@interface PayDetailTableView : UITableView

@property (copy, nonatomic) NSString *addressID;
@property (strong,nonatomic) NSMutableArray *dataArrM;
@property (assign, nonatomic) NSInteger totalPrice;

@property (strong, nonatomic) MyAddressModel *addressModel;

@end
