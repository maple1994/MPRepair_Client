//
//  PayDetailTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/7.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "PayDetailTableView.h"
#import "PayDetailAddressTableCell.h"
#import "PayDetailShopTableCell.h"
#import "PayDetailBottomTableCell.h"
#import "MyAddressController.h"
#import "ShopCartModel.h"
#import "MyAddressModel.h"

@interface PayDetailTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PayDetailTableView

static NSString *addressCellID = @"PayDetailAddressTableCell";
static NSString *shopCellID = @"PayDetailShopTableCell";
static NSString *bottomCellID = @"PayDetailBottomTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([PayDetailAddressTableCell class]) bundle:nil] forCellReuseIdentifier:addressCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([PayDetailShopTableCell class]) bundle:nil] forCellReuseIdentifier:shopCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([PayDetailBottomTableCell class]) bundle:nil] forCellReuseIdentifier:bottomCellID];
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
        PayDetailAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.addressModel) {
            cell.addressDetailView.hidden = NO;
            cell.addAddressBackView.hidden = YES;
            cell.userNameLabel.text = self.addressModel.name;
            cell.userPhoneLabel.text = self.addressModel.phone;
            cell.userAddressLabel.text = self.addressModel.address;
            
            if (!self.addressModel.is_default) {
                cell.defaultIconImageWidth.constant = 0;
                cell.addressLeftConstant.constant = 0;
            }else{
                cell.defaultIconImageWidth.constant = 28;
                cell.addressLeftConstant.constant = 6;
            }
        }else{
            cell.addressDetailView.hidden = YES;
            cell.addAddressBackView.hidden = NO;
        }
        return cell;
    }else if (indexPath.row == self.dataArrM.count+1){
        PayDetailBottomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.userIntegralLabel.text = [NSString stringWithFormat:@"积分：当前积分%@分 满1000可用",[UserInfo userInfo].point];
        
        NSInteger canPoint = [[UserInfo userInfo].point integerValue];
        if (canPoint<1000||self.totalPrice<20) {
            cell.reduceUserIntegralLabel.text = @"不可用";
            cell.reduceUserIntegralLabel.textColor = [UIColor colorwithHexString:@"#5B5B5B"];
        }else{
            
            NSInteger canPointToMoney = canPoint/1000 * 10;
            if (canPoint>self.totalPrice*0.5) {
                canPointToMoney = self.totalPrice*0.5;
            }
            cell.reduceUserIntegralLabel.text = [NSString stringWithFormat:@"￥%ld",canPointToMoney];
            cell.reduceUserIntegralLabel.textColor = [UIColor colorwithHexString:@"#FF3C3C"];
        }
        
        return cell;
    }else{
        PayDetailShopTableCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ShopCartModel *model = self.dataArrM[indexPath.row-1];
        [NetWorkingUtil setImage:cell.goodsImageView url:model.product.pic_url defaultIconName:KDefaultImage];
        cell.goodsNameLabel.text = model.product.name;
        cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.product.price];
        cell.goodsNumLabel.text = [NSString stringWithFormat:@"X%@",model.amount];
        cell.allPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.amount integerValue]*[model.product.price floatValue]];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 93;
    }else if (indexPath.row==self.dataArrM.count+1){
        return 76;
    }else{
        return 159;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        MyAddressController *addressVC = [[MyAddressController alloc] init];
        addressVC.isSelect = YES;
        [self.viewController.navigationController pushViewController:addressVC animated:YES];
        kWeakSelf(weakSelf)
        addressVC.selectMyAddressBlock = ^(MyAddressModel *addressModel) {
            weakSelf.addressModel = addressModel;
        };
    }
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

- (void)setAddressModel:(MyAddressModel *)addressModel{
    _addressModel = addressModel;
    self.addressID = _addressModel.ID;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
