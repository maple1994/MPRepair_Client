//
//  MapLocationSelectionAddressVC.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/14.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "QMBaseVC.h"

@protocol MapLocationSelectionAddressVCDelegate<NSObject>
- (void)getSelectAddress:(NSString *)address Lat:(NSString *)lat lng:(NSString *)lng;
@end


@interface MapLocationSelectionAddressVC : QMBaseVC

@property (nonatomic,assign)id <MapLocationSelectionAddressVCDelegate>delegte;

@end
