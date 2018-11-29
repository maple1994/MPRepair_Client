//
//  MPUtils.m
//  CarServiceDemo
//
//  Created by Maple on 2018/11/29.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MPUtils.h"
#import <AMapNaviKit/AMapNaviKit.h>

@implementation MPUtils

static AMapNaviCompositeManager *mgr;

+ (void)showNavWithSourceLatitude: (double)sLatitude Sourcelongtitude: (double)sLongtitude desLatitude: (double)dLatitude desLongtitude: (double)dLongtitude desName: (NSString *)desName {
    ///能否打开高德地图
    BOOL flag2 = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]];
    if (flag2) {
        NSString *gaodeParameterFormat = @"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=当前位置&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0";
        NSString *urlString = [NSString stringWithFormat:
                               gaodeParameterFormat,
                               sLatitude,
                               sLongtitude,
                               dLatitude,
                               dLongtitude,
                               desName
                               ];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
            }];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }else {
        AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
        AMapNaviPoint *point = [AMapNaviPoint locationWithLatitude:dLatitude longitude:dLongtitude];
        [config setRoutePlanPOIType: AMapNaviRoutePlanPOITypeEnd location:point name:desName POIId:nil];
        mgr = [[AMapNaviCompositeManager alloc] init];
        [mgr presentRoutePlanViewControllerWithOptions:config];
    }
}

@end
