//
//  ShopCategoryView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShopCategoryView.h"
#import "ShopCategoryTableView.h"
#import "ShopingMallManager.h"

@interface ShopCategoryView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *leftBackView;
@property (weak, nonatomic) IBOutlet UIView *rightBackView;
@property (strong, nonatomic) ShopCategoryTableView *leftTableView;
@property (strong, nonatomic) ShopCategoryTableView *rightTableView;
@property (strong, nonatomic) ShopingMallManager *dataManager;

@end

@implementation ShopCategoryView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"ShopCategoryView" owner:self options:nil]lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    [_leftBackView addSubview:self.leftTableView];
    [_rightBackView addSubview:self.rightTableView];
    kWeakSelf(weakSelf)
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.leftBackView);
    }];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.rightBackView);
    }];
    
    [self loadLeftData];
}

- (void)loadLeftData{
    kWeakSelf(weakSelf)
    [self.dataManager getShopingMallTopCategoryDataWithTypeID:@"0" andPID:@"0" isSon:NO successBlock:^(NSMutableArray *result) {
        weakSelf.leftTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

- (void)loadRightDataWithID:(NSString*)ID{
    kWeakSelf(weakSelf)
    [self.dataManager getShopingMallTopCategoryDataWithTypeID:@"0" andPID:ID isSon:NO successBlock:^(NSMutableArray *result) {
        weakSelf.rightTableView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 懒加载
- (ShopCategoryTableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[ShopCategoryTableView alloc] initWithFrame:CGRectMake(0, 0, _leftBackView.width, _leftBackView.height) style:UITableViewStylePlain];
        _leftTableView.isLeft  = YES;
        kWeakSelf(weakSelf)
        _leftTableView.selectBlock = ^(NSString *categoryID) {
            [weakSelf loadRightDataWithID:categoryID];
        };
    }
    return _leftTableView;
}

- (ShopCategoryTableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[ShopCategoryTableView alloc] initWithFrame:CGRectMake(0, 0, _rightBackView.width, _rightBackView.height) style:UITableViewStylePlain];
        _rightTableView.isLeft  = NO;
        kWeakSelf(weakSelf)
        _rightTableView.selectDetailBlock = ^(NSString *categoryID) {
            if (weakSelf.categorySelectBlock) {
                weakSelf.categorySelectBlock(categoryID);
            }
        };
    }
    return _rightTableView;
}

- (ShopingMallManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[ShopingMallManager alloc] init];
    }
    return _dataManager;
}

@end
