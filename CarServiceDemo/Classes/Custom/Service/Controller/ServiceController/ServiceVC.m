//
//  ServiceVC.m
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ServiceVC.h"
#import "ShoppingMallController.h"
#import "NewsViewController.h"
#import "InsuranceController.h"
#import "ServiceManager.h"
#import "AboutOurWebController.h"

@interface ServiceVC ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIButton *aboutOurButton;
@property (weak, nonatomic) IBOutlet UILabel *insuranceLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceDetailLabel;
@property (copy, nonatomic) NSString *aboutUrlStr;

@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewHeight;

@end

@implementation ServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
    [_aboutOurButton addTarget:self action:@selector(preventHighlight) forControlEvents:UIControlEventAllEvents];
}

- (void)loadAllView{
    [_topBackView addSubview:self.cycleScrollView];
    kWeakSelf(weakSelf)
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.topBackView);
    }];
    
    if (weakSelf.user.is_pass) {
        _insuranceLabel.text = @"代办保险";
        _insuranceDetailLabel.text = @"汽车保险服务";
    }
    if (self.user.is_pass) {
        self.menuView.hidden = NO;
        self.menuViewHeight.constant = 195;
        
    }else{
        self.menuView.hidden = YES;
        self.menuViewHeight.constant = 0;
    }
}

- (void)loadAllData{
    kWeakSelf(weakSelf)
    [ServiceManager getServiceHomePictureDataSuccessBlock:^(NSDictionary *result) {
        if (result) {
            [weakSelf.aboutOurButton sd_setBackgroundImageWithURL:[NSURL URLWithString:result[@"pic_url"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:KDefaultImage]];
            weakSelf.cycleScrollView.localizationImageNamesGroup = result[@"pic_url_list"];
        }
        
    } failBlock:^(id error) {
    }];
    [ServiceManager getAboutOurUrlStrSuccessBlock:^(NSString *result) {
        weakSelf.aboutUrlStr = result;
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

#pragma mark - 菜单点击事件
- (IBAction)menuButtonAction:(UIButton *)sender {
    if (sender.tag == 101) {
        [MBProgressHUD showMessagOnView:self.view withMessage:@"购物商场功能，敬请期待"];
        
//        ShoppingMallController *shoppingMallVC = [[ShoppingMallController alloc] init];
//        [self.navigationController pushViewController:shoppingMallVC animated:YES];
    }else if (sender.tag == 102){
        [MBProgressHUD showMessagOnView:self.view withMessage:[NSString stringWithFormat:@"%@功能，敬请期待",_insuranceLabel.text]];
        
//        InsuranceController *insuranceVC = [[InsuranceController alloc] init];
//        [self.navigationController pushViewController:insuranceVC animated:YES];
    }else if (sender.tag == 103){
        [MBProgressHUD showMessagOnView:self.view withMessage:@"行业资讯功能，敬请期待"];
        
//        NewsViewController *newsVC = [[NewsViewController alloc] init];
//        [self.navigationController pushViewController:newsVC animated:YES];
    }else if (sender.tag == 104){
        [MBProgressHUD showMessagOnView:self.view withMessage:@"更多服务功能，敬请期待"];
    }
}

#pragma mark - 进入关于我们
- (IBAction)gotoAboutOurMessageButtonAction:(id)sender {
    [MBProgressHUD showMessagOnView:self.view withMessage:@"关于我们功能，敬请期待"];
    
//    AboutOurWebController *aboutWebVC = [[AboutOurWebController alloc] init];
//    aboutWebVC.urlStr = self.aboutUrlStr;
//    [self.navigationController pushViewController:aboutWebVC animated:YES];
}

- (void)preventHighlight {
    _aboutOurButton.highlighted = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
