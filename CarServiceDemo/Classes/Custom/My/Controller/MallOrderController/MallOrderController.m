//
//  MallOrderController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MallOrderController.h"
#import "XJTopDivisionMenuView.h"
#import "MallOrderTableView.h"
#import "OrderManager.h"
#import "MyVC.h"

@interface MallOrderController ()
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) XJTopDivisionMenuView *topMenuView;
@property (strong, nonatomic) MallOrderTableView *mainTableView;
@property (copy, nonatomic) NSString *nowLoadRow;
@property (strong,nonatomic) NavigationController *nav;

@end

@implementation MallOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllDataWithState:[NSString stringWithFormat:@"%ld",self.selectIndex]];
    
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

- (void)loadAllView{
    
    self.title = @"商城订单";
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

- (void)loadAllDataWithState:(NSString*)state{
    
    self.nowLoadRow = state;
    
    kWeakSelf(weakSelf)
    
    BOOL isComment = NO;
    if ([state isEqualToString:@"3"]) {
        isComment = YES;
    }
    [OrderManager getMallOrderListDataWithState:state isComment:isComment successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 懒加载
- (XJTopDivisionMenuView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView = [[XJTopDivisionMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _topBackView.height)];
        _topMenuView.titleArrM = [NSMutableArray arrayWithObjects:@"全部",@"待付款",@"待发货",@"待收货",@"待评价", nil];
        _topMenuView.selectColor = [UIColor colorwithHexString:@"#3CADFF"];
        _topMenuView.slideLineColor = [UIColor colorwithHexString:@"#3CADFF"];
        [_topMenuView moveDetailHeadSlideLineViewWithPage:_selectIndex+1];
        kWeakSelf(weakSelf)
        _topMenuView.topMenuSelectBlock = ^(NSInteger selectIndex) {
            [weakSelf loadAllDataWithState:[NSString stringWithFormat:@"%ld",selectIndex-1]];
        };
    }
    return _topMenuView;
}

- (MallOrderTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MallOrderTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStyleGrouped];
        kWeakSelf(weakSelf)
        _mainTableView.tableChangeBlock = ^{
            [weakSelf loadAllDataWithState:weakSelf.nowLoadRow];
        };
    }
    return _mainTableView;
}

@end
