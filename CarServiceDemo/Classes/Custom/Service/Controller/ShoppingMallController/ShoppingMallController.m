//
//  ShoppingMallController.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/4.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ShoppingMallController.h"
#import "ShoppingMallCollectionView.h"
#import "ShopCategoryView.h"
#import "ShopCartController.h"
#import "ShopingMallManager.h"

@interface ShoppingMallController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *forthButton;
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuButtonArr;
@property (strong, nonatomic) ShoppingMallCollectionView *mainCollectionView;
@property (strong, nonatomic) ShopCategoryView *categoryView;
@property (strong, nonatomic) ShopingMallManager *dataManager;
@property (copy, nonatomic) NSString *priceOrder;
@property (copy, nonatomic) NSString *saleOrder;
@property (copy, nonatomic) NSString *categoryID;
@property (strong, nonatomic) NSMutableArray *topIDArrM;
@property (assign, nonatomic) BOOL firstIIsSelect;

@end

@implementation ShoppingMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    kWeakSelf(weakSelf)
    [_detailBackView addSubview:self.mainCollectionView];
    [_detailBackView addSubview:self.categoryView];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.detailBackView);
    }];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.detailBackView);
    }];
    _firstButton.selected = YES;
    self.categoryID = nil;
    self.priceOrder = nil;
    self.saleOrder = nil;
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    
    [self.dataManager getShopingMallGoodsListDataWithCataLogId:self.categoryID andPriceOrder:self.priceOrder andSaleOrder:self.saleOrder successBlock:^(NSMutableArray *result) {
        weakSelf.mainCollectionView.dataArrM = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - 按钮事件
- (IBAction)firstButtonAction:(id)sender {
    
    if (_firstButton.selected) {
        return;
    }
    
    _firstButton.selected = YES;
    _secondButton.selected = NO;
    _thirdButton.selected = NO;
    _forthButton.selected = NO;
    [self.forthButton setTitleColor:[UIColor colorwithHexString:@"#5B5B5B"] forState:UIControlStateNormal];
    [self.forthButton setImage:[UIImage imageNamed:@"shopDown_black"] forState:UIControlStateNormal];
    
    self.categoryID = nil;
    self.priceOrder = nil;
    self.saleOrder = nil;
    self.categoryView.hidden = YES;
    
    [self loadAllData];
}

- (IBAction)secondButtonAction:(id)sender {
    _firstButton.selected = NO;
    _secondButton.selected = YES;
    _thirdButton.selected = NO;
    self.forthButton.selected = NO;
    if ([ValidateUtil isEmptyStr:self.categoryID]) {
        [self.forthButton setTitleColor:[UIColor colorwithHexString:@"#5B5B5B"] forState:UIControlStateNormal];
        [self.forthButton setImage:[UIImage imageNamed:@"shopDown_black"] forState:UIControlStateNormal];
    }else{
        [self.forthButton setTitleColor:[UIColor colorwithHexString:@"#3CADFF"] forState:UIControlStateNormal];
        [self.forthButton setImage:[UIImage imageNamed:@"shopDown_blue"] forState:UIControlStateNormal];
    }
    
    if (!self.priceOrder||[self.priceOrder isEqualToString:@"2"]||[ValidateUtil isEmptyStr:self.priceOrder]) {
        self.priceOrder = @"1";
        [self.secondButton setImage:[UIImage imageNamed:@"shopDown_blue"] forState:UIControlStateSelected];
    }else if ([self.priceOrder isEqualToString:@"1"]){
        self.priceOrder = @"2";
        [self.secondButton setImage:[UIImage imageNamed:@"shopUp_blue"] forState:UIControlStateSelected];
    }
    self.saleOrder = nil;
    self.categoryView.hidden = YES;
    
    [self loadAllData];
}

- (IBAction)thirdButtonAction:(id)sender {
    _firstButton.selected = NO;
    _secondButton.selected = NO;
    _thirdButton.selected = YES;
    self.forthButton.selected = NO;
    if ( [ValidateUtil isEmptyStr:self.categoryID]) {
        [self.forthButton setTitleColor:[UIColor colorwithHexString:@"#5B5B5B"] forState:UIControlStateNormal];
        [self.forthButton setImage:[UIImage imageNamed:@"shopDown_black"] forState:UIControlStateNormal];
    }else{
        [self.forthButton setTitleColor:[UIColor colorwithHexString:@"#3CADFF"] forState:UIControlStateNormal];
        [self.forthButton setImage:[UIImage imageNamed:@"shopDown_blue"] forState:UIControlStateNormal];
    }
    
    self.priceOrder = nil;
    if (!self.saleOrder||[self.saleOrder isEqualToString:@"2"]||[ValidateUtil isEmptyStr:self.saleOrder]) {
        self.saleOrder = @"1";
        [self.thirdButton setImage:[UIImage imageNamed:@"shopDown_blue"] forState:UIControlStateSelected];
    }else if ([self.saleOrder isEqualToString:@"1"]){
        self.saleOrder = @"2";
        [self.thirdButton setImage:[UIImage imageNamed:@"shopUp_blue"] forState:UIControlStateSelected];
    }
    self.categoryView.hidden = YES;
    
    [self loadAllData];
}

- (IBAction)forthButtonAction:(id)sender {
    
    _forthButton.selected = !_forthButton.selected;
    
    if (_forthButton.selected) {
        if (_firstButton.selected) {
            _firstIIsSelect = YES;
        }else{
            _firstIIsSelect = NO;
        }
        _firstButton.selected = NO;
        self.categoryView.hidden = NO;
    }else{
        if (_firstIIsSelect) {
            _firstButton.selected = YES;
            
        }
        self.categoryView.hidden = YES;
    }
    
    if ([ValidateUtil isEmptyStr:self.categoryID]) {
        [self.forthButton setTitleColor:[UIColor colorwithHexString:@"#5B5B5B"] forState:UIControlStateNormal];
        [self.forthButton setImage:[UIImage imageNamed:@"shopDown_black"] forState:UIControlStateNormal];
    }else{
        [self.forthButton setTitleColor:[UIColor colorwithHexString:@"#3CADFF"] forState:UIControlStateNormal];
        [self.forthButton setImage:[UIImage imageNamed:@"shopDown_blue"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)goShopCartAction:(id)sender {
    ShopCartController *shopCartVC = [[ShopCartController alloc] init];
    [self.navigationController pushViewController:shopCartVC animated:YES];
}

#pragma mark - 懒加载
- (ShoppingMallCollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _mainCollectionView = [[ShoppingMallCollectionView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height) collectionViewLayout:flowLayout];
    }
    return _mainCollectionView;
}

- (ShopCategoryView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[ShopCategoryView alloc] initWithFrame:CGRectMake(0, 0, _detailBackView.width, _detailBackView.height)];
        _categoryView.hidden = YES;
        kWeakSelf(weakSelf)
        _categoryView.categorySelectBlock = ^(NSString *cateforyID) {
            weakSelf.categoryID = cateforyID;
            weakSelf.firstIIsSelect = NO;
            [weakSelf forthButtonAction:nil];
            [weakSelf loadAllData];
        };
    }
    return _categoryView;
}

- (ShopingMallManager *)dataManager{
    if (!_dataManager) {
        _dataManager = [[ShopingMallManager alloc] init];
    }
    return _dataManager;
}

- (NSMutableArray *)topIDArrM{
    if (!_topIDArrM) {
        _topIDArrM = [NSMutableArray array];
    }
    return _topIDArrM;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
