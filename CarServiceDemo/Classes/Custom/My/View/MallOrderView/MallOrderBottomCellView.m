//
//  MallOrderBottomCellView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/17.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MallOrderBottomCellView.h"
#import "OrderEvaluateView.h"
#import "MallOrderModel.h"
#import "OrderManager.h"
#import "PaymentController.h"

@interface MallOrderBottomCellView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MallOrderBottomCellView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"MallOrderBottomCellView" owner:self options:nil]lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
}

- (IBAction)goEvaluateView:(UIButton *)sender {
    if (_nowModel.status == MallOrderStateWaitPay) {
        PaymentController *paymentVC = [[PaymentController alloc] init];
        paymentVC.payType = PayTypeMallOrder;
        paymentVC.orderID = _nowModel.ID;
        paymentVC.isOredrDetail = YES;
        [self.viewController.navigationController pushViewController:paymentVC animated:YES];
    }else if (_nowModel.status == MallOrderStateWaitDeliver) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",kServiceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (_nowModel.status== MallOrderStateWaitReceive) {
        kWeakSelf(weakSelf)
        [OrderManager commitUserStarToOrderWithStar:nil andID:self.nowModel.ID andMethod:@"finish" successBlock:^(id obj) {
            [weakSelf blockAction];
        } failBlock:^(id error) {
            
        }];
    }else if (_nowModel.status == MallOrderStateSuccess){
        if (!_nowModel.is_comment) {
            OrderEvaluateView *evaluateView = [[OrderEvaluateView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            kWeakSelf(weakSelf)
             __weak __typeof(&*evaluateView)weakEvaluate= evaluateView;
            evaluateView.affirmBlock = ^(NSString *star) {
                [OrderManager commitUserStarToOrderWithStar:star andID:weakSelf.nowModel.ID andMethod:@"comment" successBlock:^(id result) {
                    if (result) {
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

- (IBAction)secondButtonAction:(id)sender {
    kWeakSelf(weakSelf)
    
    [ConfirmAndCancelWithTitleImageAlertView confirmAndCancelWithTitleImageAlertViewWithTitle:@"确定要删除订单吗?" ImageName:@"deleteOrder" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"再考虑下" ConfirmBtnTitleColor:[UIColor colorwithHexString:@"#3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"确认" CancelBtnTitleColor:[UIColor colorwithHexString:@"#9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateCancel) {
            [OrderManager deleteUserMallOrderWIthID:weakSelf.nowModel.ID successBlock:^(id obj) {
                [weakSelf blockAction];
            } failBlock:^(id error) {
                
            }];
        }
    }];
}

- (void)blockAction{
    if (self.menuChangeBlock) {
        self.menuChangeBlock();
    }
}

- (void)setNowModel:(MallOrderModel *)nowModel{
    _nowModel = nowModel;
    
    NSInteger amount = 0;
    for (ProductListModel *model in _nowModel.orderproduct_set) {
        amount += [model.amount integerValue];
    }
   _orderAllAmountLabel.text = [NSString stringWithFormat:@"共%ld件商品 合计：",amount];
    _orderAllPriceLabel.text = [NSString stringWithFormat:@"￥%@",_nowModel.all_price];
    
    if (_nowModel.status == MallOrderStateWaitPay) {
        [_firstButton setTitle:@"去付款" forState:UIControlStateNormal];
    }else if (_nowModel.status == MallOrderStateWaitDeliver) {
        [_firstButton setTitle:@"联系客服" forState:UIControlStateNormal];
    }else if (_nowModel.status == MallOrderStateWaitReceive) {
        [_firstButton setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (_nowModel.status == MallOrderStateSuccess){
        if (!_nowModel.is_comment) {
            [_firstButton setTitle:@"评价" forState:UIControlStateNormal];
        }else{
            [_firstButton setTitle:@"已评价" forState:UIControlStateNormal];
        }
    }
}


@end
