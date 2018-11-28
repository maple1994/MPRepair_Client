//
//  AnnualInspectionFeedbackDetailsCell.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionFeedbackDetailsCell.h"

@interface AnnualInspectionFeedbackDetailsCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
///
@property (nonatomic ,strong)UIView *bgview;
@end

@implementation AnnualInspectionFeedbackDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(obj_list *)model{
    
    [NetWorkingUtil setImage:self.iconImageView url:model.pic_url defaultIconName:KDefaultImage];
    self.titleNameLabel.text = model.note;
    [NetWorkingUtil setImage:self.iconImageView url:model.pic_url defaultIconName:KDefaultImage];
    
    

}

- (IBAction)imageBtnClick:(id)sender {
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgview.backgroundColor = [UIColor clearColor];
 
    
    UIView *blackBGview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackBGview.backgroundColor = [UIColor blackColor];
    blackBGview.alpha = .3;
    [bgview addSubview:blackBGview];
    
    UIImageView *imageV1 = [[UIImageView alloc]initWithImage:self.iconImageView.image];
    imageV1.frame = CGRectMake(0, (SafeAreaHeight/2)-150, SCREEN_WIDTH, 300);
    [bgview addSubview:imageV1];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [btn addTarget:self action:@selector(imageV1ClickWithImageView)forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    [bgview addSubview:btn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgview];
    self.bgview = bgview;
}


- (void)imageV1ClickWithImageView   {
    
//    UIImageView *imageView = (UIImageView *)tapGestureRecognizer.view;
    
    [self.bgview removeFromSuperview];
}

@end
