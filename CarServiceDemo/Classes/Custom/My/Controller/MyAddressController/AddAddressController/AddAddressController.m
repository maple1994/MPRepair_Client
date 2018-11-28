//
//  AddAddressController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AddAddressController.h"
#import "MyAddressModel.h"
#import "MyAddressManager.h"
#import "XJLocationPickerView.h"

@interface AddAddressController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
@property (weak, nonatomic) IBOutlet UITextField *userDetailAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;
@property (strong, nonatomic) MyAddressManager  *dataManager;

@end

@implementation AddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _saveButton.cornerRadius = 4;
    if (_isEdite) {
        self.title = @"编辑地址";
        _userNameTextField.text = self.addressModel.name;
        _userPhoneTextField.text = self.addressModel.phone;
        _provinceTextField.text = [NSString stringWithFormat:@"%@  %@  %@",self.addressModel.node1.name,self.addressModel.node2.name,self.addressModel.node3.name];
        _userDetailAddressTextField.text = self.addressModel.address;
        _defaultButton.selected = self.addressModel.is_default;
        
        UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 30)];
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [rightButton setTitle:@"删除" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = kFontSize(14);
        [rightButton addTarget:self action:@selector(cancelMyAddressAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=rightitem;
    }else{
        self.title = @"添加地址";
    }
    
    if (!self.addressModel) {
        self.addressModel = [[MyAddressModel alloc] init];
        [self.addressModel.node1 =  [CityModel alloc] init];
        [self.addressModel.node2 =  [CityModel alloc] init];
        [self.addressModel.node3 =  [CityModel alloc] init];
    }
    
    _userNameTextField.delegate = self;
    _userPhoneTextField.delegate = self;
    _provinceTextField.delegate = self;
    _userDetailAddressTextField.delegate = self;
    
    [_defaultButton setEnlargeEdge:20];
    
}

- (IBAction)selectProvinceButtonAction:(id)sender {
    kWeakSelf(weakSelf)
    [[[XJLocationPickerView alloc] initWithSlectedLocation:^(NSArray *locationArray, NSString *addressString) {
        weakSelf.provinceTextField.text = addressString;
        if (locationArray.count==3) {
            weakSelf.addressModel.node1.ID = locationArray[0];
            weakSelf.addressModel.node2.ID = locationArray[1];
            weakSelf.addressModel.node3.ID = locationArray[2];
        }
        
    }] show];
}

- (IBAction)defaultButtonAction:(id)sender {
    _defaultButton.selected = !_defaultButton.selected;
}

- (IBAction)saveAddressButtonAction:(id)sender {
    
    if (self.addressModel.name.length == 0) {
        [MBProgressHUD showErrorOnView:self.view withMessage:_userNameTextField.placeholder];
        return;
    }else if (self.addressModel.phone.length == 0){
        [MBProgressHUD showErrorOnView:self.view withMessage:_userPhoneTextField.placeholder];
        return;
    }else if (self.provinceTextField.text.length == 0){
        [MBProgressHUD showErrorOnView:self.view withMessage:_provinceTextField.placeholder];
        return;
    }else if (self.addressModel.address.length == 0){
        [MBProgressHUD showErrorOnView:self.view withMessage:_userDetailAddressTextField.placeholder];
        return;
    }
    
    if (self.defaultButton.selected) {
        self.addressModel.is_default = YES;
    }else{
        self.addressModel.is_default = NO;
    }
    
    kWeakSelf(weakSelf)
    
    if (_isEdite) {
        [self.dataManager editeMyAddressWithModel:self.addressModel successBlock:^(BOOL result) {
            if (result) {
                [weakSelf saveCompleteAction];
            }
        } failBlock:^(id error) {
            
        }];
    }else{
        [self.dataManager addMyAddressWithModel:self.addressModel successBlock:^(BOOL result) {
            if (result) {
                [weakSelf saveCompleteAction];
            }
        } failBlock:^(id error) {
            
        }];
    }
    
}

- (void)saveCompleteAction{
    
    if (self.saveBtnBlock) {
        self.saveBtnBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)cancelMyAddressAction{
    [self.dataManager cancenlMyAddressWithID:self.addressModel.ID successBlock:^(BOOL result) {
        kWeakSelf(weakSelf)
        if (result) {
            if (weakSelf.saveBtnBlock) {
                weakSelf.saveBtnBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failBlock:^(id error) {
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userNameTextField) {
        self.addressModel.name = textField.text;
    }else if (textField == _userPhoneTextField){
        self.addressModel.phone = textField.text;
    }else if (textField == _userDetailAddressTextField){
        self.addressModel.address = textField.text;
    }
}

- (MyAddressManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[MyAddressManager alloc] init];
    }
    return _dataManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
