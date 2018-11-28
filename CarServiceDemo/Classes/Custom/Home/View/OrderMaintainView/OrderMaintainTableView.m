//
//  OrderMaintainTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "OrderMaintainTableView.h"
#import "OrderMaintainHeadTableCell.h"
#import "OrderMaintainDetailTableCell.h"
#import "OrderMaintainBottomTableCell.h"
#import "OilModel.h"

@interface OrderMaintainTableView ()<UITableViewDelegate,UITableViewDataSource>

//@property (copy, nonatomic) NSString *otherPrice;

@end

@implementation OrderMaintainTableView

static NSString *headCellID = @"OrderMaintainHeadTableCell";
static NSString *detailCellID = @"OrderMaintainDetailTableCell";
static NSString *bottomCellID = @"PayDetailBottomTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([OrderMaintainHeadTableCell class]) bundle:nil] forCellReuseIdentifier:headCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([OrderMaintainDetailTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([OrderMaintainBottomTableCell class]) bundle:nil] forCellReuseIdentifier:bottomCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    return self;
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArrM.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        OrderMaintainHeadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:headCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == self.dataArrM.count+1){
        OrderMaintainBottomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellID];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.filter_price];
        if ([self.filter_price isEqualToString:@"0"]) {
            cell.priceLabel.text = @"免费";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        OrderMaintainDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        OilModel *model = self.dataArrM[indexPath.row-1];
        cell.nowModel = model;
        [NetWorkingUtil setImage:cell.goodsImageView url:model.pic_url defaultIconName:KDefaultImage];
        cell.goodsTitleLabel.text = model.name;
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.nowPrice];
        cell.selectButton.selected = model.hadSelect;
        
        kWeakSelf(weakSelf)
        cell.selectBlock = ^() {
            if (weakSelf.priceChangBlock) {
                
                NSMutableArray *idArrM = [NSMutableArray array];
                CGFloat allPrice = 0.0;
                NSMutableArray *countArrM = [NSMutableArray array];
                int number = 0;
                
                for (OilModel *model in weakSelf.dataArrM) {
                    if (model.hadSelect) {
                        [idArrM addObject:model.ID];
                        [countArrM addObject:model.amount];
                        number ++;
                        allPrice = allPrice+[model.nowPrice floatValue]*[model.amount intValue];
                    }
                }
                
                weakSelf.priceChangBlock([NSString stringWithFormat:@"%.2f",allPrice],[idArrM componentsJoinedByString:@","],[countArrM componentsJoinedByString:@","],[NSString stringWithFormat:@"%d",number]);
            }
        };
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 34;
    }else if (indexPath.row==self.dataArrM.count+1){
        return 46;
    }else{
        return 104;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

@end
