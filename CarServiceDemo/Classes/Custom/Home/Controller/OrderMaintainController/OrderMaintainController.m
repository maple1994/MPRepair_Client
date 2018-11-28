//
//  OrderMaintainController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "OrderMaintainController.h"
#import "OrderMaintainTableView.h"
#import "SubmitMaintainController.h"
#import "MyManager.h"
#import "RepairShopInfoModel.h"

@interface OrderMaintainController ()

@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (strong, nonatomic) OrderMaintainTableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (copy, nonatomic) NSString *nowOilID;
@property (copy, nonatomic) NSString *nowOilAmount;
@property (copy, nonatomic) NSString *nowPrice;
@property (copy, nonatomic) NSString *nowNumber;

@end

@implementation OrderMaintainController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    
    self.title = @"预约保养";
    
    [_detailBackView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.detailBackView);
    }];
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [MyManager getMaintainOilListDataWithID:self.dataModel.ID successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
        weakSelf.mainTableView.filter_price = weakSelf.dataModel.filter_price;
    } failBlock:^(id error) {
        
    }];
}

- (IBAction)submitAnAccountAction:(id)sender {
    
    if ([ValidateUtil isEmptyStr:self.nowOilID]) {
        [MBProgressHUD showMessagOnView:self.view withMessage:@"请先选择项目"];
        return;
    }
    
    SubmitMaintainController *submitMaintain = [[SubmitMaintainController alloc] init];
    submitMaintain.repairModel = self.dataModel;
    submitMaintain.price = self.nowPrice;
    submitMaintain.oilID =  self.nowOilID;
    submitMaintain.oilAmount = self.nowOilAmount;
    submitMaintain.oilNumber = self.nowNumber;
    [self.navigationController pushViewController:submitMaintain animated:YES];
}

#pragma mark - 懒加载
- (OrderMaintainTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[OrderMaintainTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.priceChangBlock = ^(NSString *selectPrice,NSString *oilID,NSString *oilAmount,NSString *oilNumber) {
            weakSelf.nowOilID = oilID;
            weakSelf.nowOilAmount = oilAmount;
            weakSelf.allPriceLabel.text = [NSString stringWithFormat:@"￥%@",selectPrice];
            weakSelf.nowPrice = selectPrice;
            weakSelf.nowNumber = oilNumber;
        };
    }
    return _mainTableView;
}

@end
