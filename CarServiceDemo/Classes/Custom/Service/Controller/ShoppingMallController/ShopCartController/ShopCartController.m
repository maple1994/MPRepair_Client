
//
//  ShopCartController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShopCartController.h"
#import "ShopCartTableView.h"
#import "PayDetailController.h"
#import "ShopingMallManager.h"

@interface ShopCartController ()

@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;
@property (strong, nonatomic) ShopCartTableView *mainTableView;
@property (strong, nonatomic) ShopingMallManager *dataManager;

@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;


@end

@implementation ShopCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    
    self.title = @"购物车";
    UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, 50, 30)];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rightButton setTitle:@"删除" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFontSize(14);
    [rightButton addTarget:self action:@selector(cancelShopAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightitem;
    
    [_detailBackView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.detailBackView);
    }];
    
    [_selectAllButton setEnlargeEdge:20];
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [self.dataManager getShopCartListDataSuccessBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

- (void)cancelShopAction{
    [self.mainTableView cancelShopAction];
}

- (IBAction)closeAnAccountAction:(id)sender {
    NSMutableArray *tempArrM = [self.mainTableView commitOrderAction];
    if (tempArrM.count==0) {
        [MBProgressHUD showErrorOnView:kMAIN_WINDOW withMessage:@"请选择商品！"];
        return;
    }
    PayDetailController *payDetailVC = [[PayDetailController alloc] init];
    payDetailVC.dataArrM = tempArrM;
    [self.navigationController pushViewController:payDetailVC animated:YES];
}

- (IBAction)selectAllButtonAction:(id)sender {
    _selectAllButton.selected = !_selectAllButton.selected;
    [self.mainTableView changeShopSelectState:_selectAllButton.selected];
}

#pragma mark - 懒加载
- (ShopCartTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[ShopCartTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.priceChangeBlock = ^(CGFloat price,BOOL isALL) {
            weakSelf.allPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
            weakSelf.selectAllButton.selected = isALL;
        };
    }
    return _mainTableView;
}

- (ShopingMallManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[ShopingMallManager alloc] init];
    }
    return _dataManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
