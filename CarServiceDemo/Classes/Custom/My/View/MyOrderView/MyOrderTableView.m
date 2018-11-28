//
//  MyOrderTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderTableView.h"
#import "MyOrderTableCell.h"
#import "MyOrderDetailController.h"
#import "MyMaintainModel.h"

@interface MyOrderTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyOrderTableView

static NSString *detailCellID = @"MyOrderTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyMaintainModel *model = self.dataArrM[indexPath.row];
    cell.nowModel = model;
    [NetWorkingUtil setImage:cell.serviceImageVIew url:model.order_pic_url defaultIconName:KDefaultImage];
    cell.serviceTitleLabel.text = model.order_name;
    cell.orderTimeLabel.text = [NSString stringWithFormat:@"预约时间：%@",model.create_time];
    cell.orderPriceLabel.text = model.now_price;
    
    kWeakSelf(weakSelf)
    cell.orderChangeBlock = ^{
        if (weakSelf.tableChangeBlock) {
            weakSelf.tableChangeBlock();
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyMaintainModel *nowModel = self.dataArrM[indexPath.row];
    BOOL isUpKeep = NO;
    if ([nowModel.type isEqualToString:@"upkeep"]) {
        isUpKeep = YES;
    }
    
    MyOrderDetailController *myOrderDetailVC = [[MyOrderDetailController alloc] init];
    myOrderDetailVC.isUpkeep = isUpKeep;
    myOrderDetailVC.orderID = nowModel.ID;
    [self.viewController.navigationController pushViewController:myOrderDetailVC animated:YES];
    kWeakSelf(weakSelf)
    myOrderDetailVC.orderChangeBlock = ^{
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
