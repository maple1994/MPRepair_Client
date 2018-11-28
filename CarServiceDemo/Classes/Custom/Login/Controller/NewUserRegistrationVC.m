//
//  NewUserRegistrationVC.m
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "NewUserRegistrationVC.h"
#import "JKCountDownButton.h"

@interface NewUserRegistrationVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mobiTF;

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendVerificationCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *getNewPasswordTF1;

@property (weak, nonatomic) IBOutlet UITextField *getNewPasswordTF2;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIImageView *APPIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *APPIconImageViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *agreeToTheAgreementBtn;

@property (weak, nonatomic) IBOutlet UIView *agreeToTheAgreementView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeToTheAgreementViewHeight;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameViewHeight;

@end

@implementation NewUserRegistrationVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupProperty];
}

- (void)setupProperty{
    
    if (self.isRegistration) {// 注册
        
        self.nameView.hidden = NO;
        self.nameViewHeight.constant = 40;
        self.agreeToTheAgreementView.hidden = NO;
        self.agreeToTheAgreementViewHeight.constant = 29;
        self.APPIconImageView.hidden = NO;
        self.APPIconImageViewHeight.constant = 88;
        [self.confirmBtn setTitle:@"注册" forState:UIControlStateNormal];
        NSMutableAttributedString *titleMstr =[[NSMutableAttributedString alloc]initWithString:@"您好，\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:28],NSForegroundColorAttributeName :[UIColor colorWithHexStringToRGB:@"000000"]}];
        NSAttributedString *attr1 =[[NSAttributedString alloc]initWithString:@"欢迎来到8号养车！" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16],NSForegroundColorAttributeName :[UIColor colorWithHexStringToRGB:@"4A4A4A"]}];
        [titleMstr appendAttributedString:attr1];
        
        self.titleLabel.attributedText = titleMstr;

    }else{
        
        self.nameView.hidden = YES;
        self.nameViewHeight.constant = 0;
        self.agreeToTheAgreementView.hidden = YES;
        self.agreeToTheAgreementViewHeight.constant = 0;
        self.titleLabel.text = @"请重置您的密码";
        self.APPIconImageView.hidden = YES;
        self.APPIconImageViewHeight.constant = 0;
        
        [self.confirmBtn setTitle:@"保存" forState:UIControlStateNormal];

    }
    
    [self.confirmBtn setCornerRadius:20];

    [self.mobiTF setValue:[UIColor colorwithHexString:@"B7B7B8"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.verificationCodeTF setValue:[UIColor colorwithHexString:@"B7B7B8"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.getNewPasswordTF1 setValue:[UIColor colorwithHexString:@"B7B7B8"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.getNewPasswordTF2 setValue:[UIColor colorwithHexString:@"B7B7B8"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.sendVerificationCodeBtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
    self.sendVerificationCodeBtn.layer.borderWidth = 1;
    self.sendVerificationCodeBtn.layer.cornerRadius = 3;
    
//    UIButton *button = [self.mobiTF valueForKey:@"_clearButton"];
//    [button setImage:[UIImage imageNamed:@"btn_tc_close"] forState:UIControlStateNormal];
    
//    UIButton *button1 = [self.verificationCodeTF valueForKey:@"_clearButton"];
//    [button1 setImage:[UIImage imageNamed:@"btn_tc_close"] forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginBtnAction:(UIButton *)sender {
    if (self.isRegistration && !self.agreeToTheAgreementBtn.selected) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请阅读并同意《8号养车用户协议》"];
        return;
    }
    
    if (self.isRegistration && [ValidateUtil isEmptyStr:self.nameTF.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入姓名！"];
        return;
    }
    if (self.mobiTF.text.length != 11) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入正确的手机号!"];
        return;
    }
    
    if ([ValidateUtil isEmptyStr:self.verificationCodeTF.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入正确的验证码!"];
        return;
    }
    
    if ([ValidateUtil isEmptyStr:self.getNewPasswordTF1.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入新密码!"];
        return;
    }
    
//    if ([ValidateUtil isEmptyStr:self.getNewPasswordTF2.text]) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"请确认新密码!"];
//        return;
//    }
    
//    if (![self.getNewPasswordTF1.text isEqualToString:self.getNewPasswordTF2.text]) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"两次输入的密码不一致!"];
//        return;
//    }
    
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"phone"] = self.mobiTF.text;
    params[@"message"] = self.verificationCodeTF.text;
    params[@"password"] = self.getNewPasswordTF1.text;

    NSString *url = @"";
    if (self.isRegistration) {
        params[@"name"] = self.nameTF.text;
        url = @"/api/login/register/";
    }else{
        url = @"/api/login/reset/";
    }

    [self.util postDataWithPath:url parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            UserInfo *user = [[UserInfo alloc]init];
            user.account = weakSelf.mobiTF.text;
            user.password = weakSelf.getNewPasswordTF1.text;
            
            if ([NSKeyedArchiver archiveRootObject:user toFile:kUserInfoPath])
            {
                NSLog(@"用户信息更新成功！");
            }
            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }else{

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
    
    
    //请求发送验证码
    [MBProgressHUD showStatusOnView:self.view withMessage:@"正在发送验证码..."];
//        NSString *mobile=[AESCrypt encrypt:mobi password:@"AKlMU89D3FchIkhK"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.mobiTF.text;
    if (self.isRegistration) {
        params[@"type"] = @"register";
        
    }else{
        params[@"type"] = @"reset";
    }
    kWeakSelf(weakSelf);
    [self.util postDataWithPath:@"/api/login/message/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:@"验证码发送成功！"];
            
            weakSelf.sendVerificationCodeBtn.enabled = NO;
            //button type要 设置成custom 否则会闪动
            [weakSelf.sendVerificationCodeBtn startWithSecond:60];
            [weakSelf.sendVerificationCodeBtn didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%ld秒",(long)second];
                return title;
            }];
            
            [weakSelf.sendVerificationCodeBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"重新获取";
            }];
        }else {
            weakSelf.sendVerificationCodeBtn.enabled = YES;
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)sendVerificationCodeBtnAction:(JKCountDownButton *)sender {
    if (self.mobiTF.text.length != 11) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入正确的手机号!"];
        return;
    }
    [self sendCode];
}


- (IBAction)popBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 同意协议
- (IBAction)agreeToTheAgreementBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)readingAgreementBtnAction:(UIButton *)sender {
    kWeakSelf(weakSelf);
    [ConfirmAndCancelAlertWebView confirmAndCancelAlertWebViewWithTitle:@"用户协议" WebUrl:@"https://www.baidu.com" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"同意并继续" ConfirmBtnTitleColor:[UIColor colorWithHexStringToRGB:@"3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"不同意" CancelBtnTitleColor:[UIColor colorWithHexStringToRGB:@"9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateConfirm) {
            
            weakSelf.agreeToTheAgreementBtn.selected = NO;
            
        }else{
            weakSelf.agreeToTheAgreementBtn.selected = YES;
        }
        
        [weakSelf agreeToTheAgreementBtnAction:weakSelf.agreeToTheAgreementBtn];
    }];
    
}


@end
