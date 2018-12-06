//
//  MyOrderDetailController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderDetailController.h"
#import "MyOrderDetailTableView.h"
#import "OrderManager.h"
#import "UpkeepModel.h"
#import "MyMaintainModel.h"
#import "ApplyAfterServiceController.h"

@interface MyOrderDetailController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) MyOrderDetailTableView *mainTableView;

@end

@implementation MyOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"订单详情";
    
    [_backView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.backView);
    }];
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    if (self.isUpkeep) {
        [OrderManager getUpkeepDetailDataWithID:self.orderID successBlock:^(id obj) {
            weakSelf.mainTableView.upkeepModel = obj;
            if ([weakSelf.mainTableView.upkeepModel.is_aftersales isEqualToString:@"1"]) {
                [weakSelf addRightAfterService];
            }
        } failBlock:^(id error) {
            
        }];
    }else{
        [OrderManager getMaintainDetailDataWithID:self.orderID successBlock:^(id obj) {
            weakSelf.mainTableView.maintainModel = obj;
            if ([weakSelf.mainTableView.maintainModel.is_aftersales isEqualToString:@"1"]) {
                [weakSelf addRightAfterService];
            }
        } failBlock:^(id error) {
            
        }];
    }
}

- (void)addRightAfterService{
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 70, 30)];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightButton setTitle:@"申请售后" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFontSize(14);
    [rightButton addTarget:self action:@selector(goInAfterServiceAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightitem;
}

- (void)goInAfterServiceAction{
    ApplyAfterServiceController *applyVC = [[ApplyAfterServiceController alloc] init];
    if (self.mainTableView.upkeepModel) {
        applyVC.typeID = 1;
        applyVC.orderID = self.mainTableView.upkeepModel.ID;
    }else if (self.mainTableView.maintainModel){
        applyVC.typeID = 2;
        applyVC.orderID = self.mainTableView.maintainModel.ID;
    }
    [self.navigationController pushViewController:applyVC animated:YES];
}

#pragma mark - 懒加载
- (MyOrderDetailTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MyOrderDetailTableView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, _backView.height) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.tableChangeBlock = ^(BOOL isDelete) {
            if (!isDelete) {
                [weakSelf loadAllData];
            }else{
                if (weakSelf.orderChangeBlock) {
                    weakSelf.orderChangeBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    return _mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
