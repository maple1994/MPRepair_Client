//
//  AddCarAddressTableView.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/10.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AddCarAddressTableView.h"
#import "AddCarAddressTableCell.h"
#import "CarAddressModel.h"

@interface AddCarAddressTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) AddCarAddressTableCell *selectCell;

@end

@implementation AddCarAddressTableView

static NSString *detailCellID = @"AddCarAddressTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([AddCarAddressTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
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
    
    AddCarAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BOOL hadSelect = NO;
    NSString *titleStr = @"";
    if (_isLeft) {
        CarAddressModel *model = self.dataArrM[indexPath.row];
        hadSelect = model.hadSelect;
        titleStr = model.province;
    }else{
        CarAddressChildModel *model = self.dataArrM[indexPath.row];
        hadSelect = model.hadSelect;
        titleStr = model.city_name;
    }
    
    cell.addressLabel.text = titleStr;
    if (hadSelect) {
        _selectCell = cell;
        cell.addressLabel.textColor = [UIColor colorwithHexString:@"#3CADFF"];
    }else{
        cell.addressLabel.textColor = [UIColor colorwithHexString:@"#333333"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *path = [tableView indexPathForCell:_selectCell];
    
    if (_isLeft) {
        CarAddressModel *oldModel = self.dataArrM[path.row];
        oldModel.hadSelect = NO;
    }else{
        CarAddressChildModel *oldModel = self.dataArrM[path.row];
        oldModel.hadSelect = NO;
    }
    
    _selectCell.addressLabel.textColor = [UIColor colorwithHexString:@"#333333"];

    _selectCell = [tableView cellForRowAtIndexPath:indexPath];
    if (_isLeft) {
        CarAddressModel *newModel = self.dataArrM[indexPath.row];
        newModel.hadSelect = YES;
        if (self.leftSelectBlock) {
            self.leftSelectBlock(newModel.province,newModel.carcity_set);
        }
    }else{
        CarAddressChildModel *newModel = self.dataArrM[indexPath.row];
        newModel.hadSelect = NO;
        self.nowCityCode = newModel.city_code;
        self.nowCityName = newModel.city_name;
        if (self.rightSelectBlock) {
            self.rightSelectBlock(self.nowCityName,self.nowCityCode);
        }
    }
    _selectCell.addressLabel.textColor = [UIColor colorwithHexString:@"#3CADFF"];
    
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    if (_isLeft) {
        CarAddressModel *newModel = [_dataArrM firstObject];
        newModel.hadSelect = YES;
        if (self.leftSelectBlock) {
            self.leftSelectBlock(newModel.province,newModel.carcity_set);
        }
    }else{
        CarAddressChildModel *newModel = [_dataArrM firstObject];
        newModel.hadSelect = YES;
        self.nowCityCode = newModel.city_code;
        self.nowCityName = newModel.city_name;
    }
    
    [self reloadData];
}
@end
