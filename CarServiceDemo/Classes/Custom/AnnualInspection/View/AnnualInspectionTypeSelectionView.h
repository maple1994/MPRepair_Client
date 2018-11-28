//
//  AnnualInspectionTypeSelectionView.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/18.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AnnualInspectionTypeSelfDrivingAnnualInspection = 0,
    AnnualInspectionTypeDriverAnnualInspection = 1,
} AnnualInspectionType;

typedef void(^AnnualInspectionTypeSelectionViewHanleBlock)(AnnualInspectionType type);

@interface AnnualInspectionTypeSelectionView : UIView
+ (instancetype)annualInspectionTypeSelectionViewHandle:(AnnualInspectionTypeSelectionViewHanleBlock) handle;
@end
