//
//  UniversalSelectionBoxView.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "UniversalSelectionBoxView.h"

@interface UniversalSelectionBoxView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)NSArray *dataArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,assign)NSInteger lastSelectedIndex;
@property (nonatomic ,assign)NSInteger selectedIndex;
@property (nonatomic ,copy)NSString *selectedContent;
@end

@implementation UniversalSelectionBoxView

// defaultSelectIndex:(NSInteger)selectIndex
+ (instancetype)universalSelectionBoxViewWithDataArr:(NSArray *)dataArr
{
    UniversalSelectionBoxView *view = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
    
    [view universalSelectionBoxViewWithDataArr:dataArr];
    
    return view;
}
// defaultSelectIndex:(NSInteger)selectIndex
- (void)universalSelectionBoxViewWithDataArr:(NSArray *)dataArr
{
    if (dataArr.count == 0 || !dataArr) {
        return;
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaBottomHeight - 49);
    self.dataArr = dataArr;
    self.selectedIndex = 0;
    self.lastSelectedIndex = 0;
    self.selectedContent = dataArr[0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.tableView reloadData];
    
//    if (self.dataArr.count >= selectIndex) {
//        self.selectedIndex = selectIndex;
//    }else{
    
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArr.count == 0){
        return 0;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArr.count == 0){
        return nil;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(18, 39, SCREEN_WIDTH - 36, 0.5)];
        lable.backgroundColor = [UIColor colorwithHexString:@"A3A3A3"];
        [cell.contentView addSubview:lable];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    

    NSString *textStr = self.dataArr[indexPath.row];
    if (self.selectedIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor colorwithHexString:@"3CADFF"];
    }else{
        cell.textLabel.textColor = [UIColor colorwithHexString:@"333333"];
    }
    
    cell.textLabel.text = textStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArr.count == 0){
        return;
    }
    self.selectedIndex = indexPath.row;
    self.selectedContent = self.dataArr[indexPath.row];
    [self.tableView reloadData];
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    self.lastSelectedIndex = self.selectedIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(universalSelectionBoxView:SelectedIndex:SelectContent:)]) {
        [self.delegate universalSelectionBoxView:self SelectedIndex:self.lastSelectedIndex SelectContent:self.selectedContent];
    }
    self.hidden = YES;
}

- (IBAction)cancleBtnAction:(UIButton *)sender {
    self.hidden = YES;
}

- (void)showUniversalSelectionBoxView{
    self.selectedIndex = self.lastSelectedIndex;
    self.hidden = NO;
}


@end
