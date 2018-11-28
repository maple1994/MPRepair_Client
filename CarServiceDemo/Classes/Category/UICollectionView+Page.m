//
//  UICollectionView+Page.m
//  
//
//  Created by mac on 2017/8/29.
//  Copyright © 2017年 com.. All rights reserved.
//

#import "UICollectionView+Page.h"
#import <objc/runtime.h>

const static char kTableViewPageKey;
const static char kTableViewLastPageKey;

@implementation UICollectionView (Page)

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
