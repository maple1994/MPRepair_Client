
//
//  SeletCarStyleController.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/28.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "SeletCarStyleController.h"
#import "SelectCarBrandTableCell.h"
#import "CarBrandModel.h"
#import "AddCarController.h"

@interface SeletCarStyleController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *headArrM;

@end

static NSString *detailCellID = @"SelectCarBrandTableCell";

@implementation SeletCarStyleController

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
    self.headArrM = [NSMutableArray array];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.carID;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/carstyle/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            for (NSDictionary *dict in obj) {
                CarBrandModel *model = [[CarBrandModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataArr addObject:model];
                if (![weakSelf.headArrM containsObject:model.year]) {
                    [weakSelf.headArrM addObject:model.year];
                }
            }
            
            NSMutableArray *tempArrM = [NSMutableArray array];
            for (NSString *type in weakSelf.headArrM) {
                NSMutableArray *tempArrM1 = [NSMutableArray array];
                for (CarBrandModel *model in self.dataArr) {
                    if ([type isEqualToString:model.year]) {
                        [tempArrM1 addObject:model];
                    }
                }
                [tempArrM addObject:tempArrM1];
            }
            self.dataArr = tempArrM;
            
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
            
        }
        
    }];
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headArrM.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectCarBrandTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CarBrandModel *model = self.dataArr[indexPath.section][indexPath.row];
    cell.carNameLabel.text = model.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 32)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, kScreenW-36, 32)];
    label.font = kFontSize(14);
    label.textColor = [UIColor colorwithHexString:@"#A3A3A3"];
    label.text = self.headArrM[section];
    
    [headView addSubview:label];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CarBrandModel *model = self.dataArr[indexPath.section][indexPath.row];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[AddCarController class]]) {
            AddCarController *A =(AddCarController *)controller;
            A.carStyleID = model.ID;
            A.carName = [NSString stringWithFormat:@"%@ %@",self.carName,model.name];
            [self.navigationController popToViewController:A animated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
