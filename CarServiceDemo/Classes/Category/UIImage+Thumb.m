//
//  UIImage+Thumb.m
//  Agencies
//
//  Created by mac on 16/1/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "UIImage+Thumb.h"

@implementation UIImage (Thumb)

/**
 *  限制图片的大小不超过多少KB
 *
 *  @param image       所要限制的图片
 *  @param limitLength 限制图片的大小（单位为KB）
 *
 *  @return NSData
 */
+ (NSData *)imageWithImage:(UIImage *)image limitCompactionImageLength:(NSUInteger)limitLength {
    
    id obj = [[self alloc] init];
    
    return [obj imageWithImage1:image limitCompactionImageLength:limitLength];
}

/**
 *  限制图片的大小不超过多少KB
 *
 *  @param image       所要限制的图片
 *  @param limitLength 限制图片的大小（单位为KB）
 *
 *  @return NSData
 */
- (NSData *)imageWithImage1:(UIImage *)image limitCompactionImageLength:(NSUInteger)limitLength {
    
    NSUInteger imageDataLength = 0;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSUInteger tempLength = imageData.length / 1024;
    CGFloat compressionQuality = 1.0;
    
    while (tempLength > limitLength) {
        
        if (tempLength / 1024 > 4) { //图片大于4M的减少压缩系数
            
            compressionQuality = compressionQuality * 0.6;
            
        } else {
            
            compressionQuality = compressionQuality * 0.7;
        }
        
        imageData = UIImageJPEGRepresentation(image, compressionQuality);
        tempLength = imageData.length / 1024;
        
        if (tempLength == imageDataLength) {
            
            tempLength = limitLength;
        }
        
        imageDataLength = tempLength;
        
    }
    
    return imageData;
}



+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}


+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        }
        
        else{
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    
    return newimage;
    
}

+ (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height) {
        return scImg;
    }
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height) {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}


/**
 字符串转图片
 
 @param encodedImageStr 字符串
 @return UIImage
 */
+ (UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr {
    
    
    if ([encodedImageStr isEqualToString:@" "] || [encodedImageStr isEqualToString:@""] || (encodedImageStr == nil) || [encodedImageStr isKindOfClass:[NSNull class]]) {
        
        return nil;
    }else {
        
        NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
        return decodedImage;
    }
}

@end
