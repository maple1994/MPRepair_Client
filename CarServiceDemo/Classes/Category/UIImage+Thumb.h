//
//  UIImage+Thumb.h
//  Agencies
//
//  Created by mac on 16/1/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumb)

/**
 *  限制图片的大小不超过多少KB
 *
 *  @param image       所要限制的图片
 *  @param limitLength 限制图片的大小（单位为KB）
 *
 *  @return NSData
 */
+ (NSData *)imageWithImage:(UIImage *)image limitCompactionImageLength:(NSUInteger)limitLength;

/**
*  自动缩放到指定大小
*
*  @param image 图片
*  @param asize 指定的图片大小
*
*  @return UIImage
*/
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
/**
 *  保持原来的长宽比，生成一个缩略图
 *
 *  @param image 图片
 *  @param asize 指定的图片大小
 *
 *  @return UIImage
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;


+ (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize;

+ (UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr;

@end
