//
//  ShopCartTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShopCartTableView.h"
#import "ShopCartTableCell.h"
#import "ShopCartModel.h"
#import "ShopingMallManager.h"

@interface ShopCartTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ShopCartTableView

static NSString *detailCellID = @"ShopCartTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCartTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
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
    
    ShopCartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ShopCartModel *model = self.dataArrM[indexPath.row];
    cell.nowModel = model;
    
    [NetWorkingUtil setImage:cell.goodsImageView url:model.product.pic_url defaultIconName:KDefaultImage];
    cell.goodsNameLabel.text = model.product.name;
    cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.product.price];
    cell.numberLabel.text = model.amount;
    cell.selectButton.selected = model.product.hadSelect;
    
    kWeakSelf(weakSelf)
    cell.selectChangeBlock = ^() {
        [weakSelf priceChagneBlockAction];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)changeShopSelectState:(BOOL)state{
    for (ShopCartModel *model in self.dataArrM) {
        model.product.hadSelect = state;
    }
    [self reloadData];
    [self priceChagneBlockAction];
}

- (void)priceChagneBlockAction{
    int i = 0;
    CGFloat changePrice = 0.00;
    for (ShopCartModel *model in self.dataArrM) {
        if (model.product.hadSelect) {
            i++;
            changePrice += [model.amount integerValue]*[model.product.price floatValue];
        }
    }
    
    if (self.priceChangeBlock) {
        self.priceChangeBlock(changePrice,i==self.dataArrM.count?YES:NO);
    }
}

- (void)cancelShopAction{
    NSMutableString *shopIDString = [NSMutableString string];
    NSMutableArray *cancelArrM = [NSMutableArray array];
    
    for (ShopCartModel *model in self.dataArrM) {
        if (model.product.hadSelect) {
            [shopIDString appendString:[NSString stringWithFormat:@"%@,",model.ID]];
            [cancelArrM addObject:model];
        }
    }
    
    if (shopIDString.length>0) {
        [shopIDString deleteCharactersInRange:NSMakeRange(shopIDString.length-1, 1)];
        //访问接口删除
        kWeakSelf(weakSelf)
        [ShopingMallManager cancelShopCartGoodsWithIDString:shopIDString successBlock:^(BOOL result) {
            if (result) {
                for (ShopCartModel *model in cancelArrM) {
                    [weakSelf.dataArrM removeObject:model];
                }
                [weakSelf reloadData];
                [weakSelf priceChagneBlockAction];
            }
        } failBlock:^(id error) {
        }];
    }else{
        [MBProgressHUD showErrorOnView:kMAIN_WINDOW withMessage:@"请选择商品！"];
    }
    
}

- (NSMutableArray*)commitOrderAction{
    NSMutableArray *returnArrM = [NSMutableArray array];
    for (ShopCartModel *model in self.dataArrM) {
        if (model.product.hadSelect) {
            [returnArrM addObject:model];
        }
    }
    return returnArrM;
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

@end
