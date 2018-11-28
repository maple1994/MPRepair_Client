//
//  InsuranceListTabelView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "InsuranceListTabelView.h"
#import "InsuranceListTabelCell.h"
#import "GoodsModel.h"

@interface InsuranceListTabelView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation InsuranceListTabelView

static NSString *detailCellID = @"InsuranceListTabelCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([InsuranceListTabelCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
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
    
    InsuranceListTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodsModel *model = self.dataArrM[indexPath.row];
    [NetWorkingUtil setImage:cell.insuranceImageView url:model.pic_url defaultIconName:KDefaultImage];
    cell.insuranceTitleLabel.text = model.name;
//    cell.insuranceIntroduceLabel.text = model.
//    cell.insuranceDetailLabel.text = model.
    cell.insurancePriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

@end
