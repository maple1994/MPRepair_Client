//
//  LSXiaoErComplainModel.h
//  
//
//  Created by lj on 2017/11/27.
//  Copyright © 2017年 com.. All rights reserved.
//



@interface SelectPhotoStatusModel : NSObject
/**
 *  是否添加
 */
@property (nonatomic ,assign)BOOL isAdd;

/**
 *  是否查看模式
 */
@property (nonatomic ,assign)BOOL isCheck;

/**
 *  是否可删除
 */
@property (nonatomic ,assign)BOOL isCanDelete;

/**
 *  图片
 */
@property (nonatomic ,copy)UIImage *imageData;
@property (nonatomic ,copy)NSString *imageUrl;
@property (nonatomic ,copy)NSString *imageID;
/** 是否单独显示图片 */
@property (nonatomic, assign) BOOL isShowImg;


@end


