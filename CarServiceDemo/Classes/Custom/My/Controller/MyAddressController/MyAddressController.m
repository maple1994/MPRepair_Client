//
//  MyAddressController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyAddressController.h"
#import "MyAddressTableView.h"
#import "AddAddressController.h"
#import "MyAddressManager.h"

@interface MyAddressController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) MyAddressTableView *mainTableView;
@property (strong, nonatomic) MyAddressManager *dataManager;

@end

@implementation MyAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"我的地址";
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightButton setImage:[UIImage imageNamed:@"addIcon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addAddressButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightitem;
    
    [_backView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.backView);
    }];
}

- (void)addAddressButtonAction{
    AddAddressController *addAddressVC = [[AddAddressController alloc] init];
    [self.navigationController pushViewController:addAddressVC animated:YES];
    kWeakSelf(weakSelf)
    addAddressVC.saveBtnBlock = ^{
        [weakSelf loadAllData];
    };
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [MyAddressManager getMyAddressListDataIsDefault:NO successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 懒加载
- (MyAddressTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MyAddressTableView alloc] initWithFrame:CGRectMake(0, 0, _backView.width, _backView.height) style:UITableViewStylePlain];
        _mainTableView.isSelect = self.isSelect;
        kWeakSelf(weakSelf)
        _mainTableView.changAddressBlock = ^{
            [weakSelf loadAllData];
        };
        _mainTableView.selectAddressBlock = ^(MyAddressModel *selectModel) {
            if (weakSelf.isSelect&&weakSelf.selectMyAddressBlock) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.selectMyAddressBlock(selectModel);
            }
        };
    }
    return _mainTableView;
}

- (MyAddressManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[MyAddressManager alloc] init];
    }
    return _dataManager;
}

@end
