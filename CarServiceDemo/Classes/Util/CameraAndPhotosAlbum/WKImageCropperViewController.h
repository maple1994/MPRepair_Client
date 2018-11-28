//
//  WKImageCropperViewController.h
//  2.0
//  相机相册编辑框的自定义
//  Created by yang on 16/8/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKImageCropperViewController;

@protocol VPImageCropperDelegate <NSObject>

/**
 *  图片编辑完成后调用的方法
 *
 *  @param cropperViewController WKImageCropperViewController，编辑图片时所展示的控制器
 *  @param editedImage           编辑后所返回的图片
 */
- (void)imageCropper:(WKImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;

/**
 *  取消图片编辑调用的方法
 *
 *  @param cropperViewController WKImageCropperViewController，编辑图片时所展示的控制器
 */
- (void)imageCropperDidCancel:(WKImageCropperViewController *)cropperViewController;

@end


@interface WKImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;

///VPImageCropperDelegate
@property (nonatomic, weak) id<VPImageCropperDelegate> delegate;

///图片编辑框的frame
@property (nonatomic, assign) CGRect cropFrame;

/**
 *  相机相册编辑框的自定义
 *
 *  @param originalImage 原始图片（未编辑过的）
 *  @param cropFrame     编辑框的frame
 *  @param limitRatio    编辑图片时，原始图的最大的放大比例
 *
 *  @return WKImageCropperViewController
 */
- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
