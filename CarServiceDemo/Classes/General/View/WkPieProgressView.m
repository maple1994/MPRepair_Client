//
//  WkPieProgressView.m
//  2.0
//  上传文件到服务器进度条
//  Created by  on 16/8/16.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "WkPieProgressView.h"

const CGFloat circle = 130;

@interface WkPieProgressView()

@property (nonatomic, strong) CAShapeLayer    *trackLayer;
@property (nonatomic, strong) CAShapeLayer    *progressLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) UIColor         *trackColor;
@property (nonatomic, assign) UIColor         *progressColor;
@property (nonatomic, assign) CGFloat         lineWidth;
@property (nonatomic, strong) UIBezierPath    *path;
@property (nonatomic, assign) CGFloat         percent;
@property (nonatomic, strong) UIImageView     *shadowImageView;
@property (nonatomic, assign) CGFloat         pathWidth;
@property (nonatomic, assign) CGFloat         sumSteps;
@property (nonatomic, strong) UILabel         *progressLabel;

@end

@implementation WkPieProgressView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self updateUI];
    }
    return self;
}

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self updateUI];
}

- (void)updateUI {
    UIView *bagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bagView.backgroundColor = [UIColor blackColor];
    bagView.alpha = 0.5;
    [self addSubview:bagView];
    
//    self.backgroundColor = [UIColor grayColor];
    self.trackColor = [UIColor greenColor];
    self.progressColor = [UIColor lightGrayColor];
    self.pathWidth = self.shadowImageView.bounds.size.width;
    [self shadowImageView];
    [self trackLayer];
    [self gradientLayer];
}

- (void)loadLayer:(CAShapeLayer *)layer WithColor:(UIColor *)color {
    
    CGFloat layerWidth = self.pathWidth;
    CGFloat layerX = (self.shadowImageView.bounds.size.width - layerWidth) / 2;
    layer.frame = CGRectMake(layerX, layerX, layerWidth, layerWidth);
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineCap = kCALineCapButt;
    layer.lineWidth = self.lineWidth;
    layer.path = self.path.CGPath;
}

#pragma mark - 进度条的更新

- (void)updatePercent:(CGFloat)percent animation:(BOOL)animationed {
    
    self.percent = percent;
    [self.progressLayer removeAllAnimations];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.1];
    self.progressLayer.strokeEnd = self.percent / 100.0;
    self.progressLabel.text = [NSString stringWithFormat:@"%0.f%%", self.percent];
    [CATransaction commit];
    
}

#pragma mark - Getters 、 Setters方法

- (CAShapeLayer *)trackLayer {
    
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        [self loadLayer:_trackLayer WithColor:self.trackColor];
        [self.shadowImageView.layer addSublayer:_trackLayer];
    }
    return _trackLayer;
}

- (UIImageView *)shadowImageView {
    
    if (!_shadowImageView) {
        
        _shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - circle)/2, circle, circle, circle)];
        _shadowImageView.backgroundColor = [UIColor whiteColor];
        _shadowImageView.layer.cornerRadius = circle / 2.0;
        [_shadowImageView.layer setMasksToBounds:YES];
        _shadowImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_shadowImageView.layer.bounds].CGPath;
        _shadowImageView.layer.shadowColor = [[UIColor grayColor] CGColor];//阴影的颜色
        _shadowImageView.layer.shadowOpacity = 1.6f;   // 阴影透明度
        _shadowImageView.layer.shadowOffset = CGSizeMake(0.0,1.0f); // 阴影的范围
        _shadowImageView.layer.shadowRadius = 1.0;  // 阴影扩散的范围控制
        [self addSubview:_shadowImageView];
    }
    return _shadowImageView;
}

- (CAShapeLayer *)progressLayer {
    
    if (!_progressLayer) {
        
        _progressLayer = [CAShapeLayer layer];
        [self loadLayer:_progressLayer WithColor:self.progressColor];
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}

- (CAGradientLayer *)gradientLayer {
    
    if (!_gradientLayer) {
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.shadowImageView.bounds;
        _gradientLayer.colors = @[(id)[UIColor cyanColor].CGColor,
                                  (id)[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000].CGColor];
        [_gradientLayer setStartPoint:CGPointMake(0.5, 1.0)];
        [_gradientLayer setEndPoint:CGPointMake(0.5, 0.0)];
        [_gradientLayer setMask:self.progressLayer];
        [self.shadowImageView.layer addSublayer:_gradientLayer];
        
    }
    return _gradientLayer;
}

- (UILabel *)progressLabel {
    
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30.0)];
        _progressLabel.center = self.shadowImageView.center;
        _progressLabel.textColor = [UIColor colorWithRed:0.310 green:0.627 blue:0.984 alpha:1.000];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:38];
        
        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}

- (void)setPercent:(CGFloat)percent {
    
    _percent = percent;
    _percent = _percent > 100 ? 100 : _percent;
    _percent = _percent < 0 ? 0 : _percent;
}

- (UIBezierPath *)path {
    
    if (!_path) {
        
        CGFloat halfWidth = self.pathWidth / 2;
        _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(halfWidth, halfWidth)
                                               radius:(self.pathWidth - self.lineWidth)/2
                                           startAngle:-M_PI/2*3
                                             endAngle:M_PI/2
                                            clockwise:YES];
    }
    return _path;
}

- (CGFloat)lineWidth {
    
    if (_lineWidth == 0) {
        _lineWidth = 2.5;
    }
    return _lineWidth;
}

@end
