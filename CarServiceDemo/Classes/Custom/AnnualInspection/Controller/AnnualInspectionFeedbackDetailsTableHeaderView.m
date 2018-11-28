//
//  AnnualInspectionFeedbackDetailsTableHeaderView.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionFeedbackDetailsTableHeaderView.h"

@interface AnnualInspectionFeedbackDetailsTableHeaderView() <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *otherPriceLabel;
///
@property (weak, nonatomic) IBOutlet UILabel *totolPriceLabel;
@property (nonatomic ,copy)PayBlockCompleted payBlockCompleted;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end


@implementation AnnualInspectionFeedbackDetailsTableHeaderView


+ (instancetype)annualInspectionFeedbackDetailsTableHeaderViewCompleted:(PayBlockCompleted)payBlockCompleted{
    AnnualInspectionFeedbackDetailsTableHeaderView *headView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:[NSBundle mainBundle] options:nil]firstObject];
    [headView annualInspectionFeedbackDetailsTableHeaderView];
    headView.payBlockCompleted = payBlockCompleted;
    [headView.confirmBtn setCornerRadius:4];
//    [headView.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    headView.tableView.delegate = headView;
    headView.tableView.dataSource = headView;
    return headView;
}

- (void)setDataModel:(AnnualInspectionHistoryModel *)dataModel{
    _dataModel = dataModel;
    if (dataModel.failure_list.count > 0) {
        failure_object *model = self.dataModel.failure_list[0];
        self.totolPriceLabel.text = [NSString stringWithFormat:@"¥%.02f",model.price.floatValue];
        
        if (![ValidateUtil isEmptyStr:model.name]) {
            self.otherPriceLabel.text = model.name;
        }else{
            self.otherPriceLabel.text = @"暂无";
        }
    }
    
    [self.tableView reloadData];
    failure_object *model = self.dataModel.failure_list[0];
    CGFloat height= 40*model.failureitem_list.count;
    self.tableViewHeight.constant = height;
    [self layoutIfNeeded];
    [self layoutSubviews];
//    if (self.dataModel.surveycomboitem_set.count > 0) {
//        NSMutableArray *setArr = [NSMutableArray array];
//
//        for (surveycomboitem_set *model in self.dataModel.surveycomboitem_set) {
//            [setArr addObject:[NSString stringWithFormat:@"%@%@",model.name,model.price]];
//        }
//        if (setArr.count > 0) {
//            NSString *str = [setArr componentsJoinedByString:@"/"];
//            self.otherPriceLabel.text = str;
//        }
//
//
//    }else{
//        self.otherPriceLabel.text = @"暂无";
//    }
    
}

-(void)annualInspectionFeedbackDetailsTableHeaderView{
    
}


- (IBAction)payBtnAction:(id)sender {
    self.payBlockCompleted();
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    failure_object *model = self.dataModel.failure_list[0];
    return model.failureitem_list.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.detailTextLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF3C3C"];
        cell.textLabel.textColor = [UIColor colorWithHexStringToRGB:@"5B5B5B"];
        
    }
    NSString *nameStr = @"";
    NSString *priceStr = @"";
    
    failure_object *model = self.dataModel.failure_list[0];
    if (indexPath.row == model.failureitem_list.count) {
        nameStr = @"总计费用";
        priceStr = model.price;
    }else{
        failureitem_list *listModel = model.failureitem_list[indexPath.row];
        nameStr = listModel.name;
        priceStr = listModel.price;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@:",nameStr];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.02f",[priceStr floatValue]];
    return cell;
}

@end
