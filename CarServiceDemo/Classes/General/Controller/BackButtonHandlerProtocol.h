//
//  BackButtonHandlerProtocol.h
//  Test
//
//  Created by  on 16/7/29.
//  Copyright © 2016年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;

@end
