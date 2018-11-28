//
//  InsuranceController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "InsuranceController.h"
#import "XJTopDivisionMenuView.h"
#import "InsuranceListTabelView.h"
#import "ShopingMallManager.h"
#import "CataLogModel.h"

@interface InsuranceController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) XJTopDivisionMenuView *topMenuView;
@property (strong, nonatomic) InsuranceListTabelView *mainTableView;
@property (strong, nonatomic) ShopingMallManager *dataManager;
@property (strong, nonatomic) NSMutableArray *topIDArrM;

@end

@implementation InsuranceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
       [self loadTopData];
}

- (void)loadAllView{
    
    self.title = @"代办保险";
    [_topBackView addSubview:self.topMenuView];
    [_detailBackView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.topMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.topBackView);
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.detailBackView);
    }];
}

- (void)loadTopData{
    kWeakSelf(weakSelf)
    [self.dataManager getShopingMallTopCategoryDataWithTypeID:@"1" andPID:@"0" isSon:NO successBlock:^(NSMutableArray *result) {

        NSMutableArray *nameArrM = [NSMutableArray array];
        for (CataLogModel *model in result) {
            [nameArrM addObject:model.name];
            [weakSelf.topIDArrM addObject:model.ID];
        }
        weakSelf.topMenuView.titleArrM = nameArrM;
        if (weakSelf.topIDArrM.count>0) {
            [weakSelf loadAllDataWithCategoryID:[weakSelf.topIDArrM firstObject]];
        }
    } failBlock:^(id error) {
    }];
}


- (void)loadAllDataWithCategoryID:(NSString*)categoryID{
    kWeakSelf(weakSelf)
    [self.dataManager getShopingMallGoodsListDataWithCataLogId:categoryID andPriceOrder:nil andSaleOrder:nil  successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 懒加载
- (XJTopDivisionMenuView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView = [[XJTopDivisionMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _topBackView.height)];
//        _topMenuView.titleArrM = [NSMutableArray arrayWithObjects:@"全部",@"意外险",@"意外险",@"意外险", nil];
        _topMenuView.selectColor = [UIColor colorwithHexString:@"#3CADFF"];
        _topMenuView.slideLineColor = [UIColor colorwithHexString:@"#3CADFF"];
        [_topMenuView moveDetailHeadSlideLineViewWithPage:0];
        kWeakSelf(weakSelf)
        _topMenuView.topMenuSelectBlock = ^(NSInteger selectIndex) {
            [weakSelf loadAllDataWithCategoryID:weakSelf.topIDArrM[selectIndex]];
        };
    }
    return _topMenuView;
}

- (InsuranceListTabelView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[InsuranceListTabelView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
    }
    return _mainTableView;
}

- (ShopingMallManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[ShopingMallManager alloc] init];
    }
    return _dataManager;
}

- (NSMutableArray *)topIDArrM{
    if (!_topIDArrM) {
        _topIDArrM = [NSMutableArray array];
    }
    return _topIDArrM;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
