//
//  MyVC.m
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MyVC.h"
#import "MyManager.h"
#import "MyTableView.h"
#import "JPUSHService.h"

@interface MyVC ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) MyManager *dataManager;
@property (strong, nonatomic) MyTableView *mainTableView;

@end

@implementation MyVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    [_backView addSubview:self.mainTableView];
}

- (void)loadAllData{
    self.mainTableView.dataArrM = [self.dataManager getMyMenuData];
}

#pragma mark - 懒加载
- (MyManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[MyManager alloc] init];
    }
    return _dataManager;
}

- (MyTableView *)mainTableView{
    if (!_mainTableView) {
        
        CGFloat yPoint = 0;
        if (@available(iOS 11.0, *)) {
            yPoint = 0;
        }else{
            yPoint = 20;
        }
        _mainTableView = [[MyTableView alloc] initWithFrame:CGRectMake(0, yPoint,kScreenW, kScreenH-kFOOT-yPoint) style:UITableViewStylePlain];
        kWeakSelf(weakSelf)
        _mainTableView.settingBlock = ^{
            [weakSelf reuqestUserInfo];
        };
    }
    return _mainTableView;
}

- (void)reuqestUserInfo{
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.user.user_id;
    
    [self.util getDataWithPath:@"/api/user/user/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            NSString *token = weakSelf.user.token;
            NSString *user_id = weakSelf.user.user_id;
            
            weakSelf.user= [[UserInfo alloc]initWithDictionary:obj error:nil];
            weakSelf.user.token = token;
            weakSelf.user.user_id = user_id;
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            [weakSelf.user serilization];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
