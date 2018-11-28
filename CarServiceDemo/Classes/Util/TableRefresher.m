//
//  TableRefresher.m
//  
//
//  Created by  on 17/3/7.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "TableRefresher.h"

@implementation TableRefresher

+ (void)refreshTable:(UITableView *)tableView headerRefresh:(void(^)())refreshBlock
{
    __weak typeof(UITableView*) weakTableView = tableView;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakTableView.page = 1;
        refreshBlock();
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

+ (void)refreshTable:(UITableView *)tableView footerRefresh:(void(^)())refreshBlock
{
    __weak typeof(UITableView*) weakTableView = tableView;
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakTableView.page > weakTableView.lastPage) {
            [weakTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            refreshBlock();
        }
    }];
}

+ (void)refreshTable:(UITableView *)tableView refreshBlock:(void(^)(BOOL refresh))refreshBlock
{
    __weak typeof(UITableView*) weakTableView = tableView;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakTableView.page = 1;
        refreshBlock(YES);
    }];
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakTableView.page > weakTableView.lastPage) {
            [weakTableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            refreshBlock(NO);
        }
    }];
}

+ (void)endRefreshTable:(UITableView *)tableView
{
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}

@end
