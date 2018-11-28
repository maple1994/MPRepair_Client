//
//  ShoppingMallCollectionCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingMallCollectionCell : UICollectionViewCell

@property (copy, nonatomic) NSString *product_id;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopPriceLabel;

@end
