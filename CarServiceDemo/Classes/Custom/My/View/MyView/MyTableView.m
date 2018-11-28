//
//  MyTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/2.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyTableView.h"
#import "MyHeadTableCell.h"
#import "MyDetailTableCell.h"
#import "MyMenuModel.h"
#import "MyCarportController.h"
#import "AnnualInspectionHistoryVC.h"
#import "MallOrderController.h"
#import "MyAddressController.h"
#import "MaintenanceRecordController.h"
#import "AfterServiceController.h"

@interface MyTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyTableView

static NSString *headCellID = @"MyHeadTableCell";
static NSString *detailCellID = @"MyDetailTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyHeadTableCell class]) bundle:nil] forCellReuseIdentifier:headCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyDetailTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        MyHeadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:headCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myIconImageView.cornerRadius = cell.myIconImageView.width*0.5;
        [cell.myIconImageView sd_setImageWithURL:[NSURL URLWithString:[UserInfo userInfo].pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:KDefaultImage]];
        cell.myNameLabel.text = [UserInfo userInfo].name;
        cell.myIntegralLabel.text = [NSString stringWithFormat:@"积分：%@",[UserInfo userInfo].point];
        
        kWeakSelf(weakSelf)
        cell.setBlock = ^{
            weakSelf.settingBlock();
        };
        return cell;
    }else {
        MyMenuModel *model = self.dataArrM[indexPath.row-1];
        MyDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.menuImageView.image = [UIImage imageNamed:model.imageUrl];
        cell.menuTitleLabel.text = model.title;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 295;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return;
    }
    
    MyMenuModel *model = self.dataArrM[indexPath.row-1];
    if ([model.title isEqualToString:@"我的车库"]) {
        MyCarportController *myCarportVC = [[MyCarportController alloc] init];
        [self.viewController.navigationController pushViewController:myCarportVC animated:YES];
    }else if ([model.title isEqualToString:@"年检记录"]) {
        AnnualInspectionHistoryVC *annualInspectionHistoryVC = [[AnnualInspectionHistoryVC alloc] init];
        [self.viewController.navigationController pushViewController:annualInspectionHistoryVC animated:YES];
    }else if ([model.title isEqualToString:@"商城订单"]) {
        MallOrderController *mallOrderVC = [[MallOrderController alloc] init];
        mallOrderVC.selectIndex = -1;
        [self.viewController.navigationController pushViewController:mallOrderVC animated:YES];
    }else if ([model.title isEqualToString:@"收货地址"]) {
        MyAddressController *myAddressVC = [[MyAddressController alloc] init];
        [self.viewController.navigationController pushViewController:myAddressVC animated:YES];
    }else if ([model.title isEqualToString:@"维修记录"]) {
        MaintenanceRecordController *maintenanceRecordVC = [[MaintenanceRecordController alloc] init];
        [self.viewController.navigationController pushViewController:maintenanceRecordVC animated:YES];
    }else if ([model.title isEqualToString:@"售后服务"]) {
        AfterServiceController *afterVC = [[AfterServiceController alloc] init];
        [self.viewController.navigationController pushViewController:afterVC animated:YES];
    }else if ([model.title isEqualToString:@"客服"]) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",kServiceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}
@end
