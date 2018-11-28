//
//  ShoppingMallCollectionCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShoppingMallCollectionCell.h"
#import "ShopingMallManager.h"

@implementation ShoppingMallCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth=1;
    self.layer.borderColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
}

- (IBAction)addGoodToShopCartAction:(id)sender {
    [ShopingMallManager addGoodsToShopCartWithProductId:self.product_id isAdd:YES andAmount:@"1"];
}

@end
