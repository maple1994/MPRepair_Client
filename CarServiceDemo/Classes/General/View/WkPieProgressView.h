//
//  WkPieProgressView.h
//  2.0
//  上传文件到服务器进度条
//  Created by  on 16/8/16.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WkPieProgressView : UIView

/**
 *  上传文件到服务器进度条
 *
 *  @param percent     上传百分百
 *  @param animationed 是否动画
 */
- (void)updatePercent:(CGFloat)percent animation:(BOOL)animationed;

@end
