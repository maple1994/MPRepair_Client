//
//  AfterServiceController.m
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AfterServiceController.h"
#import "XJTopDivisionMenuView.h"
#import "AfterServiceTableView.h"
#import "AfterServiceModel.h"

@interface AfterServiceController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) XJTopDivisionMenuView *topMenuView;
@property (strong, nonatomic) AfterServiceTableView *mainTableView;

@end

@implementation AfterServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllDataWithState:@"0"];
}

- (void)loadAllView{
    self.title = @"售后记录";
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
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if ([state isEqualToString:@"0"]) {
//        params[@""] = @"0";
//    }else if (state isEqualToString:@"1") {
//
//    }
    params[@"state"] = state;
    
    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/maintain/aftersales_list/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *tempArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                AfterServiceModel *model = [[AfterServiceModel alloc] initWithDictionary:dict error:nil];
                [tempArrM addObject:model];
            }
            
            weakSelf.mainTableView.dataArrM = tempArrM;
            
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
        }
        
    }];
}

#pragma mark - 懒加载
- (XJTopDivisionMenuView *)topMenuView{
    if (!_topMenuView) {
        _topMenuView = [[XJTopDivisionMenuView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, _topBackView.height)];
        _topMenuView.titleArrM = [NSMutableArray arrayWithObjects:@"未完成的售后",@"已完成的售后", nil];
        _topMenuView.selectColor = [UIColor colorwithHexString:@"#3CADFF"];
        _topMenuView.slideLineColor = [UIColor colorwithHexString:@"#3CADFF"];
        [_topMenuView moveDetailHeadSlideLineViewWithPage:0];
        kWeakSelf(weakSelf)
        _topMenuView.topMenuSelectBlock = ^(NSInteger selectIndex) {
            [weakSelf loadAllDataWithState:[NSString stringWithFormat:@"%ld",selectIndex]];
        };
    }
    return _topMenuView;
}

- (AfterServiceTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[AfterServiceTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.dataChangeBlock = ^{
            [weakSelf loadAllDataWithState:@"0"];
        };
    }
    return _mainTableView;
}

@end
