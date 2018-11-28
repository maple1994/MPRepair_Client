//
//  LSUploadComplainCertificateCollectionCell.h
//  
//
//  Created by lj on 2017/11/24.
//  Copyright © 2017年 com.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectPhotoStatusModel.h"


@protocol SelectPhotoCollectionCellDelegate
<NSObject>

@optional
- (void)deleteImageWithSelectIndex:(NSInteger)index andImage:(UIImage *)image;
- (void)deleteImageWithSelectIndex:(NSInteger)index andImageModel:(SelectPhotoStatusModel *)imageModel;

@end

@interface SelectPhotoCollectionCell : UICollectionViewCell

/**
 * 设置属性
 */
- (void)setCellParamsWithModel:(SelectPhotoStatusModel *)model andIndexPath:(NSInteger)index;
/**
 * 代理
 */
@property (nonatomic ,assign)id <SelectPhotoCollectionCellDelegate> delegate;

@end
