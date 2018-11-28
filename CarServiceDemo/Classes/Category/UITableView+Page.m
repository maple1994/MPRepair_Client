//
//  UITableView+Page.m
//  
//
//  Created by  on 17/3/7.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "UITableView+Page.h"

#import <objc/runtime.h>

const static char kTableViewPageKey;
const static char kTableViewLastPageKey;

@implementation UITableView (Page)

- (void)setPage:(NSInteger)page
{
    objc_setAssociatedObject(self, &kTableViewPageKey, [NSNumber numberWithInteger:page], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)page
{
    NSNumber* pageNum = objc_getAssociatedObject(self, &kTableViewPageKey);
    return pageNum.integerValue;
}

- (void)setLastPage:(NSInteger)lastPage
{
    objc_setAssociatedObject(self, &kTableViewLastPageKey, [NSNumber numberWithInteger:lastPage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)lastPage
{
    NSNumber* lastPageNum = objc_getAssociatedObject(self, &kTableViewLastPageKey);
    return lastPageNum.integerValue;
}

@end
