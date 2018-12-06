//
//  AnnualInspectionOrderDetailsInfoVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/22.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionOrderDetailsInfoVC.h"
#import "OrderEvaluateView.h"
#import "PaymentController.h"
#import "AnnualInspectionComplaintVC.h"

@interface AnnualInspectionOrderDetailsInfoVC ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Height;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Height;

@property (weak, nonatomic) IBOutlet UIButton *affirmPayButton;

@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *complaintBtnHeight;

@end

@implementation AnnualInspectionOrderDetailsInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"年检详情";
    
    [self setupProperty];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.dataModel.state isEqualToString:@"8"]) {
        if (self.dataModel.is_feedback) {
            [self.complaintBtn setTitle:@"已投诉" forState:UIControlStateNormal];
        }else{
            [self.complaintBtn setTitle:@"投诉" forState:UIControlStateNormal];
        }
        [self.complaintBtn setHidden:NO];
    }else {
        [self.complaintBtn setHidden:YES];
    }
}

- (void)confirmBtnAction{
    kWeakSelf(weakSelf);
    
    [ConfirmAndCancelAlertWebView confirmAndCancelAlertWebViewWithTitle:@"扣费标准" WebUrl:@"http://www.nolasthope.cn/survey/surveyinfo/" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"确认取消" ConfirmBtnTitleColor:[UIColor colorWithHexStringToRGB:@"3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"我再想想" CancelBtnTitleColor:[UIColor colorWithHexStringToRGB:@"9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateConfirm) {
            
            [MBProgressHUD showStatusOnView:weakSelf.view withMessage:LoadingMsg];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"id"] = weakSelf.dataModel.ID;
            params[@"method"] = @"cancel";
            
            kWeakSelf(weakSelf);
            
            [weakSelf.util postDataWithPath:@"/api/survey/survey_behalfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
                if (status == 1) {
                    
                    [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
                }
            }];
            
        }else{
            
        }
        
    }];
    
    
    
    
    
}

- (void)setupProperty{
    
    if ([self.dataModel.state isEqualToString:@"0"]) {
        _affirmPayButton.cornerRadius = 4;
        _affirmPayButton.hidden = NO;
    }
    
    self.label1.text = [NSString stringWithFormat:@"品牌型号：%@",self.dataModel.car_brand];
    self.label2.text = [NSString stringWithFormat:@"号码号牌：%@",self.dataModel.car_code];
    self.label3.text = [NSString stringWithFormat:@"预约时间：%@",self.dataModel.subscribe_time];
    self.label4.text = [NSString stringWithFormat:@"完成时间：%@",self.dataModel.state.integerValue == 8 ? self.dataModel.confirm_time : @"未完成"];
    self.label5.text = [NSString stringWithFormat:@"车辆类型：%@",self.dataModel.car_type];
    self.label6.text = [NSString stringWithFormat:@"年检类型：%@",self.dataModel.is_self.boolValue ? @"自驾年检" : @"代驾年检"];
    self.label7.text = [NSString stringWithFormat:@"年检站点：%@",self.dataModel.surveystation.name];
    self.label8.text = [NSString stringWithFormat:@"订单单号：%@",self.dataModel.ID];
    if (self.dataModel.get_confirm.obj_list.count > 0) {
        obj_list *get_confirmImageModel = self.dataModel.get_confirm.obj_list[0];
        self.titleLabel1.text = self.dataModel.get_confirm.name;
        [NetWorkingUtil setImage:self.imageView1 url:get_confirmImageModel.pic_url defaultIconName:KDefaultImage];
    }
    
    self.titleLabel2.text = self.dataModel.get_car.name;
    if (self.dataModel.get_car.obj_list.count > 0) {
        obj_list *get_carImageModel = self.dataModel.get_car.obj_list[0];
        [NetWorkingUtil setImage:self.imageView2 url:get_carImageModel.pic_url defaultIconName:KDefaultImage];
    }
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.02f",self.dataModel.total_price.floatValue];
    
    
    if ([self.dataModel.state isEqualToString:@"8"]) {
        self.view1.hidden = NO;
        self.view1Height.constant = 224;
        self.view2.hidden = NO;
        self.view2Height.constant = 224;
        self.stateLabel.text = @"已通过";
        self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"5FFF54"];
        
        
        
    }else{
        
        if([self.dataModel.state isEqualToString:@"1"] || [self.dataModel.state isEqualToString:@"0"]){
            UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
            [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            rightBtn.titleLabel.textColor =[UIColor whiteColor];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [rightBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
            rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        }
        
        self.view1.hidden = YES;
        self.view1Height.constant = 0;
        self.view2.hidden = YES;
        self.view2Height.constant = 0;
        self.stateLabel.text = @"未通过";
        self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF3C3C"];
        
    }
    
    if ([self.dataModel.is_comment isEqualToString:@"0"]) {
        if ([self.dataModel.state isEqualToString:@"8"]) {
            UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 80, 30)];
            rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            if ([self.dataModel.is_comment isEqualToString:@"0"]) {
                [rightButton setTitle:@"评价" forState:UIControlStateNormal];
            }else if ([self.dataModel.is_comment isEqualToString:@"1"]) {
                [rightButton setTitle:@"已评价" forState:UIControlStateNormal];
            }
            
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightButton.titleLabel.font = kFontSize(14);
            [rightButton addTarget:self action:@selector(takeEvaluateAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem=rightitem;
        }
    }
    
    
    if([self.dataModel.state isEqualToString:@"0"] || [self.dataModel.state isEqualToString:@"1"]){
        UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        rightBtn.titleLabel.textColor =[UIColor whiteColor];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    }
    [self.complaintBtn setCornerRadius:14];
    self.complaintBtn.layer.borderColor = [UIColor colorWithHexStringToRGB:@"3CADFF"].CGColor;
    self.complaintBtn.layer.borderWidth = .5;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelBtnAction{
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.dataModel.ID;
    params[@"method"] = @"cancel";
    
    kWeakSelf(weakSelf);
    
    [self.util postDataWithPath:@"/api/survey/survey_behalfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
}

- (void)takeEvaluateAction{
     if ([self.dataModel.is_comment isEqualToString:@"1"]) {
        return;
    }
    //评价
    OrderEvaluateView *evaluateView = [[OrderEvaluateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    __weak __typeof(&*evaluateView)weakEvaluate= evaluateView;
    kWeakSelf(weakSelf)
    evaluateView.affirmBlock = ^(NSString *star) {
        
        [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = self.dataModel.ID;
        params[@"method"] = @"comment";
        params[@"score"] = star;
        
        [[NetWorkingUtil netWorkingUtil] postDataWithPath:@"/api/survey/survey_behalfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
            
            if (status == 1) {
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withsuccess:@"评价成功"];
                
                [weakEvaluate removeFromSuperview];
                if (weakSelf.changeBlock) {
                    weakSelf.changeBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }else{
                [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            }
        }];
    };
    [self.view.window addSubview:evaluateView];
}


- (IBAction)affirmPayButtonAction:(id)sender {
    PaymentController *paymentVC = [[PaymentController alloc] init];
    paymentVC.orderID = self.dataModel.ID;
    paymentVC.payType = PayTypeReplaceSurvey;
    [self.navigationController pushViewController:paymentVC animated:YES];
}

- (IBAction)complaintBtnAction:(UIButton *)sender {
    if (self.dataModel.is_feedback) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"您已投诉!"];
    }else{
        AnnualInspectionComplaintVC *complaintVC = [[AnnualInspectionComplaintVC alloc]init];
    complaintVC.dataModel = self.dataModel;
        [self.navigationController pushViewController:complaintVC animated:YES];
    }
    
}


@end
