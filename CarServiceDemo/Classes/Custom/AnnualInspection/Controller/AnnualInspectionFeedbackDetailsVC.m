//
//  AnnualInspectionFeedbackDetailsVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionFeedbackDetailsVC.h"
#import "AnnualInspectionFeedbackDetailsTableViewCell.h"
#import "AnnualInspectionFeedbackDetailsTableHeaderView.h"
#import "PaymentController.h"

@interface AnnualInspectionFeedbackDetailsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

///
//@property (nonatomic ,strong)surveypic_list *listModel;

@end

static NSString *AnnualInspectionFeedbackDetailsTableViewCellID = @"AnnualInspectionFeedbackDetailsTableViewCell";

@implementation AnnualInspectionFeedbackDetailsVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupProperty];
    
}

- (void)setupProperty{
    self.title = @"年检反馈";
    
    
    [self.tableView registerNib:[UINib nibWithNibName:AnnualInspectionFeedbackDetailsTableViewCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:AnnualInspectionFeedbackDetailsTableViewCellID];
    
//    for (surveypic_list *listM in self.dataModel.surveypic_list) {
//        if ([listM.type isEqualToString:@"survey_upload"]) {
//            self.listModel = listM;
//        }
//    }
    

    [self.tableView reloadData];
    
    if([self.dataModel.state isEqualToString:@"2"]){
        UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        rightBtn.titleLabel.textColor =[UIColor whiteColor];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataModel.survey_fail_upload) {
//        failure_object *model = self.dataModel.failure_list[0];
//        return self.dataModel.survey_fail_upload.count;
        return 1;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnualInspectionFeedbackDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AnnualInspectionFeedbackDetailsTableViewCellID];
    image_list *model = self.dataModel.survey_fail_upload;
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 207;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    kWeakSelf(weakSelf);
    AnnualInspectionFeedbackDetailsTableHeaderView *headView = [AnnualInspectionFeedbackDetailsTableHeaderView annualInspectionFeedbackDetailsTableHeaderViewCompleted:^{
        [weakSelf confirmPay];
    }];
    headView.dataModel = self.dataModel;
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 260);
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    failure_object *model = self.dataModel.failure_list[0];
    CGFloat height= 40*(model.failureitem_list.count+1);
    return 184 + height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (IBAction)annualInspectionNoticeBtnAction:(id)sender {
    QMWebViewVC *webVC = [[QMWebViewVC alloc]init];
    webVC.title = @"年检须知";
    webVC.urlStr = @"https:www.baidu.com";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark -- 确认支付按钮事件
- (void)confirmPay{
    
    PaymentController *paymentVC = [[PaymentController alloc] init];
    paymentVC.orderID = self.dataModel.ID;
    paymentVC.payType = PayTypeReplaceSurvey;
    [self.navigationController pushViewController:paymentVC animated:YES];
    
//    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"id"] = self.dataModel.ID;
//    params[@"method"] = @"failure_pay";
//
//    kWeakSelf(weakSelf);
//
//    [self.util postDataWithPath:@"/api/survey/survey_behalfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
//        if (status == 1) {
//
//            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];
//
////            [weakSelf.navigationController popViewControllerAnimated:YES];
//
//        }else{
//
//            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
//        }
//    }];
    
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

@end
