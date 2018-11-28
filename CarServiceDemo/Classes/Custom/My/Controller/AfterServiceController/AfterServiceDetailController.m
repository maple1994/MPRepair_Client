//
//  AfterServiceDetailController.m
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AfterServiceDetailController.h"
#import "AfterServiceDetailTableView.h"
#import "AfterServiceModel.h"

@interface AfterServiceDetailController ()

@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) AfterServiceDetailTableView *mainTableView;

@end

@implementation AfterServiceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    self.title = @"售后详情";
    [_detailBackView addSubview:self.mainTableView];
    kWeakSelf(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.detailBackView);
    }];
}

- (void)loadAllData{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *url = @"";
    if (self.typeID == 1) {
        url = @"/api/maintain/upkeep_aftersales/";
    }else if (self.typeID == 2) {
        url = @"/api/maintain/maintain_aftersales/";
    }
    
    params[@"id"] = self.orderID;
    
    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:url parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            AfterServiceModel *model = [[AfterServiceModel alloc] initWithDictionary:obj error:nil];
            if (weakSelf.typeID == 1) {
                model.type = @"upkeep_aftersales";
            }else if (weakSelf.typeID == 2) {
                model.type = @"maintain_aftersales";
            }
            weakSelf.mainTableView.model = model;
            
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
        }
        
    }];
}

#pragma mark - 懒加载
- (AfterServiceDetailTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[AfterServiceDetailTableView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.dataChangeBlock = ^{
            if (weakSelf.dataChangeBlock) {
                weakSelf.dataChangeBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _mainTableView;
}

@end
