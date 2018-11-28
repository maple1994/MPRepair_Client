//
//  AddCarAddressView.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/10.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AddCarAddressView.h"
#import "AddCarAddressTableView.h"
#import "CarAddressModel.h"

@interface AddCarAddressView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *leftBackView;
@property (weak, nonatomic) IBOutlet UIView *rightBackView;
@property (strong, nonatomic) AddCarAddressTableView *leftTableView;
@property (strong, nonatomic) AddCarAddressTableView *rightTableView;

@property (copy,nonatomic) NSString *provinceName;
@property (copy,nonatomic) NSString *nowCityName;
@property (copy,nonatomic) NSString *nowCityCode;

@end

@implementation AddCarAddressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:@"AddCarAddressView" owner:self options:nil]lastObject];
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
    
    self.provinceName = @"北京";
    self.nowCityName = @"北京市";
    self.nowCityCode = @"BJ";
    
    [self loadAllData];
}

- (void)loadAllData{
    [MBProgressHUD showStatusOnView:kMAIN_WINDOW withMessage:LoadingMsg];
    
    kWeakSelf(weakSelf)
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/user/caraddress/" parameters:nil result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW];
            
            NSMutableArray *resultArrM = [NSMutableArray array];
            for (NSDictionary *dict in obj) {
                CarAddressModel *model = [[CarAddressModel alloc] initWithDictionary:dict error:nil];
                [resultArrM addObject:model];
            }
            weakSelf.leftTableView.dataArrM = resultArrM;
        }else{
            [MBProgressHUD dismissHUDForView:kMAIN_WINDOW withError:msg];
        }
        
    }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)affirmButtonAction:(id)sender {
    
    if (self.affirmBlock) {
        NSString *tempString = [NSString stringWithFormat:@"%@ %@",self.provinceName,self.rightTableView.nowCityName];
        self.affirmBlock(tempString,self.rightTableView.nowCityCode);
    }
    [self removeFromSuperview];
    
}

#pragma mark - 懒加载
- (AddCarAddressTableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[AddCarAddressTableView alloc] initWithFrame:CGRectMake(0, 0, _leftBackView.width, _leftBackView.height) style:UITableViewStylePlain];
        _leftTableView.isLeft  = YES;
        kWeakSelf(weakSelf)
        _leftTableView.leftSelectBlock = ^(NSString *provinceName, NSMutableArray *rightArrM) {
            weakSelf.provinceName = provinceName;
            weakSelf.rightTableView.dataArrM = rightArrM;
        };
    }
    return _leftTableView;
}

- (AddCarAddressTableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[AddCarAddressTableView alloc] initWithFrame:CGRectMake(0, 0, _rightBackView.width, _rightBackView.height) style:UITableViewStylePlain];
        _rightTableView.isLeft  = NO;
        kWeakSelf(weakSelf)
        _rightTableView.rightSelectBlock = ^(NSString *cityName, NSString *cityCode) {
            weakSelf.nowCityName = cityName;
            weakSelf.nowCityCode = cityCode;
            [weakSelf affirmButtonAction:nil];
        };
    }
    return _rightTableView;
}

@end
