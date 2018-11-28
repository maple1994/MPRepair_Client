//
//  HostUtil.m
//  
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "HostUtil.h"

static NSInteger _buildType = 0;

@implementation HostUtil

+ (void)configureBuildType:(ConfigureBuildType)buildType
{
    _buildType = buildType;
}

/// 获取主域名
+ (NSString*)getBaseUrl
{
    if (_buildType==ConfigureBuildTypeTesting) {///测试
        return @"http://www.nolasthope.cn";
    }else if (_buildType==ConfigureBuildTypeAcceptance) {///验收
        return @"http://www.nolasthope.cn";
    }else if (_buildType==ConfigureBuildTypeOfficial){///正式
        return @"http://www.nolasthope.cn";
    }
    
    return @"http://www.nolasthope.cn";
}


/// 传入子路径 获取绝对路劲
+ (NSString*)getAbsoluteUrl:(NSString*)subUrl;
{
    if (subUrl==nil) {
        subUrl = @"";
    }
    
    return [NSString stringWithFormat:@"%@%@", [self getBaseUrl], subUrl];
}


@end
