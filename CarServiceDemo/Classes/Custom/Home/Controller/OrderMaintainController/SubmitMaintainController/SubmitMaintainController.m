//
//  SubmitMaintainController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "SubmitMaintainController.h"
#import "PaymentController.h"
#import "RepairShopInfoModel.h"
#import "CarModel.h"
#import "MyManager.h"
#import "MyCarportController.h"
#import "MapLocationSelectionAddressVC.h"
#import "MyOrderController.h"
#import "ReservationNoteInfoModel.h"

@interface SubmitMaintainController ()<MapLocationSelectionAddressVCDelegate>

@property (weak, nonatomic) IBOutlet UIView *addCarBackView;
@property (weak, nonatomic) IBOutlet UIView *carDetailView;

@property (weak, nonatomic) IBOutlet UIImageView *carImgeView;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;

@property (weak, nonatomic) IBOutlet UILabel *repairNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *repairAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *linkManLabel;
@property (weak, nonatomic) IBOutlet UITextField *linkPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UIButton *affirmPayButton;
@property (weak, nonatomic) IBOutlet UITextField *userLoactinTextField;
@property (weak, nonatomic) IBOutlet UIView *priceBackView;

@property (copy,nonatomic) NSString *eliveryLocationLat;
@property (copy,nonatomic) NSString *eliveryLocationLng;

@property (strong, nonatomic) CarModel *carModel;

///
@property (nonatomic ,strong)ReservationNoteInfoModel *noteInfoModel;
@end

@implementation SubmitMaintainController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadAllView];
    [self loadAllData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupInterFace];
}

- (void)loadAllView{
    
    self.title = @"提交预约";
    _affirmPayButton.cornerRadius = 4;
    
    _repairNameLabel.text = [NSString stringWithFormat:@"门店：%@",self.repairModel.name];
    _repairAddressLabel.text = [NSString stringWithFormat:@"地址：%@",self.repairModel.address];
    _priceLabel.text = self.price;
    if (_isMaintain) {
        _priceBackView.hidden = YES;
    }
    
    kWeakSelf(weakSelf)
    weakSelf.linkManLabel.text = self.user.name;
    weakSelf.linkPhoneLabel.text = self.user.phone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.linkManLabel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChange:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.linkPhoneLabel];
    
}

- (void)setupInterFace{
//    self.noteInfoModel = [ReservationNoteInfoModel noteInfo];
//    self.linkManLabel.text = self.noteInfoModel.name;
//    self.linkPhoneLabel.text = self.noteInfoModel.phone;
//    self.timeTextField.text = self.noteInfoModel.subscribe_time;
//    self.eliveryLocationLat = self.noteInfoModel.latitude;
//    self.eliveryLocationLng = self.noteInfoModel.longitude;
//    self.userLoactinTextField.text = self.noteInfoModel.address;
}

#pragma mark - ※※※※※※※※※※※※※※※※※※※※※※※※输入监听※※※※※※※※※※※※※※※※※※※※※※※※
- (void)textFieldTextDidChange:(NSNotification *)notification
{
    UITextField *textfield = [notification object];
    if (textfield == self.linkManLabel) {
        
        self.noteInfoModel.name = textfield.text;
    }else if (textfield == self.linkPhoneLabel) {
        self.noteInfoModel.phone = textfield.text;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    ///限制输入11位
    if (textField == self.linkPhoneLabel){
        if (textField.text.length>=11 && string.length>0) {
            return NO;
        }
    }
    
    return YES;
}

- (void)loadAllData{
    
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
        self.carDetailView.hidden = NO;
        self.addCarBackView.hidden = YES;
        
        if (!self.carModel.is_default) {
            self.defaultImageView.hidden = YES;
        }else{
            self.defaultImageView.hidden = NO;
        }
        
        [NetWorkingUtil setImage:self.carImgeView url:self.carModel.pic_url defaultIconName:KDefaultImage];
        self.carNumberLabel.text = self.carModel.code;
        NSString *time = @"";
        if (self.carModel.buy_time.length>4) {
            time = [self.carModel.buy_time substringToIndex:4];
        }
        self.carTypeLabel.text = self.carModel.brand_name;
        
    }else{
        self.carDetailView.hidden = YES;
        self.addCarBackView.hidden = NO;
    }
}

- (IBAction)selectTimeAction:(id)sender {
    kWeakSelf(weakSelf);
    //年-月-日
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *selectDate) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        //当前时间格式
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateTime=[formatter stringFromDate:[NSDate date]];
        NSDate *date = [formatter dateFromString:dateTime];
        NSComparisonResult result = [date compare:selectDate];
        if (result == NSOrderedDescending) {
            [MBProgressHUD showErrorOnView:weakSelf.view withMessage:@"预约时间不能小于当前时间"];
            return ;
        }
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        weakSelf.timeTextField.text = dateString;
        weakSelf.noteInfoModel.subscribe_time = [NSString stringWithFormat:@"%@",self.timeTextField.text];
    }];
    datepicker.dateLabelColor = [UIColor colorwithHexString:@"3CADFF"];;//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor colorwithHexString:@"3CADFF"];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor colorwithHexString:@"3CADFF"];;//确定按钮的颜色
    [datepicker show];
}

- (IBAction)affirmPayAction:(id)sender {
    if (!_carModel) {
        [MBProgressHUD showMessagOnView:self.view withMessage:@"请添加车辆信息"];
        return;
    }else if ([ValidateUtil isEmptyStr:self.linkManLabel.text]){
        [MBProgressHUD showMessagOnView:self.view withMessage:self.linkManLabel.placeholder];
        return;
    }else if (![ValidateUtil isTelphone:self.linkPhoneLabel.text]){
        [MBProgressHUD showMessagOnView:self.view withMessage:@"请输入正确的联系方式"];
        return;
    }
//    else if ([ValidateUtil isEmptyStr:self.timeTextField.text]) {
//        [MBProgressHUD showMessagOnView:self.view withMessage:self.timeTextField.placeholder];
//        return;
//    }
    else if ([ValidateUtil isEmptyStr:self.userLoactinTextField.text]) {
        [MBProgressHUD showMessagOnView:self.view withMessage:self.userLoactinTextField.placeholder];
        return;
    }
    
    if (_isMaintain) {
        
        self.maintainDictM[@"garage_id"] = self.repairModel.ID;
        self.maintainDictM[@"car_id"] = self.carModel.ID;
        self.maintainDictM[@"name"] = self.linkManLabel.text;
        self.maintainDictM[@"phone"] = self.linkPhoneLabel.text;
//        self.maintainDictM[@"subscribe_time"] = [NSString stringWithFormat:@"%@:00",self.timeTextField.text];
        self.maintainDictM[@"longitude"] = self.eliveryLocationLng;
        self.maintainDictM[@"latitude"] = self.eliveryLocationLat;
        self.maintainDictM[@"address"] = self.userLoactinTextField.text;
        
        kWeakSelf(weakSelf)
        [MyManager affirmPayMaintainOrderWithParams:self.maintainDictM isUpKeep:NO successBlock:^(NSString *result) {
            if (result) {
                weakSelf.noteInfoModel = [[ReservationNoteInfoModel alloc]init];
                MyOrderController *orderVC = [[MyOrderController alloc] init];
                orderVC.selectIndex = 0;
                orderVC.isBackRoot = YES;
                [weakSelf.navigationController pushViewController:orderVC animated:YES];
            }
        } failBlock:^(id error) {
            
        }];
        
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"garage_id"] = self.repairModel.ID;
        params[@"car_id"] = self.carModel.ID;
        params[@"name"] = self.linkManLabel.text;
        params[@"phone"] = self.linkPhoneLabel.text;
//        params[@"subscribe_time"] = [NSString stringWithFormat:@"%@:00",self.timeTextField.text];
        params[@"longitude"] = self.eliveryLocationLng;
        params[@"latitude"] = self.eliveryLocationLat;
        params[@"address"] = self.userLoactinTextField.text;
        params[@"oil_id_list"] = self.oilID;
        params[@"oil_amount_list"] = self.oilAmount;
        params[@"number"] = self.oilNumber;
        
        kWeakSelf(weakSelf)
        [MyManager affirmPayMaintainOrderWithParams:params isUpKeep:YES successBlock:^(NSString *result) {
            if (result) {
                [weakSelf.noteInfoModel clean];
                PaymentController *paymentVC = [[PaymentController alloc] init];
                paymentVC.orderID = result;
                paymentVC.payType = PayTypeUpKeepOrder;
                [weakSelf.navigationController pushViewController:paymentVC animated:YES];
            }
        } failBlock:^(id error) {
        }];
    }
}

- (IBAction)selectLoactionAction:(id)sender {
    MapLocationSelectionAddressVC *selectAddressVC = [[MapLocationSelectionAddressVC alloc]init];
    selectAddressVC.delegte = self;
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}

#pragma mark -- 选择交车地点地图回调
- (void)getSelectAddress:(NSString *)address Lat:(NSString *)lat lng:(NSString *)lng{
    self.userLoactinTextField.text = address;
    self.eliveryLocationLat = lat;
    self.eliveryLocationLng = lng;
    
    self.noteInfoModel.longitude = lng;
    self.noteInfoModel.latitude = lat;
    self.noteInfoModel.address = address;
}

- (IBAction)addCarAction:(id)sender {
    MyCarportController *carVC = [[MyCarportController alloc] init];
    carVC.isSelect = YES;
    [self.navigationController pushViewController:carVC animated:YES];
    kWeakSelf(weakSelf)
    carVC.selectMyCarBlock = ^(CarModel *carModel) {
        weakSelf.carModel = carModel;
        [weakSelf reloadCarView];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
