//
//  CameraAndPhotosAlbum.h
//  2.0
//  对相机相册的封装
//  Created by yang on 16/8/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///截图宽高比枚举
typedef enum:NSInteger {
    AspectRatio1x1,
    AspectRatio3x4,
    AspectRatio4x3,
    AspectRatio16x9
}AspectRatio;


@protocol CameraAndPhotosAlbumDelegate <NSObject>


@optional

/**
 *  CameraAndPhotosAlbum代理方法，传送所选择的相册图片或相机所拍的图片
 *
 *  @param img 所选择的相册图片或相机所拍的图片
 */
- (void)sendeImage :(UIImage *)img;
- (void)selectSystemPic;
@end

@interface CameraAndPhotosAlbum : NSObject

/**
*  调用相机相册,自定义了编辑区域（适配了iPad）
*
*  @param controller 当前控制器
*  @param AspectRatio 截图宽高比枚举
*  @param inView     适配iPad时PopoverFromRect
*/
- (void)cameraAndPhotosAlbumWithController: (UIViewController *)controller AspectRatio:(AspectRatio)aspectRatio ipadPopoverFromRect:(UIView *)inView NS_AVAILABLE_IOS(8_0);

/**
 *  调用相册,自定义了编辑区域（适配了iPad）
 *
 *  @param controller 当前控制器
 *  @param AspectRatio 截图宽高比枚举
 *  @param inView     适配iPad时PopoverFromRect
 */
- (void)photosAlbumWithController: (UIViewController *)controller AspectRatio:(AspectRatio)aspectRatio ipadPopoverFromRect:(UIView *)inView NS_AVAILABLE_IOS(8_0);

/**
 *  调用相机相册系统头像,自定义了编辑区域（适配了iPad）
 *
 *  @param controller 当前控制器
 *  @param AspectRatio 截图宽高比枚举
 *  @param inView     适配iPad时PopoverFromRect
 */
- (void)cameraAndPhotosAlbumAndSystemPicWithController: (UIViewController *)controller AspectRatio:(AspectRatio)aspectRatio ipadPopoverFromRect:(UIView *)inView NS_AVAILABLE_IOS(8_0);

/// CameraAndPhotosAlbumDelegate
@property(nonatomic,weak)id<CameraAndPhotosAlbumDelegate>delegate;


@end
