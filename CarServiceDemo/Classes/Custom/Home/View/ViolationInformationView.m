//
//  ViolationInformationView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ViolationInformationView.h"
#import "ViolationInformationCell.h"
#import "VehicleViolationInfoModel.h"

@interface ViolationInformationView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

///
@property (nonatomic ,assign)NSInteger selectIndex;

@end

@implementation ViolationInformationView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
   
    
}

+ (instancetype)violationInformationViewWithDataArr:(NSArray *)dataArr
{
    
     ViolationInformationView *view  = [[[NSBundle mainBundle] loadNibNamed:@"ViolationInformationView" owner:nil options:nil]firstObject];
    [view violationInformationViewWithDataArr:dataArr];
    return view;
}

- (void)violationInformationViewWithDataArr:(NSArray *)dataArr
{
    if (dataArr.count == 0) {
//        [self removeFromSuperview];
        return;
    }
    [self.confirmBtn setCornerRadius:4];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.bgView addSubview:effectView];
//    [self sendSubviewToBack:self.bgView];
//    [self sendSubviewToBack:effectView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ViolationInformationCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ViolationInformationCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.myContentView setCornerRadius:8];
    self.dataArr = [NSMutableArray arrayWithArray:dataArr];
    [self.tableView reloadData];
}


- (IBAction)cancelButtonAction:(id)sender {
    
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 114;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ViolationInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViolationInformationCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (IBAction)confirmBtnAction:(id)sender {
    self.selectIndex++;
    if (self.selectIndex >= self.dataArr.count) {
        [self removeFromSuperview];
        return;
    }
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:self.selectIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}


@end
