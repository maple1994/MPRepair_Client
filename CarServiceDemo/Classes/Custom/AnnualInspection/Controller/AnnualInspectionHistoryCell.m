//
//  AnnualInspectionHistoryCell.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionHistoryCell.h"

@interface AnnualInspectionHistoryCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end


@implementation AnnualInspectionHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AnnualInspectionHistoryModel *)model{
    self.timeLabel.text = [NSString stringWithFormat:@"预约时间:%@",model.subscribe_time];
    self.dealTimeLabel.text = [NSString stringWithFormat:@"完成时间：%@",model.state.integerValue == 8 ? model.confirm_time : @"未完成"];
    self.addressLabel.text = [NSString stringWithFormat:@"年检地点：%@",model.surveystation.name];
    self.driverNameLabel.text = [NSString stringWithFormat:@"年检类型：%@",model.is_self.boolValue ? @"自驾年检" : @"代驾年检"];
    
    if ([model.is_self boolValue]) {
        if ([model.state isEqualToString:@"3"]) {
            self.stateLabel.text = @"开始导航";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF8A4E"];
        }else{
            self.stateLabel.text = @"";
        }
    }else{
        if ([model.state isEqualToString:@"0"]) {
            
            self.stateLabel.text = @"等待支付";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF8A4E"];
        }
        else if ([model.state isEqualToString:@"1"]) {
            
            self.stateLabel.text = @"等待接单";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"63BDFF"];
        }else if([model.state isEqualToString:@"2"]){
            
            self.stateLabel.text = @"等待取车";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF8A4E"];
        }else if([model.state isEqualToString:@"3"]){
            
            self.stateLabel.text = @"等待年检";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF8A4E"];
            
        }else if([model.state isEqualToString:@"4"] && [model.survey_state isEqualToString:@"0"]){
            
            self.stateLabel.text = @"正在年检";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF8A4E"];
            
        }else if([model.state isEqualToString:@"4"] && [model.survey_state isEqualToString:@"2"]){
            
            self.stateLabel.text = @"未通过";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF3C3C"];
            
        }else if([model.state isEqualToString:@"4"] && [model.survey_state isEqualToString:@"3"]){
            
            self.stateLabel.text = @"复检中";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"FF8A4E"];
            
        }else if([model.state isEqualToString:@"5"] || [model.state isEqualToString:@"6"] || [model.state isEqualToString:@"7"] || [model.state isEqualToString:@"8"]){
            
            self.stateLabel.text = @"已通过";
            self.stateLabel.textColor = [UIColor colorWithHexStringToRGB:@"5FFF54"];
            
        }else{
            self.stateLabel.text = @"";
        }
    }
    
    
    
}

- (void)setOrderby:(NSString *)orderby{
    _orderby = orderby;
    if ([orderby isEqualToString:@"2"]) {
        self.stateLabel.hidden = YES;
    }else{
        self.stateLabel.hidden = NO;
    }
}

@end
