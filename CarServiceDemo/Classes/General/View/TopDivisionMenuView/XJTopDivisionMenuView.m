//
//  XJTopDivisionMenuView.m
//  SavingBarrel
//
//  Created by xj_love on 2018/1/3.
//  Copyright © 2018年 xj_love. All rights reserved.
//

#import "XJTopDivisionMenuView.h"

#define kDefaultColor [UIColor colorWithRed:60/255.0 green:173/255.0 blue:255/255.0 alpha:1.0]
#define kBtnTag 100

@interface XJTopDivisionMenuView ()

@property (nonatomic, strong)UIView *cutView1;//顶部分割线
@property (nonatomic, strong)UIView *cutView2;//底部分割线
@property (nonatomic, strong)UIView *slidelineView;//滑动线
@property (nonatomic, assign)CGFloat buttonWidth;//按钮的宽度

@property (assign,nonatomic) NSInteger nowCount;

@end

@implementation XJTopDivisionMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _nowCount = 0;
    }
    return self;
}

- (void)loadAllView{
    [self loadMenuButton];
    [self addSubview:self.cutView1];
    [self addSubview:self.cutView2];
    [self addSubview:self.slidelineView];
}

- (void)loadMenuButton{
    
    _buttonWidth = self.frame.size.width/self.titleArrM.count;
    
    self.slidelineView.frame = CGRectMake(19, self.size.height-2, _buttonWidth-38, 2);
    
    CGFloat bHeight = self.height;
    if (bHeight == 0) {
        bHeight = 44;
    }
    for (int i = 0; i < _titleArrM.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(i * _buttonWidth,1, _buttonWidth, bHeight-2);
        [btn setTitle:_titleArrM[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        
        if (_titleTextColor) {
            [btn setTitleColor:_titleTextColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
        if (_titleFont) {
            [btn.titleLabel setFont:_titleFont];
        }else{
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = kBtnTag+i;
        [self addSubview:btn];
        
        if (i == 0) {
            if (_selectColor) {
                [btn setTitleColor:_selectColor forState:UIControlStateNormal];
            }else{
             [btn setTitleColor:kDefaultColor forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - 点击事件
- (void)buttonClick:(UIButton *)sender {
    
    if (_nowCount != sender.tag-kBtnTag) {
        _nowCount = sender.tag-kBtnTag;
        [self moveDetailHeadSlideLineViewWithPage:_nowCount];
        if (self.topMenuSelectBlock) {
            self.topMenuSelectBlock(_nowCount);
        }
    }
}

#pragma mark - 外部方法
- (void)moveDetailHeadSlideLineViewWithPage:(NSInteger)page {
    _nowCount = page;
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (_titleTextColor) {
                [button setTitleColor:_titleTextColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    
    UIButton *button = (UIButton *)[self viewWithTag:100+page];
    if (_selectColor) {
        [button setTitleColor:_selectColor forState:UIControlStateNormal];
    }else{
        [button setTitleColor:kDefaultColor forState:UIControlStateNormal];
    }
    
    kWeakSelf(weakSelf)
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         self.slidelineView.frame = CGRectMake(page * weakSelf.buttonWidth+19, self.frame.size.height-2, weakSelf.buttonWidth-38, 2);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - 值更新
- (void)setTopLineColor:(UIColor *)topLineColor{
    _topLineColor = topLineColor;
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor{
    _bottomLineColor = bottomLineColor;
}

- (void)setSlideLineColor:(UIColor *)slideLineColor{
    _slideLineColor = slideLineColor;
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
}

- (void)setTitleArrM:(NSMutableArray *)titleArrM{
    
    _titleArrM = titleArrM;
    [self loadAllView];
}

#pragma mark - 懒加载
- (UIView *)cutView1{
    if (_cutView1 == nil) {
        _cutView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, 1)];
        if (_topLineColor) {
            _cutView1.backgroundColor = _topLineColor;
        }else{
            _cutView1.backgroundColor = [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:0.35];
        }
        
    }
    return _cutView1;
}

- (UIView *)cutView2{
    if (_cutView2 == nil) {
        _cutView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.size.height-1, self.size.width, 1)];
        if (_bottomLineColor) {
            _cutView2.backgroundColor = _bottomLineColor;
        }else{
            _cutView2.backgroundColor = [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:0.35];
        }
    }
    return _cutView2;
}

- (UIView *)slidelineView{
    if (_slidelineView == nil) {
        _slidelineView = [[UIView alloc] init];
        if (_slideLineColor) {
            _slidelineView.backgroundColor = _slideLineColor;
        }else{
            _slidelineView.backgroundColor = kDefaultColor;
        }
    }
    return _slidelineView;
}

@end
