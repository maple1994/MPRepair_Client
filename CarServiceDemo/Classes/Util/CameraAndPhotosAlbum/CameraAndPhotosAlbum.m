//
//  CameraAndPhotosAlbum.m
//  2.0
//  对相机相册的封装
//  Created by yang on 16/8/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CameraAndPhotosAlbum.h"
#import "WKImageCropperViewController.h"

@interface CameraAndPhotosAlbum ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,VPImageCropperDelegate>

@property (nonatomic,weak) UIViewController *controller;
///截图的宽高比枚举
@property (nonatomic,assign) AspectRatio aspectRatio;

@end


@implementation CameraAndPhotosAlbum

- (void)photosAlbumWithController: (UIViewController *)controller AspectRatio:(AspectRatio)aspectRatio ipadPopoverFromRect:(UIView *)inView {
    
    self.controller = controller;
    self.aspectRatio = aspectRatio;
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"请选择：" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [weakSelf openImageWithController:controller imagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    UIPopoverPresentationController *popView = alertController.popoverPresentationController;
    if (popView) {
        popView.sourceView = inView;
        popView.sourceRect = inView.bounds;
        popView.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [controller presentViewController: alertController animated: YES completion: nil];
    
}

- (void)cameraAndPhotosAlbumWithController: (UIViewController *)controller AspectRatio:(AspectRatio)aspectRatio ipadPopoverFromRect:(UIView *)inView {

    self.controller = controller;
    self.aspectRatio = aspectRatio;
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"请选择：" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [weakSelf openImageWithController:controller imagePickerControllerSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [weakSelf openImageWithController:controller imagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    UIPopoverPresentationController *popView = alertController.popoverPresentationController;
    if (popView) {
        popView.sourceView = inView;
        popView.sourceRect = inView.bounds;
        popView.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [controller presentViewController: alertController animated: YES completion: nil];

}

- (void)cameraAndPhotosAlbumAndSystemPicWithController:(UIViewController *)controller AspectRatio:(AspectRatio)aspectRatio ipadPopoverFromRect:(UIView *)inView{
    self.controller = controller;
    self.aspectRatio = aspectRatio;
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"修改头像" message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [weakSelf openImageWithController:controller imagePickerControllerSourceType:UIImagePickerControllerSourceTypeCamera];
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [weakSelf openImageWithController:controller imagePickerControllerSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"系统头像" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        if (_delegate ) {
            if (_delegate && [_delegate respondsToSelector:@selector(selectSystemPic)]) {
                
                [_delegate selectSystemPic];
            }
        }
        
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    UIPopoverPresentationController *popView = alertController.popoverPresentationController;
    if (popView) {
        popView.sourceView = inView;
        popView.sourceRect = inView.bounds;
        popView.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [controller presentViewController: alertController animated: YES completion: nil];
    
}

- (void)openImageWithController:(UIViewController *)controller imagePickerControllerSourceType:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = type;
    imagePickerController.delegate = self;
    [controller presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self imageInfoHandelWithImage:image];
    }];
}

- (void)imageInfoHandelWithImage:(UIImage *)image {
    
    if (SCREEN_WIDTH<SCREEN_HEIGHT) {
        ///竖屏
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        CGFloat height=0.0;
        if (self.aspectRatio==AspectRatio1x1) {
            height = width / 1.0*1;
        }else if (self.aspectRatio==AspectRatio3x4) {
            height = width / 3.0*4;
        }else if (self.aspectRatio==AspectRatio4x3) {
            height = width / 4.0*3;
        }else if (self.aspectRatio==AspectRatio16x9) {
            height = width / 16.0*9;
        }
        
        WKImageCropperViewController *imgCropperVC = [[WKImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, width, height) limitScaleRatio:3.0];//AspectRatioChange
        imgCropperVC.delegate = self;
        [self.controller presentViewController:imgCropperVC animated:YES completion:nil];
        
    }else {
        ///横屏
        
        CGFloat height=0;
        CGFloat width = 0.0;
        
        if (self.aspectRatio==AspectRatio1x1) {
            height=[UIScreen mainScreen].bounds.size.height-40;
            width = height * 1.0/1.0;
        }else if (self.aspectRatio==AspectRatio3x4) {
            height=[UIScreen mainScreen].bounds.size.height-40;
            width = height * 3.0/4.0;
        }else if (self.aspectRatio==AspectRatio4x3) {
            height=[UIScreen mainScreen].bounds.size.height-100;
            width = height * 4.0/3.0;
        }else if (self.aspectRatio==AspectRatio16x9) {
            height=[UIScreen mainScreen].bounds.size.height-100;
            width = height * 16.0/9.0;
        }
        WKImageCropperViewController *imgCropperVC = [[WKImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake((SCREEN_WIDTH-width)/2.0, (SCREEN_HEIGHT-height)/2.0, width, height) limitScaleRatio:3.0];//AspectRatioChange
        imgCropperVC.delegate = self;
        [self.controller presentViewController:imgCropperVC animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(WKImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    if (_delegate && [_delegate conformsToProtocol:@protocol(CameraAndPhotosAlbumDelegate)]) {
        
        [_delegate sendeImage:editedImage];
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(WKImageCropperViewController *)cropperViewController {
    
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - dealloc

- (void)dealloc {
    
    self.controller = nil;
}


@end
