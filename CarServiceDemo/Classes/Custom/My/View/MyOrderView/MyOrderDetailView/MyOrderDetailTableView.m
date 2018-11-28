//
//  MyOrderDetailTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderDetailTableView.h"
#import "MyOrderDetailTableCell.h"
#import "MyOrderImageTableCell.h"
#import "UpkeepModel.h"
#import "MyMaintainModel.h"
#import "MyOrderMainteDetailTableCell.h"

@interface MyOrderDetailTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) BOOL isUpkeep;

@end

@implementation MyOrderDetailTableView

static NSString *detailCellID = @"MyOrderDetailTableCell";
static NSString *mainteCellID = @"MyOrderMainteDetailTableCell";
static NSString *imageCellID = @"MyOrderImageTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderDetailTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderMainteDetailTableCell class]) bundle:nil] forCellReuseIdentifier:mainteCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderImageTableCell class]) bundle:nil] forCellReuseIdentifier:imageCellID];
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
    
    if (self.isUpkeep) {
        return 1+self.upkeepModel.upkeeppic_set.count;
    }else{
        return 1+self.maintainModel.maintainpic_set.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        
        if (self.isUpkeep) {
            MyOrderDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.upkeepModel = self.upkeepModel;
            
            return cell;
        }else{
            
            MyOrderMainteDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:mainteCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.maintainModel) {
                cell.maintainModel = self.maintainModel;
            }
            
            kWeakSelf(weakSelf)
            cell.orderChangeBlock = ^(BOOL isDelete) {
                if (weakSelf.tableChangeBlock) {
                    weakSelf.tableChangeBlock(isDelete);
                }
            };
            
            return cell;
        }
        
    }else{
        MyOrderImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ImageObjectModel *model ;
        if (self.isUpkeep) {
            model = self.upkeepModel.upkeeppic_set[indexPath.row-1];
        }else{
            model = self.maintainModel.maintainpic_set[indexPath.row-1];
        }
        cell.imageTitleLabel.text = model.note;
        [NetWorkingUtil setImage:cell.orderImageView url:model.pic_url defaultIconName:KDefaultImage];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CGFloat tempH = 40;
        if (self.isUpkeep) {
            if (self.upkeepModel.upkeeppic_set.count >0) {
                tempH = 0;
            };
        }else{
            if (self.maintainModel.maintainpic_set.count > 0) {
                tempH = 0;
            }
        }
        
        if (self.isUpkeep) {
            return 380-tempH;
        }else{
            NSArray *arr = [NSArray array];
            if (self.maintainModel.maintainitem_set_now.count==0) {
                arr = self.maintainModel.maintainitem_set;
            }else{
                arr = self.maintainModel.maintainitem_set_now;
            }
            return 512+arr.count*32-tempH;
        }
    }else{
        return 214;
    }
}

#pragma mark - 值更新
- (void)setUpkeepModel:(UpkeepModel *)upkeepModel{
    _upkeepModel = upkeepModel;
    
    self.isUpkeep = YES;
    
    [self reloadData];
}

- (void)setMaintainModel:(MyMaintainModel *)maintainModel{
    _maintainModel = maintainModel;
    
    self.isUpkeep = NO;
    
    [self reloadData];
}

@end
