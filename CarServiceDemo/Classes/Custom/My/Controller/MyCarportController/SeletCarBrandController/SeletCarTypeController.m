
//
//  SeletCarTypeController.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/28.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "SeletCarTypeController.h"
#import "SelectCarBrandTableCell.h"
#import "CarBrandModel.h"
#import "SeletCarStyleController.h"

@interface SeletCarTypeController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

static NSString *detailCellID = @"SelectCarBrandTableCell";

@implementation SeletCarTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"选择品牌";
    self.view.backgroundColor =  [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectCarBrandTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    self.dataArr = [NSMutableArray array];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.carID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/cartype/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            for (NSDictionary *dict in obj) {
                CarBrandModel *model = [[CarBrandModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataArr addObject:model];
            }
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            
        }
        
    }];
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectCarBrandTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CarBrandModel *model = self.dataArr[indexPath.row];
    cell.carNameLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SeletCarStyleController *styleVC = [[SeletCarStyleController alloc] init];
    CarBrandModel *model = self.dataArr[indexPath.row];
    styleVC.carID = model.ID;
    styleVC.carName = [NSString stringWithFormat:@"%@ %@",self.carName,model.name];
    [self.navigationController pushViewController:styleVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
