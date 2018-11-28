//
//  MaintenanceRecordTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MaintenanceRecordTableView.h"
#import "MaintenanceRecordTableCell.h"
#import "MyMaintainModel.h"

@interface MaintenanceRecordTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MaintenanceRecordTableView

static NSString *detailCellID = @"MaintenanceRecordTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MaintenanceRecordTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
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
    
    MaintenanceRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyMaintainModel *model = self.dataArrM[indexPath.row];
    cell.serviceTitleLabel.text = model.service_item;
    cell.carNumberLabel.text = [NSString stringWithFormat:@"车辆号码：%@",model.car_code];
    cell.carTypeLabel.text =  [NSString stringWithFormat:@"车辆型号：%@",model.car_type];
    cell.carOrderTimeLabel.text =  [NSString stringWithFormat:@"预约时间：%@",model.subscribe_time];
    if (model.state != MaintainTypeSuccess) {
        cell.carGetTimeLabel.text =  @"未取车";
    }else{
        cell.carGetTimeLabel.text =  [NSString stringWithFormat:@"取车时间：%@",model.over_time];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 174;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

@end
