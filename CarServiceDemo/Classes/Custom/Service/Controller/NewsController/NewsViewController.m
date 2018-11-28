//
//  NewsViewController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "NewsViewController.h"
#import "XJTopDivisionMenuView.h"
#import "NewsListTableView.h"
#import "NewsManager.h"
#import "CataLogModel.h"

@interface NewsViewController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) XJTopDivisionMenuView *topMenuView;
@property (strong, nonatomic) NewsListTableView *mainTableView;
@property (strong, nonatomic) NewsManager *dataManager;
@property (strong, nonatomic) NSMutableArray *topIDArrM;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadTopData];
}

- (void)loadAllView{
    
    self.title = @"资讯";
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
    [self.dataManager getNewsCategoryDataSuccessBlock:^(NSMutableArray *result) {
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
    [self.dataManager getNewsScrollViewDataSuccessBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.scrollArrM = result;
    } failBlock:^(id error) {
    }];
    
    [self.dataManager getNewsDataWithCatalogID:categoryID successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 懒加载
- (XJTopDivisionMenuView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView = [[XJTopDivisionMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _topBackView.height)];
//        _topMenuView.titleArrM = [NSMutableArray arrayWithObjects:@"活动信息",@"新闻资讯",@"维修知识", nil];
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

- (NewsListTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[NewsListTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
    }
    return _mainTableView;
}

- (NewsManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[NewsManager alloc] init];
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
