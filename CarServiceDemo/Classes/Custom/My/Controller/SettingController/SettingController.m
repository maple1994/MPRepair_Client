//
//  SettingController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "SettingController.h"
#import "CameraAndPhotosAlbum.h"
#import "MyManager.h"
#import "JPUSHService.h"

@interface SettingController ()<CameraAndPhotosAlbumDelegate>

@property (weak, nonatomic) IBOutlet UIButton *iconImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (strong, nonatomic) CameraAndPhotosAlbum *cameraAndPhotosAlbum;
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self loadAllView];
}

- (void)loadAllView{
    
    _logOutButton.cornerRadius = 4;
    
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 30)];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFontSize(14);
    [rightButton addTarget:self action:@selector(completeSettingAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightitem;
    
    _iconImageBtn.cornerRadius = _iconImageBtn.width*0.5;
    [_iconImageBtn sd_setImageWithURL:[NSURL URLWithString:self.user.pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:KDefaultImage]];
    _userNameTextField.text = self.user.name;
    _userPhoneTextField.text = self.user.phone;
}

#pragma mark - 保存修改
- (void)completeSettingAction{
    if (self.userNameTextField.text.length==0) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入昵称"];
        return;
    }
    if (self.userPhoneTextField.text.length==0||![ValidateUtil isTelphone:self.userPhoneTextField.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入正确的手机号"];
        return;
    }
    
    kWeakSelf(weakSelf)
    [MyManager modificationUserMessageWithImage:self.iconImageBtn.currentImage anduserName:self.userNameTextField.text andPhone:self.userPhoneTextField.text successBlock:^(BOOL result) {
        if (weakSelf.settingSuccessBlock) {
            weakSelf.settingSuccessBlock();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 换头像
- (IBAction)changeIconButtonAction:(id)sender {
    //更改头像
    [self.cameraAndPhotosAlbum cameraAndPhotosAlbumWithController:self AspectRatio:AspectRatio4x3 ipadPopoverFromRect:self.view];
}

#pragma mark - CameraAndPhotosAlbumDelegate 上传证件信息
- (void)sendeImage :(UIImage *)img {
    [_iconImageBtn setImage:img forState:UIControlStateNormal] ;
}

#pragma mark - 退出登录
- (IBAction)logOutAction:(id)sender {
    self.user = nil;
    if ([NSKeyedArchiver archiveRootObject:self.user toFile:kUserInfoPath])
    {
        NSLog(@"用户信息删除成功！");
    }
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
    
    //登录的窗口
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] switchRootViewControllerWithType:RootViewControllerTypeLogin];
}

#pragma mark -- 懒加载
- (CameraAndPhotosAlbum *)cameraAndPhotosAlbum {
    
    if (!_cameraAndPhotosAlbum) {
        _cameraAndPhotosAlbum = [[CameraAndPhotosAlbum alloc] init];
        _cameraAndPhotosAlbum.delegate = self;
    }
    return _cameraAndPhotosAlbum;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
