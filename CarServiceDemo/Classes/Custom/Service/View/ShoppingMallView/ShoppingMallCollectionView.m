//
//  ShoppingMallCollectionView.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShoppingMallCollectionView.h"
#import "ShoppingMallCollectionCell.h"
#import "GoodsModel.h"
#import "ShopDetailWebController.h"

@interface ShoppingMallCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

static NSString *shopMallCellID = @"ShoppingMallCollectionCell";

@implementation ShoppingMallCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor colorwithHexString:@"#F5F5F5"];
        self.delegate = self;
        self.dataSource = self;
        [self registerCollectionView];
    }
    return self;
}

- (void)registerCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 19;
//    flowLayout.minimumInteritemSpacing = 19;
    
    self.collectionViewLayout = flowLayout;
    self.alwaysBounceVertical = YES;
    self.showsVerticalScrollIndicator = NO;
    
    //注册cell
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([ShoppingMallCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:shopMallCellID];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArrM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShoppingMallCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopMallCellID forIndexPath:indexPath];
    GoodsModel *model = self.dataArrM[indexPath.row];
    cell.product_id = model.ID;
    cell.shopTitleLabel.text = model.name;
    cell.shopPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    [NetWorkingUtil setImage:cell.shopImageView url:model.pic_url defaultIconName:KDefaultImage];
    
    return cell;
}

//各空间间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(19, 19, 19, 19);
}

//各cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (SCREEN_WIDTH-19*3)*0.5;
    CGFloat h = 217;
    return CGSizeMake(w, h);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsModel *model = self.dataArrM[indexPath.row];
    ShopDetailWebController *webDetailVC = [[ShopDetailWebController alloc] init];
    webDetailVC.urlStr = model.detail_url;
    [self.viewController.navigationController pushViewController:webDetailVC animated:YES];
}

#pragma mark - 值更新
- (void)setDataArrM:(NSMutableArray *)dataArrM{
    _dataArrM = dataArrM;
    
    [self reloadData];
}

@end
