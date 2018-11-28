//
//  UniversalSelectionBoxView.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/5.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UniversalSelectionBoxViewDelegate <NSObject>
- (void)universalSelectionBoxView:(UIView *)view SelectedIndex:(NSInteger)selectIndex SelectContent:(NSString *)selectContent;
@end


@interface UniversalSelectionBoxView : UIView
@property (nonatomic ,assign)id <UniversalSelectionBoxViewDelegate>delegate;

+ (instancetype)universalSelectionBoxViewWithDataArr:(NSArray *)dataArr;

- (void)showUniversalSelectionBoxView;
//defaultSelectIndex:(NSInteger)selectIndex
@end
