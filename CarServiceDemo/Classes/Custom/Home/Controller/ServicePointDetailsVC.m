//
//  ServicePointDetailsVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ServicePointDetailsVC.h"
#import <MapKit/MapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "ScheduledRepairVC.h"
#import "OrderMaintainController.h"

@interface ServicePointDetailsVC () <UINavigationControllerDelegate,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
/// 名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/// 固定电话
@property (weak, nonatomic) IBOutlet UILabel *mobiLabel;
/// 分值
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
/// 联系人信息
@property (weak, nonatomic) IBOutlet UILabel *contactInfoLabel;
/// 地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/// 路线导航按钮
@property (weak, nonatomic) IBOutlet UIButton *routeNavigationBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myContentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myContentViewBottom;

@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;
@property (nonatomic, strong) AMapNaviCompositeManager *mgr;

@end

@implementation ServicePointDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
    /// 初始化页面
    [self setupProperty];
    
    /// 加载广告view
    [self loadAllView];

}

- (void)setupProperty{
    self.title = @"维修厂详情";
    self.routeNavigationBtn.layer.borderColor = [UIColor colorwithHexString:@"3CADFF"].CGColor;
    self.routeNavigationBtn.layer.borderWidth = 1;
    self.scoreLabel.text = self.dataModel.popular;
    self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",self.dataModel.address];
    self.nameLabel.text = self.dataModel.name;
    self.contactInfoLabel.text = [NSString stringWithFormat:@"联系人：%@ | %@",self.dataModel.user_name,self.dataModel.phone];
    self.mobiLabel.text = [NSString stringWithFormat:@"固定电话：%@",self.dataModel.mobile_phone];
    [self.callPhoneBtn setCornerRadius:4];
    [self.routeNavigationBtn setCornerRadius:4];
    
    for (int i = 0 ; i < 5; i++) {
        UIImageView *imageView = [self.view viewWithTag:100+i];
        if (i < self.dataModel.score.integerValue) {
            
            imageView.hidden = NO;
            
        }else{
            
            imageView.hidden = YES;
        }
        
    }
    if (self.dataModel.pic_url) {
     self.cycleScrollView.imageURLStringsGroup = @[self.dataModel.pic_url];
    }
//    if (@available(iOS 11.0, *)) {//防止Y轴偏移64像素
//
//    } else {
//        self.myContentViewTop.constant = 20;
//        self.myContentViewBottom.constant = -54;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

    
}

#pragma mark - 加载广告view
- (void)loadAllView{
    [_topBackView addSubview:self.cycleScrollView];
    [self.topBackView sendSubviewToBack:self.cycleScrollView];
    kWeakSelf(weakSelf)
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.topBackView);
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _topBackView.height) imageURLStringsGroup:nil];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:KDefaultImage];
//        _cycleScrollView.localizationImageNamesGroup = [NSArray arrayWithObjects:@"placeholderImage",@"placeholderImage",@"placeholderImage", nil];
    }
    return _cycleScrollView;
}

- (AMapNaviCompositeManager *) mgr {
    if (!_mgr) {
        _mgr = [[AMapNaviCompositeManager alloc] init];
    }
    return _mgr;
}

#pragma mark -- 路线导航按钮
- (IBAction)routeNavigationBtnAction:(UIButton *)sender {
    double latitude2 = [self.dataModel.latitude doubleValue];
    double longtitude2 = [self.dataModel.longitude doubleValue];
    NSString *desName = self.dataModel.name;
    double latitude1 = self.user.latitude;
    double longtitude1 = self.user.longtitude;
    [MPUtils showNavWithSourceLatitude:latitude1 Sourcelongtitude:longtitude1 desLatitude:latitude2 desLongtitude:longtitude2 desName:desName];
}

#pragma mark -- 联系店家按钮事件
- (IBAction)callPhoneBtnAction:(UIButton *)sender {
    NSString *str = @"13667301013";
    
    if ([ValidateUtil isEmptyStr:self.dataModel.mobile_phone] && self.dataModel.phone) {
        [MBProgressHUD showMessagOnView:self.view withMessage:@"暂无联系电话，请导航到店！"];
        return;
    }
    
    if (![ValidateUtil isEmptyStr:self.dataModel.phone]) {
        str = self.dataModel.phone;
    }
    
    if (![ValidateUtil isEmptyStr:self.dataModel.mobile_phone]) {
        str = self.dataModel.mobile_phone;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", str]]];
}

#pragma mark - 预约维修
- (IBAction)apointmentMaintainAction:(id)sender {
    
    ScheduledRepairVC *repairaVC = [[ScheduledRepairVC alloc]init];
    repairaVC.dataModel = self.dataModel;
    [self.navigationController pushViewController:repairaVC animated:YES];
    
}

#pragma mark - 预约保养
- (IBAction)apointUpkeepAction:(id)sender {
    OrderMaintainController *maintainVC = [[OrderMaintainController alloc]init];
    maintainVC.dataModel = self.dataModel;
    [self.navigationController pushViewController:maintainVC animated:YES];
}

- (IBAction)popBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
