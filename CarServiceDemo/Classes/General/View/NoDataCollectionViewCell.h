//
//  NoDataCollectionViewCell.h
//  
//
//  Created by yang on 2017/9/6.
//  Copyright © 2017年 com.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataCollectionViewCell : UICollectionViewCell

@property (copy, nonatomic)  NSString *imageStr;
@property (copy, nonatomic)  NSString *titleStr;

/**
 * 是否隐藏文案
 */
@property (nonatomic ,assign)BOOL hiddenTitleLable;

@end
