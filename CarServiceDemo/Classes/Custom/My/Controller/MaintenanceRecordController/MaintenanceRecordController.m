
//
//  MaintenanceRecordController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MaintenanceRecordController.h"
#import "XJTopDivisionMenuView.h"
#import "MaintenanceRecordTableView.h"
#import "OrderManager.h"

@interface MaintenanceRecordController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) XJTopDivisionMenuView *topMenuView;
@property (strong, nonatomic) MaintenanceRecordTableView *mainTableView;

@end

@implementation MaintenanceRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllDataWithState:@"1"];
}

- (void)loadAllView{
    
    self.title = @"维修记录";
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
    [OrderManager getMyMaintenanceRecordDataWithState:state successBlock:^(NSMutableArray *result) {
        weakSelf.mainTableView.dataArrM = result;
    } failBlock:^(id error) {
    
    }];
}

#pragma mark - 懒加载
- (XJTopDivisionMenuView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView = [[XJTopDivisionMenuView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, _topBackView.height)];
        _topMenuView.titleArrM = [NSMutableArray arrayWithObjects:@"未完成的维修",@"已完成的维修", nil];
        _topMenuView.selectColor = [UIColor colorwithHexString:@"#3CADFF"];
        _topMenuView.slideLineColor = [UIColor colorwithHexString:@"#3CADFF"];
        [_topMenuView moveDetailHeadSlideLineViewWithPage:0];
        kWeakSelf(weakSelf)
        _topMenuView.topMenuSelectBlock = ^(NSInteger selectIndex) {
            [weakSelf loadAllDataWithState:[NSString stringWithFormat:@"%ld",selectIndex+1]];
        };
    }
    return _topMenuView;
}

- (MaintenanceRecordTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[MaintenanceRecordTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
    }
    return _mainTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
