//
//  AnnualInspectionOrderDetailsVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionOrderDetailsVC.h"
#import "OrderEvaluateView.h"

@interface AnnualInspectionOrderDetailsVC ()
//  状态相关view
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView1;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView2;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView3;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView4;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel4;

/// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
/// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/// 电话
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
/// 时间状态标题
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
/// 时间
@property (weak, nonatomic) IBOutlet UITextField *timeLabel;

/// 开始年检相关view
@property (weak, nonatomic) IBOutlet UIView *orderDetailsStatusStartAnnualInspectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderDetailsStatusStartAnnualInspectionViewHeight;

/// 检完还车相关view
@property (weak, nonatomic) IBOutlet UIView *orderDetailsStatusPickUpTheCarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderDetailsStatusPickUpTheCarViewHeight;

@property (weak, nonatomic) IBOutlet UIView *orderStatusShowLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;


@end

@implementation AnnualInspectionOrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupProperty];
    
    [self setupInterFace];
    
}

#pragma mark -- 初始化属性
- (void)setupProperty{
    
    self.title = @"年检信息";
    [self.headerImageView setCornerRadius:(self.headerImageView.width*0.5)];
    [self.confirmBtn setCornerRadius:4];
  
}

#pragma mark -- 初始化页面
- (void)setupInterFace{
    //代驾取车：0:等待支付，1:等待接单，2:等待取车 开始年检：3.等待年检，4.正在年检，5.年检结束， 检完还车：6.到达还车，7.已还车，8.已完成
    NSInteger state = self.dataModel.state.integerValue;
    if (state == 2) {
        self.orderStatus = OrderDetailsStatusPickUpTheCar;
    }else if (state == 3 || state == 4 || state == 5) {
        self.orderStatus = OrderDetailsStatusStartAnnualInspection;
    }else if (state == 6 || state == 7) {
        self.orderStatus = OrderDetailsStatusStartAnnualInspectionAndReturn;
    }
    
    [self setupPublicData];
    
    [self setupStatusAboultWithStatus:self.orderStatus];

}


- (void)setupPublicData{
    
    [NetWorkingUtil setImage:self.headerImageView url:self.dataModel.driver_user_pic_url defaultIconName:KDefaultImage];
    self.nameLabel.text = self.dataModel.driver_user_name;
    self.mobileTF.text = self.dataModel.phone;
    for (int i = 0 ; i < 5; i++) {
        UIImageView *imageView = [self.view viewWithTag:100+i];
        if (i < self.dataModel.drive_user_score.integerValue) {
            
            imageView.hidden = NO;
            
        }else{
            
            imageView.hidden = YES;
        }
        
    }
    //代驾取车：0:等待支付，1:等待接单，2:等待取车 开始年检：3.等待年检，4.正在年检，5.年检结束， 检完还车：6.到达还车，7.已还车，8.已完成
    
    
    
}

- (void)setupStatusAboultWithStatus:(OrderDetailsStatus)status{
    
    self.statusLabel1.textColor = [UIColor colorwithHexString:@"A3A3A3"];
    self.statusLabel2.textColor = [UIColor colorwithHexString:@"A3A3A3"];
    self.statusLabel3.textColor = [UIColor colorwithHexString:@"A3A3A3"];
    self.statusLabel4.textColor = [UIColor colorwithHexString:@"A3A3A3"];
    self.statusImageView1.image = [UIImage imageNamed:@"annualInspection_status_note"];
    self.statusImageView2.image = [UIImage imageNamed:@"annualInspection_daijiaoquche"];
    self.statusImageView3.image = [UIImage imageNamed:@"annualInspection_status_start"];
    self.statusImageView4.image = [UIImage imageNamed:@"annualInspection_status_guihai"];
    self.orderDetailsStatusStartAnnualInspectionView.hidden = YES;
    self.orderDetailsStatusStartAnnualInspectionViewHeight.constant = 0;
    self.orderDetailsStatusPickUpTheCarView.hidden = YES;
    self.orderDetailsStatusPickUpTheCarViewHeight.constant = 0;

//    if (status == OrderDetailsStatusNote) {
//
//        self.statusLabel1.textColor = DefaultBlueColor;
//        self.statusImageView1.image = [UIImage imageNamed:@"annualInspection_status_note_sel"];
//    }else
        if (status == OrderDetailsStatusPickUpTheCar){
        
        self.statusLabel2.textColor = DefaultBlueColor;
        self.statusImageView2.image = [UIImage imageNamed:@"annualInspection_daijiaoquche_sel"];
        self.timeTitleLabel.text = @"取车时间";
        self.timeLabel.text = self.dataModel.get_time;
    }else if (status == OrderDetailsStatusStartAnnualInspection){
        
        self.statusLabel3.textColor = DefaultBlueColor;
        self.statusImageView3.image = [UIImage imageNamed:@"annualInspection_status_start_sel"];
        self.orderDetailsStatusStartAnnualInspectionView.hidden = NO;
        self.orderDetailsStatusStartAnnualInspectionViewHeight.constant = 63;
        self.timeTitleLabel.text = @"到站年检时间";
        self.timeLabel.text = self.dataModel.arrive_survey_time;

    }else if (status == OrderDetailsStatusStartAnnualInspectionAndReturn){
        
        self.statusLabel4.textColor = DefaultBlueColor;
        self.statusImageView4.image = [UIImage imageNamed:@"annualInspection_status_guihai_sel"];
        
        
        if (self.dataModel.state.integerValue == 7) {//7.已还车
            self.orderDetailsStatusPickUpTheCarView.hidden = NO;
            self.orderDetailsStatusPickUpTheCarViewHeight.constant = 163;
        }
        self.timeLabel.text = self.dataModel.return_time;
        self.timeTitleLabel.text = @"还车时间";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 年检须知按钮事件
- (IBAction)annualInspectionNoticeBtnAction:(id)sender {
    QMWebViewVC *webVC = [[QMWebViewVC alloc]init];
    webVC.title = @"年检须知";
    webVC.urlStr = @"https:www.baidu.com";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark -- 确认支付按钮事件
- (IBAction)confirmPayBtnAction:(UIButton *)sender {
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.dataModel.ID;
    params[@"method"] = @"return";

    kWeakSelf(weakSelf);
    
    [self.util postDataWithPath:@"/api/survey/survey_behalfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];
            
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
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
                    }
                }];
            };
            evaluateView.cancelBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [self.view.window addSubview:evaluateView];
            

        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];

}



@end
