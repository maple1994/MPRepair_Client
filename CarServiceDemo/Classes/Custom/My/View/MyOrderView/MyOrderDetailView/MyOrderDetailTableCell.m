//
//  MyOrderDetailTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderDetailTableCell.h"
#import "UpkeepModel.h"
#import "OrderManager.h"
#import "PaymentController.h"
#import "OrderEvaluateView.h"
#import <MapKit/MapKit.h>

@interface MyOrderDetailTableCell ()

@property (assign, nonatomic) BOOL isUpkeep;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *servieDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *materialsLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation MyOrderDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUpkeepModel:(UpkeepModel *)upkeepModel{
    _upkeepModel = upkeepModel;
    self.isUpkeep = YES;
    
    _typeImageView.image = [UIImage imageNamed:@"order_serve"];
    _shopNameLabel.text = _upkeepModel.garage.name;
    if (_upkeepModel.state == UpkeepStateWaitReceived) {
        _stateLabel.text = @"等待接单";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
    }else if (_upkeepModel.state == UpkeepStateWaitPay) {
        _stateLabel.text = @"未支付";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
    }else if (_upkeepModel.state == UpkeepStateWaitService) {
        _stateLabel.text = @"待服务";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#63BDFF"];
    }else if (_upkeepModel.state == UpkeepStateServiceing) {
        _stateLabel.text = @"服务中";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#5FFF54"];
    }else if (_upkeepModel.state == UpkeepStateSuccess) {
        _stateLabel.text = @"完成服务";
        _stateLabel.textColor = [UIColor colorwithHexString:@"#FF8A4E"];
    }
    _serviceLabel.text = _upkeepModel.service_item;
    _carNumberLabel.text = [NSString stringWithFormat:@"车辆号码：%@",_upkeepModel.car_code];
    _carBrandLabel.text = [NSString stringWithFormat:@"车辆型号：%@",_upkeepModel.car_brand];
    _appointmentTimeLabel.text = [NSString stringWithFormat:@"预约时间：%@",_upkeepModel.create_time];
    _servieDetailLabel.text = [NSString stringWithFormat:@"服务项目：%@",_upkeepModel.service_item];
    _materialsLabel.text = [NSString stringWithFormat:@"项目材料：%@",_upkeepModel.project_material];
    _exchangeLabel.text = [NSString stringWithFormat:@"交易单号：%@",_upkeepModel.deal_id];
    _orderNumLabel.text = [NSString stringWithFormat:@"订单单号：%@",_upkeepModel.order_id];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_upkeepModel.now_price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
