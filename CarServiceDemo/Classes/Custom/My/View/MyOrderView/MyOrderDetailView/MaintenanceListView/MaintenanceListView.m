//
//  MaintenanceListView.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MaintenanceListView.h"
#import "MyOrderProjectTableCell.h"
#import "ImageObjectModel.h"
#import "OrderManager.h"

@interface MaintenanceListView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *changButton;
@property (weak, nonatomic) IBOutlet UITableView *mainTableVieww;

@end

static NSString *projectCellID = @"MyOrderProjectTableCell";

@implementation MaintenanceListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"MaintenanceListView" owner:self options:nil]lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    self.dataArr = [NSArray array];
    [self.mainTableVieww registerNib:[UINib nibWithNibName:NSStringFromClass([MyOrderProjectTableCell class]) bundle:nil] forCellReuseIdentifier:projectCellID];

    
}

#pragma mark - tableViewDelegate+UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrderProjectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:projectCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ImageObjectModel *model = self.dataArr[indexPath.row];
    cell.nowModel = model;
    cell.titleLabel.text = model.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    if (self.isChange) {
         cell.cancelButtonWidth.constant = 18;
        cell.titleLeftConstant.constant = 18;
    }else{
        cell.cancelButtonWidth.constant = 0;
        cell.titleLeftConstant.constant = 0;
    }
    
    kWeakSelf(weakSelf)
    cell.cancelBtnBlock = ^(ImageObjectModel *cancelModel) {
        [weakSelf.dataArr removeObject:cancelModel];
        [weakSelf.mainTableVieww reloadData];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.mainTableVieww reloadData];
}

- (void)setIsChange:(BOOL)isChange{
    _isChange = isChange;
    if (_isChange) {
        [self.changButton setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [self.changButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    [self.mainTableVieww reloadData];
}

- (IBAction)changeButtonAction:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"修改"]) {
        self.isChange = YES;
        [self.changButton setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        self.isChange = NO;
        [self.changButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    [self.mainTableVieww reloadData];
}

- (IBAction)affirmAction:(id)sender {
    
    NSMutableString *listStr = [NSMutableString string];
    for (ImageObjectModel *model in self.dataArr) {
        
        [listStr appendString:[NSString stringWithFormat:@"%@,",model.ID]];
        
    }
    if (listStr.length>0) {
        [listStr deleteCharactersInRange:NSMakeRange(listStr.length-1, 1)];
    }
    
    kWeakSelf(weakSelf)
    [OrderManager changeMaintainOrderProjectWithID:self.orderID andItem_list:listStr successBlock:^(BOOL result) {
        if (result) {
            if (weakSelf.projectChangeBlock) {
                weakSelf.projectChangeBlock();
            }
            [weakSelf removeFromSuperview];
        }
    } failBlock:^(id error) {
        
    }];
        
   
}

@end
