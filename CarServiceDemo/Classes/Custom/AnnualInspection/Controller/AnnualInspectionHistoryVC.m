//
//  AnnualInspectionHistoryVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionHistoryVC.h"
#import "AnnualInspectionHistoryCell.h"
#import "AnnualInspectionOrderDetailsVC.h"
#import "AnnualInspectionFeedbackDetailsVC.h"
#import "AnnualInspectionHistoryModel.h"
#import "AnnualInspectionOrderDetailsInfoVC.h"
#import "AnnualInspectionSelfDrivingStartVC.h"

@interface AnnualInspectionHistoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *buttomLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectBtns;

/// 数据源
@property (nonatomic ,strong)NSMutableArray *dataArr;

/// 筛选条件
@property (nonatomic ,copy)NSString *orderby;

@property (strong,nonatomic) NavigationController *nav;
@end

static NSString *AnnualInspectionHistoryCellID = @"AnnualInspectionHistoryCell";

@implementation AnnualInspectionHistoryVC

#pragma mark -- 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isBackRoot) {
        _nav.gobackBlock = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_isBackRoot) {
        _nav = (NavigationController*)self.navigationController;
        kWeakSelf(weakSelf)
        _nav.gobackBlock = ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self setupProperty];
    
    [self addRefresh];

    [self selectBtnsAction:self.selectBtns[0]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 初始化页面s
- (void)setupProperty{
    self.title = @"年检记录";
    [self.tableView registerNib:[UINib nibWithNibName:AnnualInspectionHistoryCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:AnnualInspectionHistoryCellID];
}

#pragma mark -- 添加上下拉刷新
- (void)addRefresh{
    
    kWeakSelf(weakSelf);
    
    [TableRefresher refreshTable:self.tableView refreshBlock:^(BOOL refresh) {
        [weakSelf requestDataFromUrl];
    }];
    
}


#pragma mark -- 请求维修点信息
- (void)requestDataFromUrl{
    
    kWeakSelf(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"finish"] = self.orderby;
    
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    
    [self.util getDataWithPath:@"/api/survey/survey/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            if (weakSelf.tableView.page == 1) {
                weakSelf.dataArr = nil;
                
            }
            weakSelf.tableView.page ++;
            
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                for (NSDictionary *modelDict in obj) {
                    AnnualInspectionHistoryModel *model =[[AnnualInspectionHistoryModel alloc]initWithDictionary:modelDict error:nil];
                    
                    [weakSelf.dataArr addObject:model];
                }
            }
            
            [TableRefresher endRefreshTable:weakSelf.tableView];
            [weakSelf.tableView reloadData];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
        }else{
            
            [TableRefresher endRefreshTable:weakSelf.tableView];
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArr.count == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        return self.tableView.height;
    }
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        QMNoDataTableViewCell *cell = [[QMNoDataTableViewCell alloc]init];
        cell.descStr = @"暂无数据";
        cell.descStrColor = @"#CCCCCC";
        cell.imageName = KDefaultImage;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    AnnualInspectionHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:AnnualInspectionHistoryCellID];
    cell.orderby = self.orderby;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (IBAction)selectBtnsAction:(UIButton *)sender {
    
    self.buttomLabel.centerX = sender.centerX;
    self.orderby = [NSString stringWithFormat:@"%ld",sender.tag];
    
    for (UIButton *btn in self.selectBtns) {
        
        if (sender == btn) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count == 0) {
        return;
    }

    
    AnnualInspectionHistoryModel *model = self.dataArr[indexPath.row];
//    if (!model.is_success) {
//        return;
//    }
    if ([model.is_self boolValue]) {// 自驾详情
        
        AnnualInspectionSelfDrivingStartVC *startVC = [[AnnualInspectionSelfDrivingStartVC alloc]init];
        startVC.dataModel = model;
        [self.navigationController pushViewController:startVC animated:YES];

    }else{
        NSLog(@"%@",model.state);
        if ([model.state isEqualToString:@"4"] && [model.survey_state isEqualToString:@"2"]) {// 年检反馈
            AnnualInspectionFeedbackDetailsVC *feedBackVC = [[AnnualInspectionFeedbackDetailsVC alloc]init];
            feedBackVC.dataModel = model;
            [self.navigationController pushViewController:feedBackVC animated:YES];
            
        }else if([model.state isEqualToString:@"0"] || [model.state isEqualToString:@"1"] || [model.state isEqualToString:@"8"]){// 其他年检详情
            
            AnnualInspectionOrderDetailsInfoVC *detailSVC = [[AnnualInspectionOrderDetailsInfoVC alloc]init];
            detailSVC.dataModel = model;
            [self.navigationController pushViewController:detailSVC animated:YES];
            
            kWeakSelf(weakSelf)
            detailSVC.changeBlock = ^{
                [weakSelf.tableView.mj_header beginRefreshing];
            };
            
        }else{//  有状态的年检详情
            
            AnnualInspectionOrderDetailsVC *detailSVC = [[AnnualInspectionOrderDetailsVC alloc]init];
            detailSVC.dataModel = model;
            [self.navigationController pushViewController:detailSVC animated:YES];
        }
        
    }
    
    
    
}


@end
