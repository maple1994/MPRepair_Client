//
//  QMNoDataTableViewCell.m
//  
//  无数据状态的规则显示空盒子图标+文字提醒
//  Created by yang on 17/2/21.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "QMNoDataTableViewCell.h"

@interface QMNoDataTableViewCell()

/// 无数据文字描述Label
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;


@end

@implementation QMNoDataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[NSBundle mainBundle] loadNibNamed:@"QMNoDataTableViewCell" owner:self options:nil][0];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDescStr:(NSString *)descStr {
    
    _descStr = descStr;
    self.descLabel.text = descStr;
}
- (void)setImageName:(NSString *)imageName {
    
    _imageName = imageName;
    self.imageV.image = [UIImage imageNamed:imageName];
}

- (void)setDescStrColor:(NSString *)descStrColor {
    
    _descStrColor = descStrColor;
    _descLabel.textColor = [UIColor colorWithHexStringToRGB:descStrColor];
}

@end
