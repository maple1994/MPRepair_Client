//
//  PayDetailController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "PayDetailController.h"
#import "PayDetailTableView.h"
#import "PaymentController.h"
#import "ShopCartModel.h"
#import "ShopingMallManager.h"
#import "MyAddressManager.h"

@interface PayDetailController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) PayDetailTableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (assign, nonatomic) CGFloat totalPrice;
@property (strong, nonatomic) NSMutableString *shopCartID;

@end

@implementation PayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"确认订单";
    self.shopCartID = [NSMutableString string];
    
    CGFloat allPrice = 0.00;
    for (ShopCartModel *model in self.dataArrM) {
        allPrice += [model.amount integerValue]*[model.product.price floatValue];
        [self.shopCartID appendString:[NSString stringWithFormat:@"%@,",model.ID]];
    }
    if (self.shopCartID.length>0) {
        [self.shopCartID deleteCharactersInRange:NSMakeRange(self.shopCartID.length-1, 1)];
    }
    _totalPrice = allPrice;
    _allPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
    [_backView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.backView);
    }];
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [MyAddressManager getMyAddressListDataIsDefault:YES successBlock:^(NSMutableArray *result) {
        if (result.count>0) {
            weakSelf.mainTableView.addressModel = [result firstObject];
        }
    } failBlock:^(id error) {
        
    }];
    self.mainTableView.dataArrM = self.dataArrM;
}

- (IBAction)goPaymentControllerAction:(id)sender {
    
    if (self.mainTableView.addressID.length==0) {
        [MBProgressHUD showMessagOnView:self.view withMessage:@"请选择收货地址"];
        return;
    }
    
    kWeakSelf(weakSelf)
    
    [ShopingMallManager commitOrderWithAddressID:self.mainTableView.addressID andShopCartID:self.shopCartID successBlock:^(id obj) {
        PaymentController *paymentVC = [[PaymentController alloc] init];
        paymentVC.orderID = obj;
        paymentVC.payType = PayTypeMallOrder;
        [weakSelf.navigationController pushViewController:paymentVC animated:YES];
    } failBlock:^(id error) {
        
    }];
    
}

#pragma mark - 懒加载
- (PayDetailTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[PayDetailTableView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, _backView.height) style:UITableViewStylePlain];
        _mainTableView.totalPrice = self.totalPrice;
    }
    return _mainTableView;
}

@end
