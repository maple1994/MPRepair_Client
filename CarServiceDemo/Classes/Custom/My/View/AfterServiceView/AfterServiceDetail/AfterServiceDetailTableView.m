//
//  AfterServiceDetailTableView.m
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AfterServiceDetailTableView.h"
#import "AfterServiceTableCell.h"
#import "MyOrderImageTableCell.h"
#import "ImageObjectModel.h"

@interface AfterServiceDetailTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AfterServiceDetailTableView

static NSString *detailCellID = @"AfterServiceTableCell";
static NSString *imageCellID = @"MyOrderImageTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([AfterServiceTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderImageTableCell class]) bundle:nil] forCellReuseIdentifier:imageCellID];
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
    return self.model.pic_list.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        AfterServiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.catNumberLabel.text = [NSString stringWithFormat:@"订单单号：%@",self.model.order_id];
        cell.carTypeLabel.text =  [NSString stringWithFormat:@"申请时间：%@",self.model.create_time];
        cell.submitTimeLabel.text =  [NSString stringWithFormat:@"车辆型号：%@",self.model.car_type];
        cell.takeCatTime.text =  [NSString stringWithFormat:@"车辆号码：%@",self.model.car_code];
        
        if ([self.model.state isEqualToString:@"0"]) {
            cell.affirmButton.hidden = NO;
        }else{
            cell.affirmButton.hidden = YES;
        }
        cell.orderTypeLabel.hidden = YES;
        cell.imageLabel.hidden = (self.model.pic_list.count == 0);
        cell.nowModel = self.model;
        
        kWeakSelf(weakSelf)
        cell.changeBlock = ^{
            if (weakSelf.dataChangeBlock) {
                weakSelf.dataChangeBlock();
            }
        };
        
        return cell;
        
    }else{
        MyOrderImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ImageObjectModel *imageModel = self.model.pic_list[indexPath.row-1];
        
        cell.imageTitleLabel.text = imageModel.note;
        [NetWorkingUtil setImage:cell.orderImageView url:imageModel.pic_url defaultIconName:KDefaultImage];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 240;
    }else{
        return 214;
    }
}

#pragma mark - 值更新
- (void)setModel:(AfterServiceModel *)model{
    _model = model;
    [self reloadData];
}

@end
