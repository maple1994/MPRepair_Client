//
//  PaymentController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "PaymentController.h"
#import "WXApi.h"
#import "PayManager.h"
#import "MallOrderController.h"
#import "MyOrderController.h"
#import "AnnualInspectionHistoryVC.h"
#import "AnnualInspectionNoteVC.h"
#import "AnnualInspectionSelfDrivingNoteVC.h"

typedef NS_ENUM(NSUInteger, PayStyle) {
    PayStyleNon,
    PayStyleWeiXIn,
    PayStyleZhiFuBao,
};

@interface PaymentController ()
@property (weak, nonatomic) IBOutlet UILabel *residueTImeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weixinBackHeight;
@property (weak, nonatomic) IBOutlet UIView *weixinBackView;
@property (weak, nonatomic) IBOutlet UIButton *weixinSelectButton;
@property (weak, nonatomic) IBOutlet UIView *zhifubaoBackView;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *affirmPayButton;

@property (strong,nonatomic) NSTimer *downTimer;
@property (strong,nonatomic) NSString *downTimeStr;

@property (assign, nonatomic) PayStyle payStyle;
@property (strong,nonatomic) NavigationController *nav;

@end

@implementation PaymentController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.downTimer) {
        [self.downTimer invalidate];
        self.downTimer = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!_isOredrDetail) {
        _nav.gobackBlock = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"支付订单";
    
    if([WXApi isWXAppInstalled])
    {
        NSLog(@"wechat is install");
    }else
    {
        _weixinBackView.hidden = YES;
        _weixinBackHeight.constant = 0;
    }
    
    _affirmPayButton.cornerRadius = 4;
    [_weixinSelectButton  setEnlargeEdge:20];
    [_zhifubaoSelectButton setEnlargeEdge:20];
    
    if (!_isOredrDetail) {
        _nav = (NavigationController*)self.navigationController;
        kWeakSelf(weakSelf)
        _nav.gobackBlock = ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        };
    }
}

- (void)loadAllData{
    
    kWeakSelf(weakSelf)
    [[PayManager sharedManager] getOrderDetailDataWithOrderID:self.orderID andPayType:self.payType successBlock:^(id obj) {
        PayModel *model = obj;
        weakSelf.downTimeStr = model.time;
        weakSelf.residueTImeLabel.text = [NSString stringWithFormat:@"支付剩余时间：%@",[weakSelf getMMSSFromSS:model.time]];
        weakSelf.payMoneyLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
        weakSelf.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.order_code];
        weakSelf.downTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(downTimerAction) userInfo:nil repeats:YES];
    } failBlock:^(BOOL result) {
        
    }];
    
}

- (void)downTimerAction{
    NSInteger time = [self.downTimeStr integerValue];
    if (time == 0) {
        if (self.downTimer) {
            [self.downTimer invalidate];
            self.downTimer = nil;
        }
        return;
    }
    time--;
    self.downTimeStr = [NSString stringWithFormat:@"%ld",time];
    self.residueTImeLabel.text = [NSString stringWithFormat:@"支付剩余时间：%@",[self getMMSSFromSS:self.downTimeStr]];
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

- (IBAction)weixinSelectButtonAction:(id)sender {
    _weixinSelectButton.selected = !_weixinSelectButton.selected;
    _zhifubaoSelectButton.selected = NO;
    if (_weixinSelectButton.selected) {
        self.payStyle = PayStyleWeiXIn;
    }else{
        self.payStyle = PayStyleNon;
    }
}

- (IBAction)zhifubaoSelectButtonAction:(id)sender {
    _zhifubaoSelectButton.selected = !_zhifubaoSelectButton.selected;
    _weixinSelectButton.selected = NO;
    if (_zhifubaoSelectButton.selected) {
        self.payStyle = PayStyleZhiFuBao;
    }else{
        self.payStyle = PayStyleNon;
    }
}

- (IBAction)affirmPayButtonAction:(id)sender {
    if (self.payStyle == PayStyleNon) {
        [MBProgressHUD showMessagOnView:self.view withMessage:@"请选择支付方式"];
        return;
    }
    kWeakSelf(weakSelf)
    if (self.payStyle == PayStyleWeiXIn) {
        [[PayManager sharedManager] payWithWeChatMethod:self.orderID andPayType:self.payType successBlock:^(BOOL result) {
            [weakSelf demandOrderPayStatus];
        } failBlock:^(BOOL result) {
            [weakSelf demandOrderPayStatus];
        }];
    }
    if (self.payStyle == PayStyleZhiFuBao) {
        [[PayManager sharedManager] payWithZhifubaoMethod:self.orderID andPayType:self.payType successBlock:^(BOOL result) {
            [weakSelf demandOrderPayStatus];
        } failBlock:^(BOOL result) {
            [weakSelf demandOrderPayStatus];
        }];
    }
}

- (void)demandOrderPayStatus{
    kWeakSelf(weakSelf)
    
    [[PayManager sharedManager] getOrderDetailDataWithOrderID:self.orderID andPayType:self.payType successBlock:^(id obj) {
        PayModel *model = obj;
        if (model.status==2) {
            [MBProgressHUD showSuccessOnView:kMAIN_WINDOW withMessage:@"支付成功"];
            [weakSelf pushOrderDetailVCWithOrderStatus:YES];
        }else{
            [MBProgressHUD showErrorOnView:kMAIN_WINDOW withMessage:@"支付失败"];
            [weakSelf pushOrderDetailVCWithOrderStatus:NO];
        }
        
    } failBlock:^(BOOL result) {
        [weakSelf pushOrderDetailVCWithOrderStatus:NO];
    }];
}

- (void)pushOrderDetailVCWithOrderStatus:(BOOL)flag{
    if (self.payType == PayTypeMallOrder) {
        MallOrderController *mallOrderVC = [[MallOrderController alloc] init];
        if (flag) {
            mallOrderVC.selectIndex = 1;
        }else{
            mallOrderVC.selectIndex = 0;
        }
        mallOrderVC.isBackRoot = YES;
        [self.navigationController pushViewController:mallOrderVC animated:YES];
    }else if(self.payType == PayTypeMaintainOrder || self.payType == PayTypeUpKeepOrder){
        MyOrderController *myOrderVC = [[MyOrderController alloc] init];
        if (flag) {
            myOrderVC.selectIndex = 2;
        }else{
            myOrderVC.selectIndex = 1;
        }
        myOrderVC.isBackRoot = YES;
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }else if (self.payType == PayTypeSelfSurvey || self.payType == PayTypeReplaceSurvey){
        if (flag) {
            AnnualInspectionHistoryVC *historyVC = [[AnnualInspectionHistoryVC alloc]init];
            historyVC.isBackRoot = YES;
            [self.navigationController pushViewController:historyVC animated:YES];
        }else {
            for (UIViewController *tempVC in self.navigationController.viewControllers) {
                if ([tempVC isKindOfClass:[AnnualInspectionNoteVC class]]||[tempVC isKindOfClass:[AnnualInspectionSelfDrivingNoteVC class]]) {
                    [self.navigationController popToViewController:tempVC animated:YES];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
