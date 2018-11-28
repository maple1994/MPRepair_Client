//
//  OrderEvaluateView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/6.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "OrderEvaluateView.h"

@interface OrderEvaluateView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *affirmButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (assign, nonatomic) NSInteger nowStar;

@end

@implementation OrderEvaluateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"OrderEvaluateView" owner:self options:nil]lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    _backView.cornerRadius = 8;
    _affirmButton.cornerRadius = 8;
    _nowStar = 0;
}

- (IBAction)cancelButtonAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}

- (IBAction)starButtonAction:(UIButton *)sender {
    NSInteger noSelectIndex = sender.tag-100;
    _nowStar = noSelectIndex;
    
    for (NSInteger i=noSelectIndex; i>=1; i--) {
        UIButton *changeButton = (UIButton*)[self viewWithTag:100+i];
        changeButton.selected = YES;
    }
    for (NSInteger i=noSelectIndex; i<=5; i++) {
        UIButton *changeButton = [self viewWithTag:101+i];
        changeButton.selected = NO;
    }
}

- (IBAction)affirmButtonAction:(id)sender {
    if (_nowStar == 0) {
        [MBProgressHUD showErrorOnView:self withMessage:@"请先打分"];
        return;
    }
    if (self.affirmBlock) {
        self.affirmBlock([NSString stringWithFormat:@"%ld",_nowStar]);
    }
}

@end
