//
//  AfterServiceTableView.m
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AfterServiceTableView.h"
#import "AfterServiceTableCell.h"
#import "AfterServiceDetailController.h"
#import "AfterServiceModel.h"

@interface AfterServiceTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AfterServiceTableView

static NSString *detailCellID = @"AfterServiceTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([AfterServiceTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
    
    AfterServiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AfterServiceModel *model = self.dataArrM[indexPath.row];
    
    cell.catNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.order_id];
    cell.carTypeLabel.text =  [NSString stringWithFormat:@"车辆号码：%@",model.car_code];
    cell.submitTimeLabel.text =  [NSString stringWithFormat:@"车辆型号：%@",model.car_type];
    if ([model.state isEqualToString:@"0"]) {
        cell.orderTypeLabel.text = @"服务中";
        cell.affirmButton.hidden = NO;
    }else{
        cell.orderTypeLabel.text = @"已完成";
        cell.affirmButton.hidden = YES;
    }
    cell.takeCatTime.text =  [NSString stringWithFormat:@"申请时间：%@",model.create_time];
    cell.imageLabel.hidden = YES;
    cell.nowModel = model;
    
    kWeakSelf(weakSelf)
    cell.changeBlock = ^{
        weakSelf.dataChangeBlock();
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AfterServiceDetailController *detailVC = [[AfterServiceDetailController alloc] init];
    AfterServiceModel *model = self.dataArrM[indexPath.row];
    if ([model.type isEqualToString:@"upkeep_aftersales"]) {
        detailVC.typeID = 1;
    }else if ([model.type isEqualToString:@"maintain_aftersales"]) {
        detailVC.typeID = 2;
    }
    detailVC.orderID = model.ID;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
    
    kWeakSelf(weakSelf)
    detailVC.dataChangeBlock = ^{
        if (weakSelf.dataChangeBlock) {
            weakSelf.dataChangeBlock();
        }
    };
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

@end
