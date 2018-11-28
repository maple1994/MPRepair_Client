//
//  ConfirmAndCancelAlertWebView.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/9/25.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "OnlyConfirmWithTitleImageAlertView.h"

@interface OnlyConfirmWithTitleImageAlertView ()

@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelViewWidth;


@property (weak, nonatomic) IBOutlet UIView *confrimView;
@property (weak, nonatomic) IBOutlet UIButton *confrimBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confrimViewWidth;

///
@property (nonatomic ,copy)ConfirmAndCancelSelectHandle handle;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end


@implementation OnlyConfirmWithTitleImageAlertView

+(instancetype)onlyConfirmWithTitleImageAlertViewWithTitle:(NSString *)title ImageName:(NSString *)imageName ConfirmBtnTitle:(NSString *)confirmBtnTitle ConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor Handle:(ConfirmAndCancelSelectHandle)handle{
    
    OnlyConfirmWithTitleImageAlertView *webView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];;

    [webView onlyConfirmWithTitleImageAlertViewWithTitle:title ImageName:imageName ConfirmBtnTitle:confirmBtnTitle ConfirmBtnTitleColor:confirmBtnTitleColor Handle:handle];
    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:webView];
    return webView;
    
}

- (void)onlyConfirmWithTitleImageAlertViewWithTitle:(NSString *)title ImageName:(NSString *)imageName ConfirmBtnTitle:(NSString *)confirmBtnTitle ConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor Handle:(ConfirmAndCancelSelectHandle)handle{
    
    [self.myContentView setCornerRadius:4];
    self.titleLabel.text = title;
    self.imageView.image = [UIImage imageNamed:imageName];
    
    if (confirmBtnTitleColor) {
        [self.confrimBtn setTitleColor:confirmBtnTitleColor forState:UIControlStateNormal];
    }
    
    [self.confrimBtn setCornerRadius:4];
    [self.confrimBtn setTitle:confirmBtnTitle forState:UIControlStateNormal];

    self.handle = handle;
    
    
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    [self removeFromSuperview];
    self.handle(AlertViewSelectStateConfirm);
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self removeFromSuperview];
    self.handle(AlertViewSelectStateCancel);
}



@end
