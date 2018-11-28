//
//  TableRefresher.h
//  
//
//  Created by  on 17/3/7.
//  Copyright © 2017年 com.. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UITableView+Page.h"

@interface TableRefresher : NSObject

// 上拉刷新
+ (void)refreshTable:(UITableView *)tableView headerRefresh:(void(^)())refreshBlock;
// 下拉更多
+ (void)refreshTable:(UITableView *)tableView footerRefresh:(void(^)())refreshBlock;
// 上下拉刷新
+ (void)refreshTable:(UITableView *)tableView refreshBlock:(void(^)(BOOL refresh))refreshBlock;
// 结束刷新
+ (void)endRefreshTable:(UITableView *)tableView;

/*
 kWeakSelf(weakSelf);
 [TableRefresher refreshTable:self.tableView refreshBlock:^(BOOL refresh) {
     [weakSelf requestDataListFromUrl:^(){
         weakSelf.tableView.page ++;
         weakSelf.tableView.lastPage = lastPage;
         [TableRefresher endRefreshTable:weakSelf.tableView];
     }];
 }];
 */

@end
