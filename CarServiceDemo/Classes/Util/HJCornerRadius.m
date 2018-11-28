//
//  HJCornerRadius.m
//  HJImageViewDemo
//
//  Created by haijiao on 16/3/10.
//  Copyright © 2016年 olinone. All rights reserved.
//

#import "HJCornerRadius.h"
#import <objc/runtime.h>

@interface UIImage (cornerRadius)

@property (nonatomic, assign) BOOL isCornerRadius;

@end

@implementation UIImage (cornerRadius)

- (BOOL)isCornerRadius {
    return [objc_getAssociatedObject(self, @selector(isCornerRadius)) boolValue];
}

- (void)setIsCornerRadius:(BOOL)isCornerRadius {
    objc_setAssociatedObject(self, @selector(isCornerRadius), @(isCornerRadius), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

/////////////////////////////////////////////////////////////////////
@interface HJImageObserver : NSObject

@property (nonatomic, assign) UIImageView *originImageView;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, assign) CGFloat cornerRadius;

- (instancetype)initWithImageView:(UIImageView *)imageView;

@end

@implementation HJImageObserver

- (void)dealloc {
    [self.originImageView removeObserver:self forKeyPath:@"image"];
    [self.originImageView removeObserver:self forKeyPath:@"contentMode"];
}

- (instancetype)initWithImageView:(UIImageView *)imageView{
    if (self = [super init]) {
        self.originImageView = imageView;
        [imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        [imageView addObserver:self forKeyPath:@"contentMode" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[@"new"];
        if (![newImage isKindOfClass:[UIImage class]] || newImage.isCornerRadius) {
            return;
        }
        [self updateImageView];
    }
    if ([keyPath isEqualToString:@"contentMode"]) {
        self.originImageView.image = self.originImage;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    if (_cornerRadius > 0) {
        [self updateImageView];
    }
}

- (void)updateImageView {
    self.originImage = self.originImageView.image;
    if (!self.originImage) {
        return;
    }
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(self.originImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    if (currnetContext) {
        CGContextAddPath(currnetContext, [UIBezierPath bezierPathWithRoundedRect:self.originImageView.bounds cornerRadius:self.cornerRadius].CGPath);
        CGContextClip(currnetContext);
        [self.originImageView.layer renderInContext:currnetContext];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if ([image isKindOfClass:[UIImage class]]) {
        image.isCornerRadius = YES;
        self.originImageView.image = image;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateImageView];
        });
    }
}

@end

/////////////////////////////////////////////////////////////////////
@implementation UIImageView (HJCornerRadius)

/** 把View切为圆形 */
- (void)roundView {
    
//    CGFloat width = (self.width > self.height)? self.height : self.width;
    
//    [self setCornerRadius:width*0.5];
}



- (CGFloat)cornerRadius {
    return [self imageObserver].cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self imageObserver].cornerRadius = cornerRadius;
}

- (HJImageObserver *)imageObserver {
    HJImageObserver *imageObserver = objc_getAssociatedObject(self, @selector(imageObserver));
    if (!imageObserver) {
        imageObserver = [[HJImageObserver alloc] initWithImageView:self];
        objc_setAssociatedObject(self, @selector(imageObserver), imageObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imageObserver;
}

@end
