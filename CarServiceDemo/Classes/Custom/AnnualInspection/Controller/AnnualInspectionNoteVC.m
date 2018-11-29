//
//  AnnualInspectionNoteVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionNoteVC.h"
#import "CameraAndPhotosAlbum.h"
#import "UIImage+Thumb.h"
#import "XFBButton.h"
#import "PaymentController.h"
#import "MapLocationSelectionAddressVC.h"
#import "AnnualInspectionStationInfoModel.h"
#import "PackageSelectionCollectionViewCell.h"
#import "PackageSelectionModel.h"
#import "AnnualInspectionNoteInfoModel.h"
#import "CarModel.h"
#import "MyManager.h"

@interface AnnualInspectionNoteVC () <UniversalSelectionBoxViewDelegate,CameraAndPhotosAlbumDelegate,MapLocationSelectionAddressVCDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

/// 联系人
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
/// 联系人电话
@property (weak, nonatomic) IBOutlet UITextField *mobiTF;
/// 车主身份证正面照
@property (weak, nonatomic) IBOutlet UIImageView *cardInfoImageView1;
/// 车主身份证反面照
@property (weak, nonatomic) IBOutlet UIImageView *cardInfoImageView2;
/// 行驶证副页照
@property (weak, nonatomic) IBOutlet UIImageView *cardInfoImageView3;
/// 车主姓名
@property (weak, nonatomic) IBOutlet UITextField *ownerNameTF;
/// 车主身份证号码
@property (weak, nonatomic) IBOutlet UITextField *ownerIdentificationNumberTF;
/// 品牌型号
@property (weak, nonatomic) IBOutlet UITextField *ownerBrandModelNumberTF;
/// 号码号牌
@property (weak, nonatomic) IBOutlet UITextField *ownerCarNumberTF;
/// 车辆类型
@property (weak, nonatomic) IBOutlet UILabel *ownerCarBrandLabel;
/// 营用
@property (weak, nonatomic) IBOutlet UIButton *campBtn;
/// 非营用
@property (weak, nonatomic) IBOutlet UIButton *noCampBtn;
/// 年检站
@property (weak, nonatomic) IBOutlet UILabel *annualInspectionStationLabel;
/// 年检站信息arr
@property (nonatomic ,strong)NSMutableArray *annualInspectionStationDataArr;


/// 交接车地点
@property (weak, nonatomic) IBOutlet UILabel *eliveryLocationLabel;
@property (nonatomic ,copy)NSString *eliveryLocationLat;
@property (nonatomic ,copy)NSString *eliveryLocationLng;



/// 选择车型view
@property (nonatomic ,strong)UniversalSelectionBoxView *carTypeSelectBoxView;

/// 上传车主证件相关信息
@property (nonatomic,strong)CameraAndPhotosAlbum *cameraAndPhotosAlbum;
@property (nonatomic ,assign)NSInteger selectCardInfoImageIndex;

/// 选择维修站点view
@property (nonatomic ,strong)UniversalSelectionBoxView *selectAnnualInspectionStationBoxView;

// 选择预约时间按钮
@property (weak, nonatomic) IBOutlet UIButton *selectTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectTimeLabel;


@property (weak, nonatomic) IBOutlet XFBButton *selectMorningOrAfternoonBtn;
// 选择上午或者下午
@property (nonatomic ,strong)UniversalSelectionBoxView *selectMorningOrAfternoonBoxView;
/// 套餐A
@property (weak, nonatomic) IBOutlet UIButton *packageABtn;
@property (weak, nonatomic) IBOutlet UIView *packageAView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *packageAViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *packageADetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageBDetailsLabel;

/// 套餐B
@property (weak, nonatomic) IBOutlet UIButton *packageBBtn;
@property (weak, nonatomic) IBOutlet UIView *packageBView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *packageBViewHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *packageSelectionCollectionView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *packageSelectionCollectionViewHeight;

/// 套餐B内容
@property (nonatomic ,strong)NSMutableArray *packageSelectionBDataArr;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *identityInformaitonBtns;

/// 选择的年检站id
@property (nonatomic ,copy)NSString *surveystationIDStr;
/// 套餐id
@property (nonatomic ,copy)NSString *comboAID;
@property (nonatomic ,copy)NSString *comboBID;
@property (weak, nonatomic) IBOutlet UIView *payInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payInfoViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *basePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *comboPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *surveyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic ,strong)AnnualInspectionNoteInfoModel *noteInfoModel;

@property (strong, nonatomic) CarModel *carModel;
@end

static NSString *PackageSelectionCollectionViewCellID = @"PackageSelectionCollectionViewCell";

@implementation AnnualInspectionNoteVC

#pragma mark -- 懒加载
- (CameraAndPhotosAlbum *)cameraAndPhotosAlbum {
    
    if (!_cameraAndPhotosAlbum) {
        
        _cameraAndPhotosAlbum = [[CameraAndPhotosAlbum alloc] init];
        _cameraAndPhotosAlbum.delegate = self;
        
    }
    return _cameraAndPhotosAlbum;
}

- (NSMutableArray *)annualInspectionStationDataArr{
    
    if (!_annualInspectionStationDataArr) {
        _annualInspectionStationDataArr =[NSMutableArray array];
    }
    return _annualInspectionStationDataArr;
    
}

- (NSMutableArray *)packageSelectionBDataArr{
    if (!_packageSelectionBDataArr) {
        _packageSelectionBDataArr = [NSMutableArray array];
    }
    return _packageSelectionBDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    /// 初始化属性
    [self setupProperty];
    
    
    [self requestPackageSelectionInfo];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestPackageSelectionInfo{
    
    kWeakSelf(weakSelf);
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    
    [self.util getDataWithPath:@"/api/survey/combo/" parameters:nil result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in obj) {
                    NSString *name = [dict valueForKey:@"name"];
                    if ([name isEqualToString:@"A套餐"]) {
                        weakSelf.packageADetailsLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"detail"]];
                        weakSelf.comboAID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
//                        [weakSelf chooseAPackageBtnAction:self.packageABtn];
                    }else{
                        weakSelf.comboBID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                        weakSelf.packageBDetailsLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"detail"]];
//                        weakSelf.comboBID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
//                        id comboitem_setArr = [dict valueForKey:@"comboitem_set"];
//                        if (comboitem_setArr && [comboitem_setArr isKindOfClass:[NSArray class]]) {
//                            for (NSDictionary *modelDict in comboitem_setArr) {
//
//                                PackageSelectionComboitemSetModel *model = [[PackageSelectionComboitemSetModel alloc]initWithDictionary:modelDict error:nil];
////                                model.name = @"机油";
////                                model.price = @"200";
//                                [weakSelf.packageSelectionBDataArr addObject:model];
//
//                            }
//
//                            [weakSelf.packageSelectionCollectionView reloadData];
//
//
//                        }
//
                    }
                }
                
                
            }
            

        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
    
}

- (CGFloat)getPackageAViewHeightWithContent:(NSString *)str{
    CGSize tempSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 148, MAXFLOAT);
    CGFloat height = [str boundingRectWithSize:tempSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    height += 12;
    if (height <= 70) {
        return 70;
    }
    return height;
}

- (CGFloat)getPackageBViewHeight{
    CGFloat height = 12;

    NSUInteger remainder = self.packageSelectionBDataArr.count%3;
    NSUInteger column = self.packageSelectionBDataArr.count/3;

    if (remainder>0) {
        column += 1;
    }
    height += (column * 57);
    
    return height;
}

#pragma mark -- 初始化属性
- (void)setupProperty{
    self.title = @"填写信息";
    [self camporNoCampBtnAction:self.campBtn];
//    [self.selectTimeBtn setTitle:@"请选择预约时间" forState:UIControlStateNormal];
//    self.selectTimeBtn.layoutStyle = XFBButtonStyleLeftTitleRightImage;
    [self.selectMorningOrAfternoonBtn setTitle:@"上午" forState:UIControlStateNormal];
    self.selectMorningOrAfternoonBtn.layoutStyle = XFBButtonStyleLeftTitleRightImage;
    
    [self.packageSelectionCollectionView registerNib:[UINib nibWithNibName:PackageSelectionCollectionViewCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:PackageSelectionCollectionViewCellID];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(12, 18, 0, 0);
    self.packageSelectionCollectionView.collectionViewLayout = flowLayout;
    
    for (UIButton *btn in self.identityInformaitonBtns) {
        [btn setCornerRadius:2];
//        btn.layer.borderColor = [UIColor colorwithHexString:@"A3A3A3"].CGColor;
//        btn.layer.borderWidth = 1;
    }
    self.packageABtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
    self.packageABtn.layer.borderWidth = 1;
    self.packageBBtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
    self.packageBBtn.layer.borderWidth = 1;
    
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.nameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.mobiTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.ownerNameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.ownerBrandModelNumberTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.ownerCarNumberTF];
    
}


- (void)setupInterface{
    
    self.noteInfoModel = [AnnualInspectionNoteInfoModel noteInfo];
    
    if ([ValidateUtil isEmptyStr:self.noteInfoModel.phone]) {
        self.noteInfoModel.phone = self.user.phone;
        self.mobiTF.text = self.user.phone;
    }else{
        self.mobiTF.text = self.noteInfoModel.phone;
    }
    if ([ValidateUtil isEmptyStr:self.noteInfoModel.name]) {
        self.noteInfoModel.name = self.user.name;
        self.nameTF.text = self.user.name;
    }else{
        self.nameTF.text = self.noteInfoModel.name;
    }
    
    self.ownerNameTF.text = self.noteInfoModel.car_name;
    self.ownerBrandModelNumberTF.text = self.noteInfoModel.car_brand;
    self.ownerCarNumberTF.text = self.noteInfoModel.car_code;
    
    kWeakSelf(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
       weakSelf.ownerNameTF.text = self.user.name;
    });
    
    [self loadCarData];

}

- (void)loadCarData{
    kWeakSelf(weakSelf)
    [MyManager getCarportListDataIsDefault:YES successBlock:^(NSMutableArray *result) {
        if (result>0) {
            weakSelf.carModel = [result firstObject];
            [weakSelf reloadCarView];
        }
    } failBlock:^(id error) {
    }];
}

- (void)reloadCarView{
    if (self.carModel) {
    
        if ([ValidateUtil isEmptyStr:self.noteInfoModel.car_code]) {
            self.noteInfoModel.car_code = self.carModel.code;
            self.ownerCarNumberTF.text = self.carModel.code;
        }
        if ([ValidateUtil isEmptyStr:self.noteInfoModel.car_brand]) {
            self.noteInfoModel.car_brand = self.carModel.brand_name;
            self.ownerBrandModelNumberTF.text = self.carModel.brand_name;
        }
        
    }
}


#pragma mark - ※※※※※※※※※※※※※※※※※※※※※※※※输入监听※※※※※※※※※※※※※※※※※※※※※※※※
- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *textfield = [notification object];
    if (textfield == self.nameTF) {
        self.noteInfoModel.name = textfield.text;
    }else if (textfield == self.mobiTF) {
        self.noteInfoModel.phone = textfield.text;
    }else if (textfield == self.ownerNameTF) {
        self.noteInfoModel.car_name = textfield.text;
    }else if (textfield == self.ownerBrandModelNumberTF) {
        self.noteInfoModel.car_brand = textfield.text;
    }else if (textfield == self.ownerCarNumberTF) {
        self.noteInfoModel.car_code = textfield.text;
    }
    
    
}


#pragma mark -- 汽车类型选择按钮事件
- (IBAction)carTypeSelectBtnAction:(id)sender {
    
    if (!self.carTypeSelectBoxView){
        self.carTypeSelectBoxView = [UniversalSelectionBoxView universalSelectionBoxViewWithDataArr:@[@"小型蓝牌",@"七座以下"]];
        self.carTypeSelectBoxView.delegate = self;
        [self.view addSubview:self.carTypeSelectBoxView];
    }else{
        [self.carTypeSelectBoxView showUniversalSelectionBoxView];
    }
    
}

#pragma mark -- 通用选择框代理回调
- (void)universalSelectionBoxView:(UIView *)view SelectedIndex:(NSInteger)selectIndex SelectContent:(NSString *)selectContent{
    
    if (view == self.carTypeSelectBoxView){
        
        self.ownerCarBrandLabel.text = selectContent;
        
    }else if (view == self.selectAnnualInspectionStationBoxView){
        
        self.annualInspectionStationLabel.text = selectContent;
        AnnualInspectionStationInfoModel *model = self.annualInspectionStationDataArr[selectIndex];
        self.surveystationIDStr = model.ID;
        
    }else if(view == self.selectMorningOrAfternoonBoxView){
        [self.selectMorningOrAfternoonBtn setTitle:[NSString stringWithFormat:@"%@",selectContent] forState:UIControlStateNormal];
        self.selectMorningOrAfternoonBtn.layoutStyle = XFBButtonStyleLeftTitleRightImage;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    ///限制输入11位
    if (textField == self.mobiTF){
        if (textField.text.length>=11 && string.length>0) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark 上传证件信息按钮事件
- (IBAction)selectCardInfoImageBtnAction:(UIButton *)sender {
    //更改头像
    [self.cameraAndPhotosAlbum cameraAndPhotosAlbumWithController:self AspectRatio:AspectRatio4x3 ipadPopoverFromRect:self.view];
    self.cameraAndPhotosAlbum.delegate = self;
    self.selectCardInfoImageIndex = sender.tag;

}

#pragma mark - CameraAndPhotosAlbumDelegate 上传证件信息
- (void)sendeImage :(UIImage *)img {
   
    if (self.selectCardInfoImageIndex == 100) {
        
        self.cardInfoImageView1.image = img;
        
    }else if (self.selectCardInfoImageIndex == 101) {
        self.cardInfoImageView2.image = img;
        
    }else if (self.selectCardInfoImageIndex == 102) {
        self.cardInfoImageView3.image = img;
    }
    
    
    UIButton *btn = [self.view viewWithTag:self.selectCardInfoImageIndex];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    
}

#pragma mark -- 选择营用非营运按钮事件
- (IBAction)camporNoCampBtnAction:(UIButton *)sender {
    self.campBtn.selected = NO;
    self.noCampBtn.selected = NO;
    
    if (sender==self.campBtn) {
        self.campBtn.selected = YES;
        self.noCampBtn.selected = NO;
        self.campBtn.backgroundColor = DefaultBlueColor;
        self.campBtn.layer.borderWidth = 0;
        self.noCampBtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
        self.noCampBtn.layer.borderWidth = 1;
        self.noCampBtn.backgroundColor = [UIColor whiteColor];
    }else{
        self.campBtn.selected = NO;
        self.noCampBtn.selected = YES;
        self.noCampBtn.backgroundColor = DefaultBlueColor;
        self.noCampBtn.layer.borderWidth = 0;
        self.campBtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
        self.campBtn.layer.borderWidth = 1;
        self.campBtn.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark -- 选择年检站按钮事件
- (IBAction)selectAnnualInspectionStationBtnAction:(UIButton *)sender {
    if(!self.selectAnnualInspectionStationBoxView && self.annualInspectionStationDataArr.count == 0){
        
        [self requestAnnualInspectionStationInfo];
        
    }else{
        
        [self.selectAnnualInspectionStationBoxView showUniversalSelectionBoxView];
    }
    
}

#pragma mark -- 获取年检站信息
- (void)requestAnnualInspectionStationInfo{
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    
    [self.util getDataWithPath:@"/api/survey/surveystation/" parameters:nil result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            NSMutableArray *nameArr= [NSMutableArray array];
            
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                for (NSDictionary *modelDict in obj) {
                    AnnualInspectionStationInfoModel *model =[[AnnualInspectionStationInfoModel alloc]initWithDictionary:modelDict error:nil];
                    [weakSelf.annualInspectionStationDataArr addObject:model];
                    [nameArr addObject:model.name];
                }
            }
            
            [MBProgressHUD dismissHUDForView:weakSelf.view];

            
            if (nameArr.count > 0) {
                weakSelf.selectAnnualInspectionStationBoxView = [UniversalSelectionBoxView universalSelectionBoxViewWithDataArr:nameArr];
                weakSelf.selectAnnualInspectionStationBoxView.delegate = weakSelf;
                [weakSelf.view addSubview:weakSelf.selectAnnualInspectionStationBoxView];
                
            }else{
                
                [MBProgressHUD showErrorOnView:weakSelf.view withMessage:@"暂无年检站信息！"];
            }

        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];

        }
    }];
    
}

#pragma mark  -- 选择预约时间按钮事件
- (IBAction)selectAppointmentTimeBtnAction:(XFBButton *)sender {
    kWeakSelf(weakSelf);
    //年-月-日
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        weakSelf.selectTimeLabel.text = [NSString stringWithFormat:@"%@",dateString];
    }];
    NSDate *minSelectDate = nil;
    if ([self.user.currentCity isEqualToString:@"广州市"]) {
        minSelectDate = [NSDate dateWithDaysFromNow:3];
    }else{
        minSelectDate = [NSDate dateWithDaysFromNow:1];
    }
    datepicker.minLimitDate = minSelectDate;
    datepicker.dateLabelColor = [UIColor colorwithHexString:@"3CADFF"];;//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor colorwithHexString:@"3CADFF"];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor colorwithHexString:@"3CADFF"];;//确定按钮的颜色
    [datepicker show];
}

#pragma mark -- 选择预约时间上午或下午按钮事件
- (IBAction)selectMorningOrAfternoonBtnAction:(XFBButton *)sender {
    if(!self.selectMorningOrAfternoonBoxView){
        self.selectMorningOrAfternoonBoxView = [UniversalSelectionBoxView universalSelectionBoxViewWithDataArr:@[@"上午",@"下午"]];
        self.selectMorningOrAfternoonBoxView.delegate = self;
        [self.view addSubview:self.selectMorningOrAfternoonBoxView];
    }else{
        
        [self.selectMorningOrAfternoonBoxView showUniversalSelectionBoxView];
    }
}

#pragma mark -- 选择套餐类型
- (IBAction)chooseAPackageBtnAction:(UIButton *)sender {
    
    if ([ValidateUtil isEmptyStr:self.eliveryLocationLat] || [ValidateUtil isEmptyStr:self.eliveryLocationLng]) {
        
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择交车地点"];
        
        return;
    }
    if ([ValidateUtil isEmptyStr:self.annualInspectionStationLabel.text] || [self.annualInspectionStationLabel.text isEqualToString:@"请选择年检站"]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择年检站!"];
        return;
    }
    
    
    self.packageABtn.selected = NO;
    self.packageBBtn.selected = NO;
    self.packageAView.hidden = YES;
    self.packageAViewHeight.constant = 0;
    self.packageBView.hidden = YES;
    self.packageBViewHeight.constant = 0;
    if (sender==self.packageABtn) {
        self.packageABtn.selected = YES;
        self.packageABtn.backgroundColor = DefaultBlueColor;
        self.packageABtn.layer.borderWidth = 0;
    
        self.packageBBtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
        self.packageBBtn.layer.borderWidth = 1;
        self.packageBBtn.selected = NO;
        self.packageBBtn.backgroundColor = [UIColor whiteColor];
        
        self.packageAView.hidden = NO;
        self.packageAViewHeight.constant = [self getPackageAViewHeightWithContent:self.packageADetailsLabel.text];

        self.packageBView.hidden = YES;
        self.packageBViewHeight.constant = 0;
        
//        self.packageADetailsLabel.text = self.packageADetailsl;
   
    }else{
        
//        self.packageADetailsLabel.text = self.packageBDetailsl;
        
        self.packageBBtn.selected = YES;
        self.packageBBtn.backgroundColor = DefaultBlueColor;
        self.packageBBtn.layer.borderWidth = 0;
        
        self.packageABtn.selected = NO;
        self.packageABtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
        self.packageABtn.layer.borderWidth = 1;
        self.packageABtn.backgroundColor = [UIColor whiteColor];
        
        self.packageAView.hidden = YES;
        self.packageAViewHeight.constant = 0;
        self.packageBView.hidden = NO;
        self.packageAViewHeight.constant = [self getPackageAViewHeightWithContent:self.packageBDetailsLabel.text];

//        self.packageBViewHeight.constant = [self getPackageBViewHeight];
//        [self.packageSelectionCollectionView reloadData];
    }
    [self getPackagePayInfo];
}

#pragma mark -- 确认并支付按钮事件
- (IBAction)payBtnAction:(id)sender {
    
    if ([ValidateUtil isEmptyStr:self.nameTF.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入联系人！"];
        return;
    }
    
    if (self.mobiTF.text.length != 11) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入正确的联系人号码！"];
        return;
    }
    
    
    if([ValidateUtil isEmptyStr:self.ownerNameTF.text]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入车主姓名！"];
        return;
    }
    
    
    if([ValidateUtil isEmptyStr:self.ownerBrandModelNumberTF.text]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入品牌型号！"];
        return;
    }
    
    if([ValidateUtil isEmptyStr:self.ownerCarNumberTF.text]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入号码号牌！"];
        return;
    }
    
    if([self.ownerCarBrandLabel.text isEqualToString:@"请选择车辆类型"]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择车辆类型！"];
        return;
    }
   
    if([self.annualInspectionStationLabel.text isEqualToString:@"请选择年检站"]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择年检站！"];
        return;
    }
    
    if([ValidateUtil isEmptyStr:self.eliveryLocationLat] || [ValidateUtil isEmptyStr: self.eliveryLocationLng]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择交车地点！"];
        return;
    }
    
    //[ValidateUtil isEmptyStr:self.selectMorningOrAfternoonBtn.currentTitle] ||
    if( [ValidateUtil isEmptyStr: self.selectTimeLabel.text] ||[self.selectTimeLabel.text isEqualToString:@"请选择预约时间"]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择预约时间"];
        return;
    }
    
    
    if (!self.packageABtn.selected && !self.packageBBtn.selected) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择套餐！"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = self.nameTF.text;
    params[@"phone"] = self.mobiTF.text;
    params[@"car_name"] = self.ownerNameTF.text;
    params[@"car_brand"] = self.ownerBrandModelNumberTF.text;
    params[@"car_code"] = self.ownerCarNumberTF.text;
    params[@"car_type"] = self.ownerCarBrandLabel.text;
    params[@"surveystation_id"] = self.surveystationIDStr;
    params[@"order_longitude"] = self.eliveryLocationLng;
    params[@"order_latitude"] = self.eliveryLocationLat;
    params[@"order_address"] = self.eliveryLocationLabel.text;
    params[@"subscribe_time"] = [NSString stringWithFormat:@"%@",self.selectTimeLabel.text];
    params[@"is_self"] = @"0";
    params[@"combo_id"] = self.packageABtn.selected ? self.comboAID : self.comboBID;
//    if (self.packageBBtn.selected) {
//
//    }
    NSMutableArray *idStrArr = [NSMutableArray array];
    
    for (PackageSelectionComboitemSetModel *model in self.packageSelectionBDataArr) {
        if (model.isSelect) {
            [idStrArr addObject:model.ID];
        }
    }
    NSString *idStr = [idStrArr componentsJoinedByString:@","];
    params[@"comboitem_list"] = idStr;
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    [self.util postDataWithPath:@"/api/survey/survey/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            [weakSelf.noteInfoModel clean];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
            PaymentController *paymentVC = [[PaymentController alloc] init];
            paymentVC.orderID = [NSString stringWithFormat:@"%ld",[obj[@"id"] integerValue]];
            paymentVC.payType = PayTypeReplaceSurvey;
            [weakSelf.navigationController pushViewController:paymentVC animated:YES];
        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
}

#pragma mark -- 选择交车地点按钮事件
- (IBAction)selectAddressBtnAction:(id)sender {
    MapLocationSelectionAddressVC *selectAddressVC = [[MapLocationSelectionAddressVC alloc]init];
    selectAddressVC.delegte = self;
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}

#pragma mark -- 选择交车地点地图回调
- (void)getSelectAddress:(NSString *)address Lat:(NSString *)lat lng:(NSString *)lng{
    self.eliveryLocationLabel.text = address;
    self.eliveryLocationLat = lat;
    self.eliveryLocationLng = lng;
}


#pragma mark -- <UICollectionViewDelegate,UICollectionViewDataSource>
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.packageSelectionBDataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    PackageSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PackageSelectionCollectionViewCellID forIndexPath:indexPath];
    cell.model = self.packageSelectionBDataArr[indexPath.row];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 105.5 - 18)/3.00;
    return  CGSizeMake(width, 57);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PackageSelectionComboitemSetModel *model = self.packageSelectionBDataArr[indexPath.row];
    model.isSelect = !model.isSelect;
    
    [self.packageSelectionCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [self getPackagePayInfo];
}


#pragma mark -- 获取套餐付款信息
- (void)getPackagePayInfo{

    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"get";
    params[@"longitude"] = self.eliveryLocationLng;
    params[@"latitude"] = self.eliveryLocationLat;
    params[@"surveystation_id"] = self.surveystationIDStr;
    params[@"combo_id"] = self.packageABtn.selected ? self.comboAID : self.comboBID;
    
//    if (self.packageBBtn.selected) {
//        NSMutableArray *idStrArr = [NSMutableArray array];
//
//        for (PackageSelectionComboitemSetModel *model in self.packageSelectionBDataArr) {
//            if (model.isSelect) {
//                [idStrArr addObject:model.ID];
//            }
//        }
//        NSString *idStr = [idStrArr componentsJoinedByString:@","];
//         params[@"comboitem_list"] = idStr;
//    }
   


    kWeakSelf(weakSelf);
    [self.util postDataWithPath:@"/api/survey/survey_behalfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            weakSelf.payInfoView.hidden = NO;
            weakSelf.payInfoViewHeight.constant = 168;
            if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                NSString *base_price = [NSString stringWithFormat:@"¥%@",[obj valueForKey:@"base_price"]];
                NSString *combo_price = [NSString stringWithFormat:@"¥%@",[obj valueForKey:@"combo_price"]];
                NSString *survey_price = [NSString stringWithFormat:@"¥%@",[obj valueForKey:@"survey_price"]];
                NSString *total_price = [NSString stringWithFormat:@"¥%@",[obj valueForKey:@"total_price"]];
                self.basePriceLabel.text = base_price;
                self.comboPriceLabel.text = combo_price;
                self.surveyPriceLabel.text = survey_price;
                self.totalPriceLabel.text = total_price;
                
            }
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
        }else{
            
            weakSelf.payInfoView.hidden = YES;
            weakSelf.payInfoViewHeight.constant = 0;
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
            
        }
    }];
    
}

#pragma mark -- 年检须知
- (IBAction)annualInspectionNoticeBtnAction:(UIButton *)sender {
//TODO: 年检须知替换链接
    ConfirmAndCancelAlertWebView *alertView =[ConfirmAndCancelAlertWebView confirmAndCancelAlertWebViewWithTitle:@"年检须知" WebUrl:@"https://www.baidu.com" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"确定" ConfirmBtnTitleColor:[UIColor colorWithHexStringToRGB:@"3CADFF"] CancelBtnIsShow:NO CancelBtnTitle:@"" CancelBtnTitleColor:[UIColor colorWithHexStringToRGB:@"9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateConfirm) {
            
        }
        
    }];
    
}

- (void)dealloc{
    
}

@end
