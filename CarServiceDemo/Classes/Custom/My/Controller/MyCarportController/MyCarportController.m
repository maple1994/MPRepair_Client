//
//  MyCarportController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyCarportController.h"
#import "MyCarportTableView.h"
#import "AddCarController.h"
#import "MyManager.h"

@interface MyCarportController ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) MyCarportTableView *mainTableView;

@end

@implementation MyCarportController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"我的车库";
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightButton setImage:[UIImage imageNamed:@"addIcon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addCarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightitem;
    
    [_backView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.backView);
    }];
}

- (void)addCarButtonAction{
    AddCarController *addCarVC = [[AddCarController alloc] init];
    [self.navigationController pushViewController:addCarVC animated:YES];
    
    kWeakSelf(weakSelf)
    addCarVC.addCarBlock = ^{
        [weakSelf loadAllData];
    };
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [MyManager getCarportListDataIsDefault:NO successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 懒加载
- (MyCarportTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MyCarportTableView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, _backView.height) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.isSelect  = self.isSelect;
        _mainTableView.selectCarBlock = ^(CarModel *selectModel) {
            if (weakSelf.selectMyCarBlock) {
                weakSelf.selectMyCarBlock(selectModel);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        };
        _mainTableView.changCarBlock = ^{
            [weakSelf loadAllData];
        };
    }
    return _mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
