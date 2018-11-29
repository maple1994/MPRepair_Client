//
//  MyOrderTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderTableCell.h"
#import "OrderEvaluateView.h"
#import "MyMaintainModel.h"
#import "OrderManager.h"
#import "PaymentController.h"
#import <MapKit/MapKit.h>
#import "MyOrderDetailController.h"
#import "ServicePointDetailsVC.h"
#import "RepairShopInfoModel.h"

@implementation MyOrderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)goEvaluateView:(id)sender {
    
    BOOL isUpKeep = NO;
    if ([self.nowModel.type isEqualToString:@"upkeep"]) {
        isUpKeep = YES;
    }
    
    if (_nowModel.state == MaintainTypeWaitPay) {
        if (isUpKeep) {
            PaymentController *paymentVC = [[PaymentController alloc] init];
            paymentVC.orderID = self.nowModel.ID;
            paymentVC.payType = PayTypeUpKeepOrder;
            paymentVC.isOredrDetail = YES;
            [self.viewController.navigationController pushViewController:paymentVC animated:YES];
        }else{
            MyOrderDetailController *myOrderDetailVC = [[MyOrderDetailController alloc] init];
            myOrderDetailVC.isUpkeep = isUpKeep;
            myOrderDetailVC.orderID = _nowModel.ID;
            [self.viewController.navigationController pushViewController:myOrderDetailVC animated:YES];
            kWeakSelf(weakSelf)
            myOrderDetailVC.orderChangeBlock = ^{
                if (weakSelf.orderChangeBlock) {
                    weakSelf.orderChangeBlock();
                }
            };
        }
        
    }else if (_nowModel.state == MaintainTypeWaitReceived) {
        kWeakSelf(weakSelf)
        [ConfirmAndCancelWithTitleImageAlertView confirmAndCancelWithTitleImageAlertViewWithTitle:@"确定要取消订单吗?" ImageName:@"deleteOrder" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"再考虑下" ConfirmBtnTitleColor:[UIColor colorwithHexString:@"#3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"确认" CancelBtnTitleColor:[UIColor colorwithHexString:@"#9B9B9B"] Handle:^(AlertViewSelectState selectState) {
            if (selectState == AlertViewSelectStateCancel) {
                [OrderManager deleteUpkeepMraintainOrderIsUpKeep:isUpKeep andID:weakSelf.nowModel.ID successBlock:^(id obj) {
                    [weakSelf blockAction];
                } failBlock:^(id error) {
                    
                }];
            }
        }];
    }else if (_nowModel.state ==
              MaintainTypeHasReceived ||
              _nowModel.state ==
              MaintainTypeWaitService){
        double latitude1 = [UserInfo userInfo].latitude;
        double longtitude1 = [UserInfo userInfo].longtitude;
        NSString *desName = self.nowModel.name;
        double latitude2 = [self.nowModel.latitude doubleValue];
        double longtitude2 = [self.nowModel.longitude doubleValue];
        [MPUtils showNavWithSourceLatitude:latitude1 Sourcelongtitude:longtitude1 desLatitude:latitude2 desLongtitude:longtitude2 desName:desName];
    }else if (_nowModel.state == MaintainTypeServiceNow){
        kWeakSelf(weakSelf)
        [OrderManager upkeepOrMaintainEvaluateOrPayActionIsUpkeep:isUpKeep andMethodIsFinish:YES andID:weakSelf.nowModel.ID andScroe:nil successBlock:^(id obj) {
            if (obj) {
                [weakSelf blockAction];
            }
        } failBlock:^(id error) {
            
        }];
    }else if (_nowModel.state == MaintainTypeSuccess){
        if (!_nowModel.is_comment) {
            OrderEvaluateView *evaluateView = [[OrderEvaluateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            kWeakSelf(weakSelf)
            __weak __typeof(&*evaluateView)weakEvaluate= evaluateView;
            evaluateView.affirmBlock = ^(NSString *star) {
                [OrderManager upkeepOrMaintainEvaluateOrPayActionIsUpkeep:isUpKeep andMethodIsFinish:NO andID:weakSelf.nowModel.ID andScroe:star successBlock:^(id obj) {
                    if (obj) {
                        [weakSelf blockAction];
                        [weakEvaluate removeFromSuperview];
                    }
                } failBlock:^(id error) {
                    
                }];
            };
            [self.window addSubview:evaluateView];
        }
    }
}

- (IBAction)deleteButtonAction:(id)sender {
    kWeakSelf(weakSelf)
    BOOL isUpKeep = NO;
    if ([self.nowModel.type isEqualToString:@"upkeep"]) {
        isUpKeep = YES;
    }
    
    [ConfirmAndCancelWithTitleImageAlertView confirmAndCancelWithTitleImageAlertViewWithTitle:@"确定要取消订单吗?" ImageName:@"deleteOrder" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"再考虑下" ConfirmBtnTitleColor:[UIColor colorwithHexString:@"#3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"确认" CancelBtnTitleColor:[UIColor colorwithHexString:@"#9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateCancel) {
            [OrderManager deleteUpkeepMraintainOrderIsUpKeep:isUpKeep andID:weakSelf.nowModel.ID successBlock:^(id obj) {
                [weakSelf blockAction];
            } failBlock:^(id error) {
                
            }];
        }
    }];
}

- (void)blockAction{
    if (self.orderChangeBlock) {
        self.orderChangeBlock();
    }
}

- (void)setNowModel:(MyMaintainModel *)nowModel{
    _nowModel = nowModel;
    
    _secondButton.hidden = NO;
    
    if (_nowModel.state == MaintainTypeWaitReceived) {
        self.serviceStateLabel.text = @"等待接单";
        self.serviceStateLabel.textColor = [UIColor colorwithHexString:@"#5FFF54"];
        [_firstButton setTitle:@"取消订单" forState:UIControlStateNormal];
        _secondButton.hidden = YES;
    }else if (_nowModel.state == MaintainTypeWaitPay) {
        self.serviceStateLabel.text = @"未支付";
        self.serviceStateLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
        [_firstButton setTitle:@"去付款" forState:UIControlStateNormal];
    }else if (_nowModel.state == MaintainTypeHasReceived) {
        self.serviceStateLabel.text = @"已接单";
        self.serviceStateLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
        [_firstButton setTitle:@"导航" forState:UIControlStateNormal];
    }else if (_nowModel.state == MaintainTypeWaitService){
        self.serviceStateLabel.text = @"等待服务";
        self.serviceStateLabel.textColor = [UIColor colorwithHexString:@"#63BDFF"];
        [_firstButton setTitle:@"导航" forState:UIControlStateNormal];
    }else if (_nowModel.state == MaintainTypeServiceNow) {
        self.serviceStateLabel.text = @"服务中";
        self.serviceStateLabel.textColor = [UIColor colorwithHexString:@"#5FFF54"];
        [_firstButton setTitle:@"确认取车" forState:UIControlStateNormal];
        _secondButton.hidden = YES;
    }else if (_nowModel.state == MaintainTypeSuccess){
        self.serviceStateLabel.text = @"完成服务";
        self.serviceStateLabel.textColor = [UIColor colorwithHexString:@"#FF8A4E"];
        if (!_nowModel.is_comment) {
            [_firstButton setTitle:@"评价" forState:UIControlStateNormal];
        }else{
            [_firstButton setTitle:@"已评价" forState:UIControlStateNormal];
        }
        _secondButton.hidden = YES;
    }
}

- (IBAction)gotoDetailsVCBtnAction:(UIButton *)sender {
    
    ServicePointDetailsVC *detailsVC = [[ServicePointDetailsVC alloc]init];
    NSDictionary *dict = [self.nowModel.garage toDictionary];
    detailsVC.dataModel = [[RepairShopInfoModel alloc] initWithDictionary:dict error:nil];
    [self.viewController.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
