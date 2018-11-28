//
//  MallOrderTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MallOrderTableView.h"
#import "MallOrderTableCell.h"
#import "MallOrderDetailController.h"
#import "MallOrderModel.h"
#import "MallOrderBottomCellView.h"

@interface MallOrderTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MallOrderTableView

static NSString *detailCellID = @"MallOrderTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MallOrderTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    return self;
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArrM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MallOrderModel *model = self.dataArrM[section];
    NSArray *listArr = model.orderproduct_set;
    return listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MallOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MallOrderModel *orderModel = self.dataArrM[indexPath.section];
    ProductListModel *model = orderModel.orderproduct_set[indexPath.row];
    
    [NetWorkingUtil setImage:cell.orderImageView url:model.product.pic_url  defaultIconName:KDefaultImage];
     cell.orderTitleLabel.text = model.product.name;
    cell.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.product.price];
    cell.orderNumLabel.text = [NSString stringWithFormat:@"X%@",model.amount];
    
    if (orderModel.status == MallOrderStateWaitPay) {
        cell.orderStateLabel.text = @"未支付";
        cell.orderStateLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
    }else if (orderModel.status == MallOrderStateWaitDeliver){
        cell.orderStateLabel.text = @"待发货";
        cell.orderStateLabel.textColor = [UIColor colorwithHexString:@"#3CADFF"];
    }else if (orderModel.status == MallOrderStateWaitReceive) {
        cell.orderStateLabel.text = @"待收货";
        cell.orderStateLabel.textColor = [UIColor colorwithHexString:@"#FF8A4E"];
    }else if (orderModel.status == MallOrderStateSuccess){
        cell.orderStateLabel.text = @"已收货";
        cell.orderStateLabel.textColor = [UIColor colorwithHexString:@"#5FFF54"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 86;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MallOrderBottomCellView *bottomView = [[MallOrderBottomCellView alloc] initWithFrame:CGRectMake(0, 0, self.width, 86)];
    
    MallOrderModel *orderModel =self.dataArrM[section];
    bottomView.nowModel = orderModel;
    
    kWeakSelf(weakSelf)
    bottomView.menuChangeBlock = ^{
        if (weakSelf.tableChangeBlock) {
            weakSelf.tableChangeBlock();
        }
    };
    
    return bottomView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MallOrderModel *orderModel =self.dataArrM[indexPath.section];
    MallOrderDetailController *mallDetailVC = [[MallOrderDetailController alloc] init];
    mallDetailVC.orderModel = orderModel;
    [self.viewController.navigationController pushViewController:mallDetailVC animated:YES];
    
    kWeakSelf(weakSelf)
    mallDetailVC.orderChangeBlock = ^{
        if (weakSelf.tableChangeBlock) {
            weakSelf.tableChangeBlock();
        }
    };
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}
@end
