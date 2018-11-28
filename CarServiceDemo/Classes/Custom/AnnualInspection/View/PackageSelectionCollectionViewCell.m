//
//  PackageSelectionCollectionViewCell.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/16.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "PackageSelectionCollectionViewCell.h"

@interface PackageSelectionCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation PackageSelectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLabel.layer.borderColor = [UIColor colorWithHexStringToRGB:@"A3A3A3"].CGColor;
    self.nameLabel.layer.borderWidth = 1.0;
}

- (void)setModel:(PackageSelectionComboitemSetModel *)model{
    
    if (model.isSelect) {
        self.nameLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.nameLabel.backgroundColor = [UIColor colorWithHexStringToRGB:@"3CADFF"];
        self.nameLabel.textColor = [UIColor whiteColor];
        
    }else{
        self.nameLabel.layer.borderColor = [UIColor colorWithHexStringToRGB:@"A3A3A3"].CGColor;
        self.nameLabel.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor colorWithHexStringToRGB:@"A3A3A3"];
        
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    
}

@end
