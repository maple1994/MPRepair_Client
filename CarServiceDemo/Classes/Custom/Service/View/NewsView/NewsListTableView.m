//
//  NewsListTableView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "NewsListTableView.h"
#import "NewsHeadTableCell.h"
#import "NewsListTableCell.h"
#import "NewsModel.h"
#import "NewsDetailWebController.h"

@interface NewsListTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NewsListTableView

static NSString *headCellID = @"NewsHeadTableCell";
static NSString *detailCellID = @"NewsListTableCell";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([NewsHeadTableCell class]) bundle:nil] forCellReuseIdentifier:headCellID];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([NewsListTableCell class]) bundle:nil] forCellReuseIdentifier:detailCellID];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.scrollArrM.count>0) {
        return self.dataArrM.count+1;
    }else{
        return self.dataArrM.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.scrollArrM.count>0) {
        if (indexPath.row==0) {
            NewsHeadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:headCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageArrM = self.scrollArrM;
            return cell;
        }else {
            
            NewsListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NewsModel *model = self.dataArrM[indexPath.row-1];
            [NetWorkingUtil setImage:cell.newsImageView url:model.pic_url defaultIconName:KDefaultImage];
            cell.newsTitleLabel.text = model.title;
            cell.newsIntroduceLabel.text = model.content;
            return cell;
        }
    }else {
        NewsListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NewsModel *model = self.dataArrM[indexPath.row];
        [NetWorkingUtil setImage:cell.newsImageView url:model.pic_url defaultIconName:KDefaultImage];
        cell.newsTitleLabel.text = model.title;
        cell.newsIntroduceLabel.text = model.content;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.scrollArrM.count>0) {
        if (indexPath.row==0) {
            return 186;
        }else{
            return 106;
        }
    }else {
        return 106;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        if (self.scrollArrM.count>0) {
            return;
        }
    }
    NewsModel *model ;
    
    if (self.scrollArrM.count>0) {
        model = self.dataArrM[indexPath.row-1];
    }else{
        model = self.dataArrM[indexPath.row];
    }
    
    NewsDetailWebController *newsDetailVC = [[NewsDetailWebController alloc] init];
    newsDetailVC.urlStr = model.detail_url;
    [self.viewController.navigationController pushViewController:newsDetailVC animated:YES];
}

#pragma mark - 值更新
- (void)setScrollArrM:(NSMutableArray *)scrollArrM{
    _scrollArrM  = scrollArrM;
    [self reloadData];
    
}

- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    [self reloadData];
}


@end
