//
//  LoginVC.m
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "LoginVC.h"
#import "JKCountDownButton.h"
#import "NewUserRegistrationVC.h"
#import "JPUSHService.h"

@interface LoginVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobiTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeToTheAgreementBtn;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupProperty];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)setupProperty{
    self.title = @"登录";
    [self.mobiTF setValue:[UIColor colorwithHexString:@"0093DD"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.verificationCodeTF setValue:[UIColor colorwithHexString:@"0093DD"] forKeyPath:@"_placeholderLabel.textColor"];
    NSString *phone = [kUserDefault objectForKey:@"MP_LOGIN_PHONE"];
    NSString *pwd = [kUserDefault objectForKey:@"MP_LOGIN_PWD"];
    _mobiTF.text = phone;
    _verificationCodeTF.text = pwd;
    
    self.sendVerificationCodeBtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
    self.sendVerificationCodeBtn.layer.borderWidth = 1;
    self.sendVerificationCodeBtn.layer.cornerRadius = 3;
    [self.loginBtn setCornerRadius:19];
    [self agreeToTheAgreementBtnAction:self.agreeToTheAgreementBtn];
}

- (IBAction)loginBtnAction:(UIButton *)sender {
    if (!self.agreeToTheAgreementBtn.selected) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请阅读并同意《8号养车用户协议》"];
        return;
    }
    if (self.mobiTF.text.length != 11) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入正确的手机号"];
        return;
    }
    if ([ValidateUtil isEmptyStr:self.verificationCodeTF.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入密码"];
        return;
    }
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.mobiTF.text;
    params[@"password"] = self.verificationCodeTF.text;
    [kUserDefault setObject:self.mobiTF.text forKey:@"MP_LOGIN_PHONE"];
    [kUserDefault setObject:self.verificationCodeTF.text forKey:@"MP_LOGIN_PWD"];
    [self.util postDataWithPath:@"/api/login/login/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            UserInfo *info = [[UserInfo alloc]initWithDictionary:obj error:nil];
            weakSelf.user.user_id = info.user_id;
            weakSelf.user.token = info.token;
            [weakSelf reuqestUserInfo];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
        }else{
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
}

- (void)reuqestUserInfo{
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.user.user_id;
    [self.util getDataWithPath:@"/api/user/user/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            NSString *token = weakSelf.user.token;
            NSString *user_id = weakSelf.user.user_id;
            weakSelf.user = [[UserInfo alloc] initWithDictionary:obj error:nil];
            weakSelf.user.token = token;
            weakSelf.user.user_id = user_id;
            weakSelf.user.password = weakSelf.verificationCodeTF.text;
            [JPUSHService setAlias:weakSelf.user.account callbackSelector:nil object:nil];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            [weakSelf.user serilization];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate switchRootViewController];
            [delegate dealRemoteNotificationPush];
        }else{
            [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark -- <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.mobiTF) {
        if (textField.text.length>=11 && string.length>0) {
            
            return NO;
        }
    }
    
    return YES;
}


- (void)sendCode{
    self.sendVerificationCodeBtn.enabled = NO;
    //button type要 设置成custom 否则会闪动
    [self.sendVerificationCodeBtn startWithSecond:60];
    [self.sendVerificationCodeBtn didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%ld秒",(long)second];
        return title;
    }];
    
    [self.sendVerificationCodeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];
    
    //请求发送验证码
//    [MBProgressHUD showStatusOnView:self.view withMessage:@"正在发送验证码..."];
    //    NSString *mobile=[AESCrypt encrypt:mobi password:@"AKlMU89D3FchIkhK"];
    
   
    
//    [self.util postDataWithPath:@"send-msg" parameters:@{@"mobile":self.mobileField.text} result:^(id obj, int status, NSString *msg) {
//        if (status == 1) {
//            [MBProgressHUD dismissHUDForView:self.view withsuccess:@"验证码发送成功！"];
//
//
//
//        }else {
//            self.sendCodeBtn.enabled = YES;
//            [MBProgressHUD dismissHUDForView:self.view withError:msg];
//        }
//    }];
    
}

- (IBAction)sendVerificationCodeBtnAction:(JKCountDownButton *)sender {
    [self sendCode];
}

#pragma mark -- 忘记密码
- (IBAction)forgetPasswordBtnAction:(UIButton *)sender {
    NewUserRegistrationVC *forgetPasswordVC =[[NewUserRegistrationVC alloc]init];
    forgetPasswordVC.isRegistration = NO;
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

- (IBAction)newUserRegistrationBtnAction:(UIButton *)sender {
    NewUserRegistrationVC *forgetPasswordVC = [[NewUserRegistrationVC alloc]init];
    kWeakSelf(weakSelf);
    forgetPasswordVC.confirmBlock = ^(NSString *phone, NSString *pwd) {
        weakSelf.mobiTF.text = phone;
        weakSelf.verificationCodeTF.text = pwd;
    };
    forgetPasswordVC.isRegistration = YES;
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

#pragma mark -- 同意协议
- (IBAction)agreeToTheAgreementBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)readingAgreementBtnAction:(UIButton *)sender {
    kWeakSelf(weakSelf);
    [ConfirmAndCancelAlertWebView confirmAndCancelAlertWebViewWithTitle:@"用户协议" WebUrl:@"http://www.nolasthope.cn/system/useragreement/" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"同意并继续" ConfirmBtnTitleColor:[UIColor colorWithHexStringToRGB:@"3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"不同意" CancelBtnTitleColor:[UIColor colorWithHexStringToRGB:@"9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateConfirm) {
            
            weakSelf.agreeToTheAgreementBtn.selected = NO;
            
        }else{
            weakSelf.agreeToTheAgreementBtn.selected = YES;
        }
        
        [weakSelf agreeToTheAgreementBtnAction:weakSelf.agreeToTheAgreementBtn];
    }];
    
}

- (IBAction)justLookingBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
