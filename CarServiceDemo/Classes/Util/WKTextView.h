
//
//  WKTextView.h
//  2.0
//  继承UITextView，增加placeholder功能
//  Created by  on 16/11/21.
//  Copyright © 2016年 Ajin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
