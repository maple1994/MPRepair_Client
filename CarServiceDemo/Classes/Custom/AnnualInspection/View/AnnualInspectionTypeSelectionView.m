//
//  AnnualInspectionTypeSelectionView.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/18.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionTypeSelectionView.h"

@interface  AnnualInspectionTypeSelectionView()

@property (weak, nonatomic) IBOutlet UIView *myContentView;

///
@property (nonatomic ,copy)AnnualInspectionTypeSelectionViewHanleBlock block;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@end

@implementation AnnualInspectionTypeSelectionView


+ (instancetype)annualInspectionTypeSelectionViewHandle:(AnnualInspectionTypeSelectionViewHanleBlock)handle{
    AnnualInspectionTypeSelectionView *view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class ]) owner:nil options:nil]firstObject];
    [view annualInspectionTypeSelectionView];
    view.block = handle;
    return view;
}


- (void)annualInspectionTypeSelectionView{
    [self.myContentView setCornerRadius:8];
    [self.btn1 setCornerRadius:8];
    [self.btn2 setCornerRadius:8];
    self.btn1.layer.borderColor = [UIColor colorwithHexString:@"36ACE5"].CGColor;
    self.btn2.layer.borderColor = [UIColor colorwithHexString:@"36ACE5"].CGColor;
    self.btn1.layer.borderWidth = 1;
    self.btn2.layer.borderWidth = 1;
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.bgView addSubview:effectView];
//    [self typeSelectBtnsAction:self.btn1];
}

- (IBAction)typeSelectBtnsAction:(UIButton *)sender {
    if (sender == self.btn1) {
        self.btn1.selected = YES;
        [self.btn1 setBackgroundColor:[UIColor colorWithHexStringToRGB:@"3CADFF"]];
        self.btn1.layer.borderWidth = 0;

        self.btn2.selected = NO;
        self.btn2.backgroundColor = [UIColor whiteColor];
        self.btn2.layer.borderWidth = 1;
        self.block(AnnualInspectionTypeSelfDrivingAnnualInspection);
        [self removeFromSuperview];
    }else{
        self.btn2.selected = YES;
        [self.btn2 setBackgroundColor:[UIColor colorWithHexStringToRGB:@"3CADFF"]];
        self.btn2.layer.borderWidth = 0;
        
        self.btn1.selected = NO;
        self.btn1.backgroundColor = [UIColor whiteColor];
        self.btn1.layer.borderWidth = 1;
        self.block(AnnualInspectionTypeDriverAnnualInspection);
        
        [self removeFromSuperview];

    }
    
}

- (IBAction)coloseBtnAction:(id)sender {
    [self removeFromSuperview];
}



@end
