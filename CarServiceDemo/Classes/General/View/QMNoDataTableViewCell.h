//
//  QMNoDataTableViewCell.h
//  
//  无数据状态的规则显示空盒子图标+文字提醒
//  Created by yang on 17/2/21.
//  Copyright © 2017年 com.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMNoDataTableViewCell : UITableViewCell

/// 无数据文字描述
@property (copy, nonatomic)NSString *descStr;
///无数据文字描述字体颜色(十六进制)
@property (copy, nonatomic) NSString *descStrColor;
/// 无数据图片描述
@property (copy, nonatomic)NSString *imageName;

@end
