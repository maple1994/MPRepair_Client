//
//  main.m
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

///更新的版本URL
NSString *updateAppUrl = @"";

int main(int argc, char * argv[]) {
    @autoreleasepool {
#warning 打包记得修改接口环境
#ifdef DEBUG
                [HostUtil configureBuildType:ConfigureBuildTypeTesting];///测试环境
        
        //        [HostUtil configureBuildType:ConfigureBuildTypeAcceptance];///验收环境
        
//        [HostUtil configureBuildType:ConfigureBuildTypeOfficial];///正式环境
        
#else
        
//        [HostUtil configureBuildType:ConfigureBuildTypeOfficial];///正式环境
        
        //        [HostUtil configureBuildType:ConfigureBuildTypeAcceptance];///验收环境
        //
                [HostUtil configureBuildType:ConfigureBuildTypeTesting];///测试环境
#endif
        
        ///不能切换横竖版了
        UserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithFile:kUserInfoPath];
        
        if ([NSKeyedArchiver archiveRootObject:user toFile:kUserInfoPath])
        {
            NSLog(@"用户信息更新成功！");
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
    }
}
