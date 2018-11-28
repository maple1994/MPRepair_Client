//
//  MyOrderController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyOrderController.h"
#import "XJTopDivisionMenuView.h"
#import "MyOrderTableView.h"
#import "OrderManager.h"

@interface MyOrderController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) XJTopDivisionMenuView *topMenuView;
@property (strong, nonatomic) MyOrderTableView *mainTableView;
@property (copy, nonatomic) NSString *nowLoadRow;
@property (strong,nonatomic) NavigationController *nav;

@end

@implementation MyOrderController

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
    
    self.title = @"我的订单";
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
    
    kWeakSelf(weakSelf)
    
    BOOL isComment = NO;
    if ([state isEqualToString:@"4"]){
        isComment = YES;
    }
    
    self.nowLoadRow = state;
    
    [OrderManager getMyOrderListDataWithState:state isComment:isComment successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 懒加载
- (XJTopDivisionMenuView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView = [[XJTopDivisionMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _topBackView.height)];
        _topMenuView.titleArrM = [NSMutableArray arrayWithObjects:@"全部",@"待付款",@"待服务",@"待评价", nil];
        _topMenuView.selectColor = [UIColor colorwithHexString:@"#3CADFF"];
        _topMenuView.slideLineColor = [UIColor colorwithHexString:@"#3CADFF"];
        NSInteger moveSelect = _selectIndex;
        if (moveSelect==-1) {
            moveSelect = moveSelect+1;
        }else if (moveSelect == 4){
            moveSelect = moveSelect-1;
        }
        [_topMenuView moveDetailHeadSlideLineViewWithPage:moveSelect];
        kWeakSelf(weakSelf)
        _topMenuView.topMenuSelectBlock = ^(NSInteger selectIndex) {
            if (selectIndex == 3) {
                selectIndex = 4;
            }else if (selectIndex == 0){
                selectIndex = -1;
            }
            [weakSelf loadAllDataWithState:[NSString stringWithFormat:@"%ld",selectIndex]];
        };
    }
    return _topMenuView;
}

- (MyOrderTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MyOrderTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.tableChangeBlock = ^{
            [weakSelf loadAllDataWithState:weakSelf.nowLoadRow];
        };
    }
    return _mainTableView;
}

@end
