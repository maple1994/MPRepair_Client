//
//  ShopCategoryTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShopCategoryTableView.h"
#import "ShopCategoryTableCell.h"
#import "CataLogModel.h"

@interface ShopCategoryTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) ShopCategoryTableCell *selectCell;

@end

@implementation ShopCategoryTableView

static NSString *detailCellID = @"ShopCategoryTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCategoryTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
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
    
    ShopCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CataLogModel *model = self.dataArrM[indexPath.row];
    cell.categoryTitleLabel.text = model.name;
    if (model.hadSelect) {
        _selectCell = cell;
        cell.categoryTitleLabel.textColor = [UIColor colorwithHexString:@"#3CADFF"];
    }else{
        cell.categoryTitleLabel.textColor = [UIColor colorwithHexString:@"#5B5B5B"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *path = [tableView indexPathForCell:_selectCell];
    
    CataLogModel *oldModel = self.dataArrM[path.row];
    oldModel.hadSelect = NO;
    _selectCell.categoryTitleLabel.textColor = [UIColor colorwithHexString:@"#5B5B5B"];
    
    _selectCell = [tableView cellForRowAtIndexPath:indexPath];
    CataLogModel *newModel = self.dataArrM[indexPath.row];
    newModel.hadSelect = YES;
    _selectCell.categoryTitleLabel.textColor = [UIColor colorwithHexString:@"#3CADFF"];
    
    if (self.isLeft) {
        if (self.selectBlock) {
            self.selectBlock(newModel.ID);
        }
    }else{
        if (self.selectDetailBlock) {
            self.selectDetailBlock(newModel.ID);
        }
    }
    
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    if (_dataArrM.count>0) {
        CataLogModel *model = [_dataArrM firstObject];
        if (self.selectBlock) {
            self.selectBlock(model.ID);
        }
    }
    
    [self reloadData];
}

@end
