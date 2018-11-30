//
//  AnnualInspectionNoteVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionSelfDrivingNoteVC.h"
#import "PaymentController.h"
#import "AnnualInspectionStationInfoModel.h"
#import "AnnualInspectionSelfDrivingStartVC.h"
#import "AnnualInspectionNoteInfoModel.h"
#import "CarModel.h"
#import "MyManager.h"

@interface AnnualInspectionSelfDrivingNoteVC () <UniversalSelectionBoxViewDelegate,UITextFieldDelegate>

/// 联系人
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
/// 联系人电话
@property (weak, nonatomic) IBOutlet UITextField *mobiTF;

@property (weak, nonatomic) IBOutlet UITextField *ownerNameTF;
/// 车主身份证号码
/// 品牌型号
@property (weak, nonatomic) IBOutlet UITextField *ownerBrandModelNumberTF;
/// 号码号牌
@property (weak, nonatomic) IBOutlet UITextField *ownerCarNumberTF;
/// 车辆类型
@property (weak, nonatomic) IBOutlet UILabel *ownerCarBrandLabel;

/// 年检站
@property (weak, nonatomic) IBOutlet UILabel *annualInspectionStationLabel;
/// 年检站信息arr
@property (nonatomic ,strong)NSMutableArray *annualInspectionStationDataArr;


/// 选择车型view
@property (nonatomic ,strong)UniversalSelectionBoxView *carTypeSelectBoxView;

/// 选择维修站点view
@property (nonatomic ,strong)UniversalSelectionBoxView *selectAnnualInspectionStationBoxView;

// 选择预约时间按钮
@property (weak, nonatomic) IBOutlet UIButton *selectTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectTimeLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *identityInformaitonBtns;

/// 选择的年检站id
@property (nonatomic ,copy)NSString *surveystationIDStr;
/// 套餐id

@property (weak, nonatomic) IBOutlet UIView *payInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payInfoViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

/// 数据存储使用
@property (nonatomic ,strong)AnnualInspectionNoteInfoModel *noteInfoModel;

@property (strong, nonatomic) CarModel *carModel;
@end


@implementation AnnualInspectionSelfDrivingNoteVC

#pragma mark -- 懒加载
- (NSMutableArray *)annualInspectionStationDataArr{
    
    if (!_annualInspectionStationDataArr) {
        _annualInspectionStationDataArr =[NSMutableArray array];
    }
    return _annualInspectionStationDataArr;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    /// 初始化属性
    [self setupProperty];
    
    [self loadCarData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupInterface];
}


#pragma mark -- 初始化属性
- (void)setupProperty{
    self.title = @"填写信息";
    
    for (UIButton *btn in self.identityInformaitonBtns) {
//        btn.layer.borderColor = [UIColor colorwithHexString:@"A3A3A3"].CGColor;
//        btn.layer.borderWidth = 1;
        [btn setCornerRadius:2];

    }
    
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
    
    self.ownerNameTF.text = self.noteInfoModel.name;
    self.ownerBrandModelNumberTF.text = self.noteInfoModel.car_brand;
    self.ownerCarNumberTF.text = self.noteInfoModel.car_code;
    
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
        [self getPackagePayInfo];

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
- (IBAction)selectAppointmentTimeBtnAction:(UIButton *)sender {
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

- (IBAction)tipsAction:(UIButton *)sender {
    [ConfirmAndCancelAlertWebView confirmAndCancelAlertWebViewWithTitle:@"年检须知" WebUrl:@"http://www.nolasthope.cn/survey/surveyinfo/" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"确定" ConfirmBtnTitleColor:[UIColor colorWithHexStringToRGB:@"3CADFF"] CancelBtnIsShow:NO CancelBtnTitle:@"" CancelBtnTitleColor:[UIColor colorWithHexStringToRGB:@"9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateConfirm) {
            
        }
        
    }];
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
    
    
    
    if([ValidateUtil isEmptyStr:self.selectTimeLabel.text] || [self.selectTimeLabel.text isEqualToString:@"请选择预约时间"]){
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择预约时间"];
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

    params[@"subscribe_time"] = self.selectTimeLabel.text;
    params[@"is_self"] = @"1";
    
    
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    [self.util postDataWithPath:@"/api/survey/survey/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            [weakSelf.noteInfoModel clean];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
            PaymentController *paymentVC = [[PaymentController alloc] init];
            paymentVC.orderID = [NSString stringWithFormat:@"%ld",[obj[@"id"] integerValue]];
            paymentVC.payType = PayTypeSelfSurvey;
            [weakSelf.navigationController pushViewController:paymentVC animated:YES];
        }else{

            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
    
    
}



#pragma mark -- 获取套餐付款信息
- (void)getPackagePayInfo{

    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"method"] = @"get";
    params[@"surveystation_id"] = self.surveystationIDStr;

    kWeakSelf(weakSelf);
    [self.util postDataWithPath:@"/api/survey/survey_selfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            weakSelf.payInfoView.hidden = NO;
            weakSelf.payInfoViewHeight.constant = 42;
            if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                NSString *total_price = [NSString stringWithFormat:@"%@",[obj valueForKey:@"total_price"]];
                self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.02f",[total_price floatValue]];
            }
            [MBProgressHUD dismissHUDForView:weakSelf.view];

        }else{

            weakSelf.payInfoView.hidden = YES;
            weakSelf.payInfoViewHeight.constant = 0;
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];

        }
    }];

}




@end
