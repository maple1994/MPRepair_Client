//
//  NoDataCollectionViewCell.m
//  
//
//  Created by yang on 2017/9/6.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "NoDataCollectionViewCell.h"


@interface NoDataCollectionViewCell()



@property (weak, nonatomic) IBOutlet UIImageView *contentImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;



@end

@implementation NoDataCollectionViewCell



- (void)setImageStr:(NSString *)imageStr {
    
    _contentImageV.image = [UIImage imageNamed:imageStr];
}


- (void)setTitleStr:(NSString *)titleStr {
    
    _titleL.text = titleStr;
}

- (void)setHiddenTitleLable:(BOOL)hiddenTitleLable{
    _titleL.hidden = hiddenTitleLable;
}
@end
