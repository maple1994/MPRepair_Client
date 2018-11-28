//
//  MyAddressTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyAddressTableView.h"
#import "MyAddressTableCell.h"
#import "MyAddressModel.h"

@interface MyAddressTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyAddressTableView

static NSString *detailCellID = @"MyAddressTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyAddressTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
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
    
    MyAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyAddressModel *model = self.dataArrM[indexPath.row];
    cell.nowModel = model;
    cell.userNameLabel.text = model.name;
    cell.userPhoneLabel.text = model.phone;
    cell.userAddressLabel.text = model.address;
    kWeakSelf(weakSelf)
    cell.changeBlock = ^{
        weakSelf.changAddressBlock();
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectAddressBlock&&self.isSelect) {
        self.selectAddressBlock(self.dataArrM[indexPath.row]);
    }
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

@end
