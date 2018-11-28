//
//  XFBButton.h
//  
//  调换image和title的位置
//  Created by  on 16/9/20.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XFBButtonStyle

) {
    XFBButtonStyleLeftImageRightTitle,
    XFBButtonStyleLeftTitleRightImage,
    XFBButtonStyleUpImageDownTitle,
    XFBButtonStyleUpTitleDownImage
};

@interface XFBButton : UIButton

//-(void)layoutBtnWithBtn:(UIButton *)button;
/// 布局方式
@property (nonatomic, assign) XFBButtonStyle layoutStyle;
/// 图片和文字的间距，默认值8
@property (nonatomic, assign) CGFloat midSpacing;

@end
