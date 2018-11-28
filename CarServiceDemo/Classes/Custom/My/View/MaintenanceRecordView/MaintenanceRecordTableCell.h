//
//  MaintenanceRecordTableCell.h
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaintenanceRecordTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carOrderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carGetTimeLabel;

@end
