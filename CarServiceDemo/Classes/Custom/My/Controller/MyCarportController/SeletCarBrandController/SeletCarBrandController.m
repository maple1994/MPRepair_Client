//
//  SeletCarBrandController.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/28.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "SeletCarBrandController.h"
#import "SelectCarBrandTableCell.h"
#import "CarBrandModel.h"
#import "SeletCarTypeController.h"

@interface SeletCarBrandController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *headArrM;
@property (strong,nonatomic) NSMutableArray *dataArr;

@end

static NSString *detailCellID = @"SelectCarBrandTableCell";

@implementation SeletCarBrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"选择品牌";
    self.view.backgroundColor =  [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.tableView.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SelectCarBrandTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    self.headArrM = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C ",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    self.dataArr = [NSMutableArray array];
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/carbrand/" parameters:nil result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            NSMutableArray *tempArr2 = [NSMutableArray arrayWithArray:self.headArrM];
            for (NSString *typeStr in tempArr2) {
                NSArray *tempArr = obj[typeStr];
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dict in tempArr) {
                    CarBrandModel *model = [[CarBrandModel alloc] initWithDictionary:dict error:nil];
                    [arr addObject:model];
                }
                if (arr.count>0) {
                    [self.dataArr addObject:arr];
                }else{
                    [self.headArrM removeObject:typeStr];
                }
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
    SeletCarTypeController *typeVC = [[SeletCarTypeController alloc] init];
    CarBrandModel *model = self.dataArr[indexPath.section][indexPath.row];
    typeVC.carName = model.name;
    typeVC.carID = model.ID;
    [self.navigationController pushViewController:typeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
