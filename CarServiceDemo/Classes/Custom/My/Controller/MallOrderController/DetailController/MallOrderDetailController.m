//
//  MallOrderDetailController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MallOrderDetailController.h"
#import "MallOrderTableCell.h"
#import "MallOrderModel.h"
#import "OrderManager.h"
#import "OrderEvaluateView.h"
#import "PaymentController.h"
#import "OrderlogisticsModel.h"

@interface MallOrderDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *receiveNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsLabel;
@property (weak, nonatomic) IBOutlet UILabel *logisticsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reallyPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverTImeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reciiveTimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBackHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *detailCellID = @"MallOrderTableCell";

@implementation MallOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"订单详情";
    self.view.backgroundColor =  [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    _receiveNameLabel.text = self.orderModel.name;
    _receiveAddressLabel.text = self.orderModel.address;
//    _logisticsLabel.text = self.orderModel.logistics_info;
//    _logisticsTimeLabel.text = self.orderModel.
    _allPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.orderModel.all_price];
    _codeLabel.text = self.orderModel.point_price;
    _reallyPriceLabel.text = [NSString stringWithFormat:@"￥%@",self.orderModel.now_price];
    
    _orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.orderModel.order_code];
    _createTimeLabel.text = [NSString stringWithFormat:@"创建时间：%@",self.orderModel.create_time];
    _payTimeLabel.text = [NSString stringWithFormat:@"付款时间：%@",self.orderModel.wait_time];
    _deliverTImeLabel.text = [NSString stringWithFormat:@"发货时间：%@",self.orderModel.send_time];
    _reciiveTimeLabel.text = [NSString stringWithFormat:@"收货时间：%@",self.orderModel.receive_time];
    
    if ( self.orderModel.status == MallOrderStateWaitPay) {
        [_firstButton setTitle:@"去付款" forState:UIControlStateNormal];
    }else if ( self.orderModel.status == MallOrderStateWaitDeliver) {
        [_firstButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }else if ( self.orderModel.status == MallOrderStateWaitReceive) {
        [_firstButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if ( self.orderModel.status == MallOrderStateSuccess){
        if (! self.orderModel.is_comment) {
            [_firstButton setTitle:@"评价" forState:UIControlStateNormal];
        }else{
            [_firstButton setTitle:@"已评价" forState:UIControlStateNormal];
        }
    }
    
    _tableBackHeight.constant = 105*self.orderModel.orderproduct_set.count;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MallOrderTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
}

- (void)loadAllData{
    kWeakSelf(weakSelf)

    [OrderManager getOrderLogisticsDataWithID:self.orderModel.ID successBlock:^(id obj) {
        OrderlogisticsModel *model = obj;
        weakSelf.logisticsLabel.text = model.status;
        weakSelf.logisticsTimeLabel.text = model.time;
    } failBlock:^(id error) {
    }];
    
    [OrderManager getMallOrderListDataWithID:self.orderModel.ID successBlock:^(id obj) {
        weakSelf.orderModel = obj;
        [weakSelf loadAllView];
    } failBlock:^(id error) {
    }];
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *listArr = self.orderModel.orderproduct_set;
    return listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MallOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ProductListModel *model = self.orderModel.orderproduct_set[indexPath.row];
    
    [NetWorkingUtil setImage:cell.orderImageView url:model.product.pic_url  defaultIconName:KDefaultImage];
    cell.orderTitleLabel.text = model.product.name;
    cell.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.product.price];
    cell.orderNumLabel.text = [NSString stringWithFormat:@"X%@",model.amount];
    cell.orderStateLabel.hidden = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (IBAction)firstButtonAction:(id)sender {
    if (self.orderModel.status == MallOrderStateWaitPay) {
        PaymentController *paymentVC = [[PaymentController alloc] init];
        paymentVC.orderID = self.orderModel.ID;
        paymentVC.payType = PayTypeMallOrder;
        paymentVC.isOredrDetail = YES;
        [self.navigationController pushViewController:paymentVC animated:YES];
    }else if (self.orderModel.status == MallOrderStateWaitDeliver) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",kServiceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (self.orderModel.status== MallOrderStateWaitReceive) {
        kWeakSelf(weakSelf)
        [OrderManager commitUserStarToOrderWithStar:nil andID:self.orderModel.ID andMethod:@"finish" successBlock:^(id obj) {
            [weakSelf orderChangeAction];
        } failBlock:^(id error) {
        }];
    }else if (self.orderModel.status == MallOrderStateSuccess){
        if (!self.orderModel.is_comment) {
            OrderEvaluateView *evaluateView = [[OrderEvaluateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            kWeakSelf(weakSelf)
            __weak __typeof(&*evaluateView)weakEvaluate= evaluateView;
            evaluateView.affirmBlock = ^(NSString *star) {
                [OrderManager commitUserStarToOrderWithStar:star  andID:weakSelf.orderModel.ID andMethod:@"comment" successBlock:^(id result) {
                    if (result) {
                        [weakEvaluate removeFromSuperview];
                        [weakSelf orderChangeAction];
                    }
                } failBlock:^(id error) {
                }];
            };
            [self.view.window addSubview:evaluateView];
        }
    }
}

- (IBAction)deleteButtonAction:(id)sender {
    kWeakSelf(weakSelf)
    [ConfirmAndCancelWithTitleImageAlertView confirmAndCancelWithTitleImageAlertViewWithTitle:@"确定要删除订单吗?" ImageName:@"deleteOrder" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"再考虑下" ConfirmBtnTitleColor:[UIColor colorwithHexString:@"#3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"确认" CancelBtnTitleColor:[UIColor colorwithHexString:@"#9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateCancel) {
            [OrderManager deleteUserMallOrderWIthID:weakSelf.orderModel.ID successBlock:^(id obj) {
                [weakSelf orderChangeAction];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } failBlock:^(id error) {
            }];
        }
    }];
}

- (void)orderChangeAction{
    [self loadAllData];
    if (self.orderChangeBlock) {
        self.orderChangeBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
