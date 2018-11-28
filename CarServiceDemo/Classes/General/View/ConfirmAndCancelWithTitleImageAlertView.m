//
//  ConfirmAndCancelAlertWebView.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/9/25.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ConfirmAndCancelWithTitleImageAlertView.h"

@interface ConfirmAndCancelWithTitleImageAlertView ()

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


@implementation ConfirmAndCancelWithTitleImageAlertView

+(instancetype)confirmAndCancelWithTitleImageAlertViewWithTitle:(NSString *)title ImageName:(NSString *)imageName ConfirmBtnIsShow:(BOOL)confirmBtnIsShow ConfirmBtnTitle:(NSString *)confirmBtnTitle ConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor CancelBtnIsShow:(BOOL)cancelBtnIsShow CancelBtnTitle:(NSString *)cancelBtnTitle CancelBtnTitleColor:(UIColor *)cancelTitleColor Handle:(ConfirmAndCancelSelectHandle)handle{
    
    ConfirmAndCancelWithTitleImageAlertView *webView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];;

    [webView confirmAndCancelWithTitleImageAlertViewWithTitle:title ImageName:imageName ConfirmBtnIsShow:confirmBtnIsShow ConfirmBtnTitle:confirmBtnTitle ConfirmBtnTitleColor:confirmBtnTitleColor CancelBtnIsShow:cancelBtnIsShow CancelBtnTitle:cancelBtnTitle CancelBtnTitleColor:cancelTitleColor Handle:handle];
    webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:webView];
    return webView;
    
}

- (void)confirmAndCancelWithTitleImageAlertViewWithTitle:(NSString *)title ImageName:(NSString *)imageName ConfirmBtnIsShow:(BOOL)confirmBtnIsShow ConfirmBtnTitle:(NSString *)confirmBtnTitle ConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor CancelBtnIsShow:(BOOL)cancelBtnIsShow CancelBtnTitle:(NSString *)cancelBtnTitle CancelBtnTitleColor:(UIColor *)cancelTitleColor Handle:(ConfirmAndCancelSelectHandle)handle{
    
    [self.myContentView setCornerRadius:4];
    self.titleLabel.text = title;
    self.imageView.image = [UIImage imageNamed:imageName];
    
    if (confirmBtnIsShow) {
        self.confrimView.hidden = NO;
        self.confrimView.width = (SCREEN_WIDTH - 68)/2;
    }else{
        self.confrimView.hidden = YES;
        self.confrimViewWidth.constant = 0;
        
    }
    if (confirmBtnTitleColor) {
        [self.confrimBtn setTitleColor:confirmBtnTitleColor forState:UIControlStateNormal];
    }
    [self.confrimBtn setTitle:confirmBtnTitle forState:UIControlStateNormal];
    
    
    if (cancelBtnIsShow) {
        self.cancelView.hidden = NO;
        self.cancelViewWidth.constant = (SCREEN_WIDTH - 68)/2;

    }else{
        self.cancelView.hidden = YES;
        self.cancelViewWidth.constant = 0;
        
    }
    if (cancelTitleColor) {
        [self.cancelBtn setTitleColor:cancelTitleColor forState:UIControlStateNormal];
    }
    [self.cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
    
    
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
