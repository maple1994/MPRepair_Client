//
//  AfterServiceTableCell.h
//  CarServiceDemo
//
//  Created by superButton on 2018/10/19.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AfterServiceModel;

NS_ASSUME_NONNULL_BEGIN

@interface AfterServiceTableCell : UITableViewCell

@property (strong ,nonatomic) AfterServiceModel *nowModel;
@property (weak, nonatomic) IBOutlet UILabel *catNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeCatTime;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *affirmButton;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;

@property (copy ,nonatomic) void (^changeBlock) (void);

@end

NS_ASSUME_NONNULL_END
