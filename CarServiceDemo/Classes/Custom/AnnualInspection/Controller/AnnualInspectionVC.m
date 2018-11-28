//
//  AnnualInspectionVC.m
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionVC.h"
#import "AnnualInspectionNoteVC.h"
#import "AnnualInspectionHistoryVC.h"
#import "AnnualInspectionTypeSelectionView.h"
#import "AnnualInspectionSelfDrivingNoteVC.h"

@interface AnnualInspectionVC ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIButton *gotoAboutAnnualInspectionBtn;

@end

@implementation AnnualInspectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
    
    [self requestDataFromUrl];
    
}

- (void)loadAllView{
    [_topBackView addSubview:self.cycleScrollView];
    kWeakSelf(weakSelf)
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.topBackView);
    }];
}

- (void)loadAllData{
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

- (void)requestDataFromUrl{
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    
    [self.util getDataWithPath:@"/api/system/surveyimg/" parameters:nil result:^(id obj, int status, NSString *msg) {
        if (status ==1) {
            
            if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                NSString *pic_url = [NSString stringWithFormat:@"%@", [obj valueForKey:@"pic_url"]];
                
                UIImageView *imageView = [[UIImageView alloc]init];
                [NetWorkingUtil setImage:imageView url:pic_url defaultIconName:KDefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    [weakSelf.gotoAboutAnnualInspectionBtn setBackgroundImage:imageView.image forState:UIControlStateNormal];
                    
                }];
                id dirArr = [obj valueForKey:@"pic_url_list"];
                if (dirArr && [dirArr isKindOfClass:[NSArray class]]) {
                    
                    weakSelf.cycleScrollView.localizationImageNamesGroup = dirArr;
                    
                }
                
                
            }
            
            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
        }else{
            
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
    
    
}

#pragma mark - 菜单点击事件
- (IBAction)menuButtonAction:(UIButton *)sender {
    if (self.appDelegate.rootViewControllerType == RootViewControllerTypeMain) {
        [self.appDelegate switchRootViewControllerWithType:RootViewControllerTypeLogin];
    }
    if (sender.tag == 101) {
        kWeakSelf(weakSelf);
        AnnualInspectionTypeSelectionView * view =[AnnualInspectionTypeSelectionView annualInspectionTypeSelectionViewHandle:^(AnnualInspectionType type) {
            if (type == AnnualInspectionTypeDriverAnnualInspection) {
                AnnualInspectionNoteVC *noteVC = [[AnnualInspectionNoteVC alloc]init];
                [weakSelf.navigationController pushViewController:noteVC animated:YES];

            }else{
                AnnualInspectionSelfDrivingNoteVC *selfDrivingNote = [[AnnualInspectionSelfDrivingNoteVC alloc]init];
                [weakSelf.navigationController pushViewController:selfDrivingNote animated:YES];
                
            }
        }];
        view.frame = CGRectMake(0, 0, SafeAreaWidth, SafeAreaHeight - 49);
        [self.view addSubview:view];
        
    }else if (sender.tag == 102){
        AnnualInspectionHistoryVC *historyVC = [[AnnualInspectionHistoryVC alloc]init];
        [self.navigationController pushViewController:historyVC animated:YES];
        
    }
}

#pragma mark - 进入关于年检
- (IBAction)gotoAboutAnnualInspectionButtonAction:(id)sender {
    
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _topBackView.height) imageURLStringsGroup:nil];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
        _cycleScrollView.localizationImageNamesGroup = [NSArray arrayWithObjects:@"placeholderImage", nil];

    }
    return _cycleScrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
