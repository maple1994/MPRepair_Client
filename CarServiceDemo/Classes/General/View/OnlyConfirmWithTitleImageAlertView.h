//
//  ConfirmAndCancelAlertWebView.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/9/25.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^ConfirmAndCancelSelectHandle)(AlertViewSelectState selectState);


@interface OnlyConfirmWithTitleImageAlertView : UIView

/**
 *
 *  title 显示的标题
 *  imageName 显示图片
 *  confirmBtnTitle 确认按钮标题
 *  confirmBtnTitleColor 确认按钮标题颜色
 *  handle 按钮选择事件block回调
 *
 */
+(instancetype)onlyConfirmWithTitleImageAlertViewWithTitle:(NSString *)title ImageName:(NSString *)imageName ConfirmBtnTitle:(NSString *)confirmBtnTitle ConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor Handle:(ConfirmAndCancelSelectHandle)handle;
@end
