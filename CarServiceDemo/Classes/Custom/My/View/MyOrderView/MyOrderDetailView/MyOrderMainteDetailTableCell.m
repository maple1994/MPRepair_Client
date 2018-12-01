//
//  MyOrderMainteDetailTableCell.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderMainteDetailTableCell.h"
#import "MyMaintainModel.h"
#import "OrderManager.h"
#import "PaymentController.h"
#import "OrderEvaluateView.h"
#import <MapKit/MapKit.h>
#import "MyOrderProjectTableCell.h"
#import "ImageObjectModel.h"
#import "MaintenanceListView.h"

@interface MyOrderMainteDetailTableCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *maintenanceShopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serveProjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UITableView *projectTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectTableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;

@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIView *imageArea;

@end

static NSString *detailCellID = @"MyOrderProjectTableCell";

@implementation MyOrderMainteDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.projectTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderProjectTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
}

- (void)setMaintainModel:(MyMaintainModel *)maintainModel{
    _maintainModel = maintainModel;
    
    NSArray *arr = [NSArray array];
    if (self.maintainModel.maintainitem_set_now.count==0) {
        arr = self.maintainModel.maintainitem_set;
    }else{
        arr = self.maintainModel.maintainitem_set_now;
    }
    _backHeight.constant = 88+arr.count*32;
    self.projectTableHeight.constant = arr.count*32;
    [self.projectTableView reloadData];
    
    if (_maintainModel.state == MaintainTypeWaitPay) {
        _changeButton.hidden = NO;
        if(self.maintainModel.maintainitem_set_now.count==0) {
            [self changProjectActionWithFlag:NO];
        }
    }else{
        _changeButton.hidden = YES;
    }
    
    _typeImageView.image = [UIImage imageNamed:@"order_noPay"];
    _maintenanceShopTitleLabel.text = _maintainModel.garage.name;
    if (_maintainModel.state == MaintainTypeWaitReceived) {
        self.stateLabel.text = @"等待接单";
        self.stateLabel.textColor = [UIColor colorwithHexString:@"#5FFF54"];
        [_firstButton setTitle:@"取消订单" forState:UIControlStateNormal];
        _secondButton.hidden = YES;
    }else if (_maintainModel.state == MaintainTypeWaitPay) {
        _stateLabel.text = @"未支付";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
        [_firstButton setTitle:@"去付款" forState:UIControlStateNormal];
    }else if (_maintainModel.state == MaintainTypeHasReceived) {
        _stateLabel.text = @"已接单";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
        [_firstButton setTitle:@"导航" forState:UIControlStateNormal];
    }else if (_maintainModel.state == MaintainTypeWaitService) {
        _stateLabel.text = @"待服务";
        [_firstButton setTitle:@"导航" forState:UIControlStateNormal];
    }else if (_maintainModel.state == MaintainTypeServiceNow) {
        _stateLabel.text = @"服务中";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#5FFF54"];
        [_firstButton setTitle:@"取消订单" forState:UIControlStateNormal];
        _secondButton.hidden = YES;
    }else if (_maintainModel.state == MaintainTypeSuccess) {
        _stateLabel.text = @"完成服务";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#FF8A4E"];
        if (!_maintainModel.is_comment) {
            [_firstButton setTitle:@"评价" forState:UIControlStateNormal];
        }else{
            [_firstButton setTitle:@"已评价" forState:UIControlStateNormal];
        }
        _secondButton.hidden = YES;
    }
    
    _allPriceLabel.text = [NSString stringWithFormat:@"￥%@",_maintainModel.now_price];
    
    _serveProjectLabel.text = [NSString stringWithFormat:@"服务项目：%@",_maintainModel.service_item];
    _appointmentTimeLabel.text = [NSString stringWithFormat:@"预约时间：%@",_maintainModel.create_time];
    _carTypeLabel.text = [NSString stringWithFormat:@"车辆型号：%@",_maintainModel.car_type];
    _carNumberLabel.text = [NSString stringWithFormat:@"车辆号码：%@",_maintainModel.car_code];
    
    //    _orderTypeLabel.text = [NSString stringWithFormat:@"订单类型：%@",_maintainModel.service_materials];
    _payNumberLabel.text = [NSString stringWithFormat:@"交易单号：%@",_maintainModel.deal_id];
    _orderNumberLabel.text = [NSString stringWithFormat:@"订单单号：%@",_maintainModel.order_id];
    _imageArea.hidden = (arr.count == 0);
}

- (IBAction)deleteButtonAction:(id)sender {
    kWeakSelf(weakSelf)
    BOOL isUpKeep = NO;
    
    NSString *orderID = @"";
    if (isUpKeep) {
//        orderID = _upkeepModel.ID;
    }else{
        orderID = _maintainModel.ID;
    }
    
    [ConfirmAndCancelWithTitleImageAlertView confirmAndCancelWithTitleImageAlertViewWithTitle:@"确定要取消订单吗?" ImageName:@"deleteOrder" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"再考虑下" ConfirmBtnTitleColor:[UIColor colorwithHexString:@"#3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"确认" CancelBtnTitleColor:[UIColor colorwithHexString:@"#9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateCancel) {
            [OrderManager deleteUpkeepMraintainOrderIsUpKeep:isUpKeep andID:orderID successBlock:^(id obj) {
                [weakSelf blockAction:YES];
            } failBlock:^(id error) {
            }];
        }
    }];
    
}

- (void)blockAction:(BOOL)isFlag{
    if (self.orderChangeBlock) {
        self.orderChangeBlock(isFlag);
    }
}

- (IBAction)firstButtonAction:(id)sender {
    BOOL isUpKeep = NO;
    
    if (_maintainModel.state == MaintainTypeWaitPay) {
        PaymentController *paymentVC = [[PaymentController alloc] init];
        paymentVC.orderID = self.maintainModel.ID;
        paymentVC.payType = PayTypeMaintainOrder;
        paymentVC.isOredrDetail = YES;
        [self.viewController.navigationController pushViewController:paymentVC animated:YES];
    }else if (_maintainModel.state == MaintainTypeHasReceived||_maintainModel.state == MaintainTypeWaitService){
        
        NSString *latitude = @"";
        NSString *longitude = @"";
        NSString *name = @"";
        if (isUpKeep) {
//            latitude = _upkeepModel.latitude;
//            longitude = _upkeepModel.longitude;
//            name = _upkeepModel.name;
        }else{
            latitude = _maintainModel.latitude;
            longitude = _maintainModel.longitude;
            name = _maintainModel.name;
        }
        double longtitude1 = [UserInfo userInfo].longtitude;
        double latitude1 = [UserInfo userInfo].latitude;
        [MPUtils showNavWithSourceLatitude:latitude1 Sourcelongtitude:longtitude1 desLatitude:[latitude doubleValue] desLongtitude:[longitude doubleValue] desName:name];
    }else if (_maintainModel.state == MaintainTypeWaitReceived) {
        kWeakSelf(weakSelf)
        NSString *orderID = @"";
        if (isUpKeep) {
//            orderID = _upkeepModel.ID;
        }else{
            orderID = _maintainModel.ID;
        }
        [ConfirmAndCancelWithTitleImageAlertView confirmAndCancelWithTitleImageAlertViewWithTitle:@"确定要取消订单吗?" ImageName:@"deleteOrder" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"再考虑下" ConfirmBtnTitleColor:[UIColor colorwithHexString:@"#3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"确认" CancelBtnTitleColor:[UIColor colorwithHexString:@"#9B9B9B"] Handle:^(AlertViewSelectState selectState) {
            if (selectState == AlertViewSelectStateCancel) {
                [OrderManager deleteUpkeepMraintainOrderIsUpKeep:isUpKeep andID:orderID successBlock:^(id obj) {
                    [weakSelf blockAction:YES];
                } failBlock:^(id error) {
                }];
            }
        }];
    }else if (_maintainModel.state == MaintainTypeSuccess){
        
        BOOL isCommnet = NO;
        NSString *orderID = @"";
        if (isUpKeep) {
//            isCommnet = _upkeepModel.is_comment;
//            orderID = _upkeepModel.ID;
        }else{
            isCommnet = _maintainModel.is_comment;
            orderID = _maintainModel.ID;
        }
        
        if (!isCommnet) {
            OrderEvaluateView *evaluateView = [[OrderEvaluateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            kWeakSelf(weakSelf)
            __weak __typeof(&*evaluateView)weakEvaluate= evaluateView;
            evaluateView.affirmBlock = ^(NSString *star) {
                [OrderManager upkeepOrMaintainEvaluateOrPayActionIsUpkeep:isUpKeep andMethodIsFinish:NO andID:orderID andScroe:star successBlock:^(id obj) {
                    if (obj) {
                        [weakSelf blockAction:NO];
                        [weakEvaluate removeFromSuperview];
                    }
                } failBlock:^(id error) {
                    
                }];
            };
            [self.window addSubview:evaluateView];
        }
    }
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [NSArray array];
    if (self.maintainModel.maintainitem_set_now.count==0) {
        arr = self.maintainModel.maintainitem_set;
    }else{
        arr = self.maintainModel.maintainitem_set_now;
    }
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrderProjectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ImageObjectModel *model;
    
    if (self.maintainModel.maintainitem_set_now.count==0) {
        model = self.maintainModel.maintainitem_set[indexPath.row];
    }else{
        model = self.maintainModel.maintainitem_set_now[indexPath.row];
    }
    
    cell.titleLabel.text = model.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}

- (IBAction)changProjectAction:(id)sender {
    [self changProjectActionWithFlag:YES];
}

- (void)changProjectActionWithFlag:(BOOL)isChange{
    MaintenanceListView *listView = [[MaintenanceListView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SafeAreaHeight)];
    listView.orderID = self.maintainModel.ID;
    listView.isChange = isChange;
    listView.dataArr = self.maintainModel.maintainitem_set;
    [self.window addSubview:listView];
    kWeakSelf(weakSelf)
    listView.projectChangeBlock = ^{
        weakSelf.orderChangeBlock(NO);
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
