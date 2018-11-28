//
//  MyCarportTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyCarportTableView.h"
#import "MyCarportTableCell.h"
#import "CarModel.h"
#import "AddCarController.h"

@interface MyCarportTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MyCarportTableView

static NSString *detailCellID = @"MyCarportTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyCarportTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
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
    
    MyCarportTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CarModel *model = self.dataArrM[indexPath.row];
    [NetWorkingUtil setImage:cell.carImageView url:model.pic_url defaultIconName:KDefaultImage];
    NSString *time = @"";
    if (model.buy_time.length>4) {
        time = [model.buy_time substringToIndex:4];
    }
    cell.carNameLabel.text = model.brand_name;
    cell.carCodeLabel.text = model.code;
    cell.carMileageLabel.text = [NSString stringWithFormat:@"车架号码：%@",model.classsno];
    if (model.is_default) {
        cell.defaultImageView.hidden = NO;
    }else{
        cell.defaultImageView.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 98;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectCarBlock&&self.isSelect) {
        self.selectCarBlock(self.dataArrM[indexPath.row]);
    }else{
        
        AddCarController *addCarVC = [[AddCarController alloc] init];
        addCarVC.isEdite = YES;
        addCarVC.carModel = self.dataArrM[indexPath.row];
        [self.viewController.navigationController pushViewController:addCarVC animated:YES];
        kWeakSelf(weakSelf)
        addCarVC.addCarBlock = ^{
            if (weakSelf.changCarBlock) {
                weakSelf.changCarBlock();
            }
        };
    }
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}


@end
