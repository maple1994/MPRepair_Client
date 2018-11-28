//
//  OrderMaintainTableView.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderMaintainTableView : UITableView

@property (strong,nonatomic) NSMutableArray *dataArrM;
@property (copy, nonatomic) NSString *filter_price;


@property (copy, nonatomic) void (^priceChangBlock) (NSString *selectPrice,NSString *oilID,NSString *oilAmount,NSString *oilNumber);

@end
