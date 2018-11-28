//
//  HomePageSearchCell.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "HomePageSearchCell.h"
@interface HomePageSearchCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end


@implementation HomePageSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RepairShopInfoModel *)model{
    
    _model = model;
    
    self.nameLabel.text = model.name;
    self.distanceLabel.text =[NSString stringWithFormat:@"距您%.01f公里", model.distance.floatValue];
    self.scoreLabel.text = model.popular;
    self.contactInfoLabel.text = [NSString stringWithFormat:@"联系人：%@ | %@",model.user_name,model.mobile_phone];
    self.addressLabel.text = model.address;
    [NetWorkingUtil setImage:self.iconImageView url:model.pic_url defaultIconName:KDefaultImage];
    
    for (int i = 0 ; i < 5; i++) {
        UIImageView *imageView = [self viewWithTag:100+i];
        if (i < model.score.integerValue) {
            
            imageView.hidden = NO;
            
        }else{
            
            imageView.hidden = YES;
        }
        
    }
    
}

@end
