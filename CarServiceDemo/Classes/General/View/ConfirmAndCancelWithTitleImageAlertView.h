//
//  ConfirmAndCancelAlertWebView.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/9/25.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^ConfirmAndCancelSelectHandle)(AlertViewSelectState selectState);


@interface ConfirmAndCancelWithTitleImageAlertView : UIView

/**
 *
 *  title 显示的标题
 *  imageName 显示的图片
 *  confirmBtnIsShow 确认按钮是否显示
 *  confirmBtnTitle 确认按钮标题
 *  confirmBtnTitleColor 确认按钮标题颜色
 *  cancelBtnIsShow 取消按钮是否显示
 *  cancelBtnTitle 取消按钮标题
 *  cancelTitleColor 取消按钮标题颜色
 *  handle 按钮选择事件block回调
 *
 */
+(instancetype)confirmAndCancelWithTitleImageAlertViewWithTitle:(NSString *)title ImageName:(NSString *)imageName ConfirmBtnIsShow:(BOOL)confirmBtnIsShow ConfirmBtnTitle:(NSString *)confirmBtnTitle ConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor CancelBtnIsShow:(BOOL)cancelBtnIsShow CancelBtnTitle:(NSString *)cancelBtnTitle CancelBtnTitleColor:(UIColor *)cancelTitleColor Handle:(ConfirmAndCancelSelectHandle)handle;
@end
