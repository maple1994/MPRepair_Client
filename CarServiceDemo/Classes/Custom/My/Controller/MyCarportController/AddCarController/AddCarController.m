//
//  AddCarController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AddCarController.h"
#import "MyManager.h"
#import "CameraAndPhotosAlbum.h"
#import "CarModel.h"
#import "SeletCarBrandController.h"
#import "AddCarAddressView.h"

@interface AddCarController ()<CameraAndPhotosAlbumDelegate,UniversalSelectionBoxViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *engineTextField;
@property (weak, nonatomic) IBOutlet UITextField *frameTextField;
@property (strong, nonatomic) CameraAndPhotosAlbum *cameraAndPhotosAlbum;
@property (weak, nonatomic) IBOutlet UIButton *defaultImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *carNumberTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carAddressLabel;
@property (assign,nonatomic) BOOL hasImage;

@property (copy, nonatomic) NSString *nowCityCode;

@property (nonatomic ,strong)UniversalSelectionBoxView *selectBoxView;

@end

@implementation AddCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    
    if (_isEdite) {
        self.title = @"编辑车辆";
        UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 30)];
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [rightButton setTitle:@"删除" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = kFontSize(14);
        [rightButton addTarget:self action:@selector(cancelMyCarAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=rightitem;
        
        if (_carModel.pic_url) {
            _hasImage = YES;
            [NetWorkingUtil setImage:_carImageView url:_carModel.pic_url defaultIconName:KDefaultImage];
        }
        
        _carTypeLabel.text = _carModel.brand_name;
        _defaultImageBtn.selected = _carModel.is_default;
        _plateNumberTextField.text = _carModel.code;
        _engineTextField.text = _carModel.engine;
        _frameTextField.text = _carModel.classsno;
        NSString *hpzl = @"";
        if ([_carModel.hpzl isEqualToString:@"02"]) {
            hpzl = @"小型车";
        }else if ([_carModel.hpzl isEqualToString:@"01"]) {
            hpzl = @"大型车";
        }if ([_carModel.hpzl isEqualToString:@"16"]) {
            hpzl = @"教练车";
        }
        _carNumberTypeLabel.text = hpzl;
        _carAddressLabel.text = [NSString stringWithFormat:@"%@ %@",_carModel.province_name,_carModel.city_name];
        
    }else{
        self.title = @"添加车辆";
    }
    _saveButton.cornerRadius = 4;
}

- (void)loadAllData{
    
}

- (void)cancelMyCarAction{
    kWeakSelf(weakSelf)
    [MyManager cancelCarWithCarID:_carModel.ID successBlock:^(BOOL result) {
        if (weakSelf.addCarBlock) {
            weakSelf.addCarBlock();
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failBlock:^(id error) {
        
    }];
}

- (IBAction)addCarImageAction:(id)sender {
    [self.cameraAndPhotosAlbum cameraAndPhotosAlbumWithController:self AspectRatio:AspectRatio4x3 ipadPopoverFromRect:self.view];
}

#pragma mark - CameraAndPhotosAlbumDelegate 上传证件信息
- (void)sendeImage :(UIImage *)img {
    _carImageView.image = img;
    _hasImage = YES;
}

- (IBAction)defaultImageButtonAction:(id)sender {
    _defaultImageBtn.selected = !_defaultImageBtn.selected;
}

#pragma mark - 保存
- (IBAction)saveAddNewCarAction:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([_carTypeLabel.text isEqualToString:@"品牌类型"]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择车辆品牌类型"];
        return;
    }else{
        params[@"car_style"] = self.carStyleID;
    }
    if (!_hasImage) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请添加车辆照片"];
        return;
    }else{
        NSData *data = [UIImage imageWithImage:_carImageView.image limitCompactionImageLength:200];
        //使用0或以下来控制线结束后的最大线长度。默认情况下没有插入任何行的结尾
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:0];
        params[@"pic"] = encodedImageStr;
    }
    if (_plateNumberTextField.text.length==0) {
        [MBProgressHUD showErrorOnView:self.view withMessage:_plateNumberTextField.placeholder];
        return;
    }else{
        params[@"code"] = _plateNumberTextField.text;
    }
    if (_engineTextField.text.length==0) {
        [MBProgressHUD showErrorOnView:self.view withMessage:_engineTextField.placeholder];
        return;
    }else{
        params[@"engine"] = _engineTextField.text;
    }
    if (_frameTextField.text.length==0) {
        [MBProgressHUD showErrorOnView:self.view withMessage:_frameTextField.placeholder];
        return;
    }else{
        params[@"classsno"] = _frameTextField.text;
    }
    if ([_carNumberTypeLabel.text isEqualToString:@"号牌类型"]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择号牌类型"];
        return;
    }else{
        NSString *hpzl = @"";
        if ([_carNumberTypeLabel.text isEqualToString:@"小型车"]) {
            hpzl = @"02";
        }else if ([_carNumberTypeLabel.text isEqualToString:@"大型车"]) {
            hpzl = @"01";
        }if ([_carNumberTypeLabel.text isEqualToString:@"教练车"]) {
            hpzl = @"16";
        }
        params[@"hpzl"] = hpzl;
    }
    if ([_carAddressLabel.text isEqualToString:@"车辆地址"]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择车辆地址"];
        return;
    }else{
        params[@"city_code"] = self.nowCityCode;
    }
    
    if (_isEdite) {
        params[@"id"] = _carModel.ID;
    }
    
    params[@"is_default"] = @(_defaultImageBtn.selected);
    
    kWeakSelf(weakSelf)
    [MyManager addCarMessageWithParams:params successBlock:^(BOOL result) {
        if (result) {
            if (weakSelf.addCarBlock) {
                weakSelf.addCarBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failBlock:^(id error) {
        
    }];
}

- (IBAction)selectCarTypeAction:(id)sender {
    if (!self.selectBoxView) {
        self.selectBoxView = [UniversalSelectionBoxView universalSelectionBoxViewWithDataArr:@[@"小型车",@"大型车",@"教练车"]];
        self.selectBoxView.delegate = self;
        [self.view addSubview:self.selectBoxView];
    }else{
        [self.selectBoxView showUniversalSelectionBoxView];
    }
    
}

- (void)universalSelectionBoxView:(UIView *)view SelectedIndex:(NSInteger)selectIndex SelectContent:(NSString *)selectContent{
    
    _carNumberTypeLabel.text = selectContent;
}

- (IBAction)selectCarAddressAction:(id)sender {
    AddCarAddressView *addAddress = [[AddCarAddressView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:addAddress];
    kWeakSelf(weakSelf)
    addAddress.affirmBlock = ^(NSString *cityName, NSString *cityCode) {
        weakSelf.nowCityCode = cityCode;
        weakSelf.carAddressLabel.text = cityName;
    };
}

- (IBAction)selectCatTypeAction:(id)sender {
    SeletCarBrandController *carBrandVC = [[SeletCarBrandController alloc] init];
    [self.navigationController pushViewController:carBrandVC animated:YES];
}

- (void)setCarName:(NSString *)carName{
    _carName = carName;
    _carTypeLabel.text = _carName;
}

#pragma mark - 懒加载
- (CameraAndPhotosAlbum *)cameraAndPhotosAlbum {
    
    if (!_cameraAndPhotosAlbum) {
        
        _cameraAndPhotosAlbum = [[CameraAndPhotosAlbum alloc] init];
        _cameraAndPhotosAlbum.delegate = self;
        
    }
    return _cameraAndPhotosAlbum;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
