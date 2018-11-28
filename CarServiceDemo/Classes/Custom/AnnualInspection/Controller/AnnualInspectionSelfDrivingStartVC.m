//
//  AnnualInspectionSelfDrivingStartVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/22.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AnnualInspectionSelfDrivingStartVC.h"
/// 地图相关
#import <MAMapKit/MAMapKit.h>
#import "LocationAnnotationView.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AnnualInspectionSelfDrivingStartVC ()<MAMapViewDelegate>
{
    LocationAnnotationView *_locationAnnotationView;
}
@property (nonatomic, strong) MAMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *mapContentView;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIButton *mapNavigationBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation AnnualInspectionSelfDrivingStartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupProperty];

    [self initMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupProperty{
    self.title = @"开始年检";
    self.label1.text = [NSString stringWithFormat:@"车型：%@",self.dataModel.car_type];
    self.label2.text = [NSString stringWithFormat:@"年检地点：%@",self.dataModel.surveystation.address];
    self.label3.text = [NSString stringWithFormat:@"年检时间：%@",self.dataModel.subscribe_time];
    [self.mapNavigationBtn setCornerRadius:4];

    if (self.dataModel.state.integerValue == 3) {// 到达年检
        self.confirmBtn.hidden = NO;
    }
    if([self.dataModel.state isEqualToString:@"0"] || [self.dataModel.state isEqualToString:@"3"]){
        UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        rightBtn.titleLabel.textColor =[UIColor whiteColor];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn addTarget:self action:@selector(cancelOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    }
    
    
}

- (void)cancelOrderBtnAction{
    kWeakSelf(weakSelf);
    [ConfirmAndCancelAlertWebView confirmAndCancelAlertWebViewWithTitle:@"用户协议" WebUrl:@"http://www.nolasthope.cn/survey/surveyinfo/" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"确认取消" ConfirmBtnTitleColor:[UIColor colorWithHexStringToRGB:@"3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@"我再想想" CancelBtnTitleColor:[UIColor colorWithHexStringToRGB:@"9B9B9B"] Handle:^(AlertViewSelectState selectState) {
        if (selectState == AlertViewSelectStateConfirm) {
            [weakSelf cancelOrder];
        }else{
            
        }
        
    }];
    
}


- (void)cancelOrder{
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    kWeakSelf(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.dataModel.ID;
    params[@"method"] = @"cancel";

    [self.util postDataWithPath:@"/api/survey/survey_selfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
}

#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapContentView.bounds];
    self.mapView.delegate = self;
    [self.mapView setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.mapView setDistanceFilter:kCLLocationAccuracyBest];
    [self.mapView setZoomLevel:15.0 animated:NO];
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.mapView.showsUserLocation = YES;
    [self.mapContentView addSubview:self.mapView];

}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        accuracyCircleRenderer.lineWidth    = 2.f;
        accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleRenderer;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[LocationAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:userLocationStyleReuseIndetifier];
            
            annotationView.canShowCallout = YES;
        }
        
        _locationAnnotationView = (LocationAnnotationView *)annotationView;
        [_locationAnnotationView updateImage:[UIImage imageNamed:@"userPosition"]];
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && _locationAnnotationView != nil)
    {
        _locationAnnotationView.rotateDegree = userLocation.heading.trueHeading - _mapView.rotationDegree;
    }
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];

}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    [self initCLLocationManager];
    
}


#pragma mark -- 初始化百度地图定位
- (void)initCLLocationManager
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        ///请求权限
        [[[CLLocationManager alloc] init] requestWhenInUseAuthorization];
        
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        //        NSLog(@"定位功能不可用，提示用户或忽略");
        
        UIAlertController *AC = [UIAlertController alertControllerWithTitle:@"定位失败，请打开定位开关！" message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *op = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //Location Services — prefs:root=LOCATION_SERVICES
//            NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
            
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//
//                [[UIApplication sharedApplication] openURL:url];
//
//            }else{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            }
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [AC addAction:op];
        [AC addAction:cancelAction];
        
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:AC animated:YES completion:nil];
    }else{
        
        self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        
    }
}

#pragma mark -- 确认支付按钮事件
- (void)confirmPay{
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.dataModel.ID;
    params[@"method"] = @"survey";
    
    kWeakSelf(weakSelf);
    
    [self.util postDataWithPath:@"/api/survey/survey_selfmethod/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
    
}
- (IBAction)confirmBtnAction:(id)sender {
    [self confirmPay];
}

- (IBAction)gotoMapBtnAction:(UIButton *)sender {
    ///能否打开高德地图
    BOOL flag2 = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]];
    
    
    UIAlertController *AC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (1) {
        
        UIAlertAction *op = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.dataModel.order_latitude doubleValue], [self.dataModel.order_longitude doubleValue]);
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
            toLocation.name = self.dataModel.surveystation.name;
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            
        }];
        
        [AC addAction:op];
    }
    
    if (flag2) {
        
        UIAlertAction *gaodeMapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *gaodeParameterFormat = @"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2";
            NSString *urlString = [[NSString stringWithFormat:
                                    gaodeParameterFormat,
                                    @"1号养车",
                                    @"com.from.CarServiceDemo",
                                    self.dataModel.surveystation.name,
                                    [self.dataModel.surveystation.latitude doubleValue],
                                    [self.dataModel.surveystation.longitude doubleValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }];
        [AC addAction:gaodeMapAction];
        
    }
    
    
    UIAlertAction *op = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [AC addAction:op];
    
    
    UIPopoverPresentationController *popover = AC.popoverPresentationController;
    
    if (popover) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-150, SCREEN_HEIGHT*0.5+50, 0.1, 0.1)];
        [self.view addSubview:view];
        
        popover.sourceView = view;
        popover.sourceRect = view.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:AC animated:YES completion:nil];
    
}

- (IBAction)callPhoneBtnAction:(id)sender {
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    

    kWeakSelf(weakSelf);
    
    [self.util getDataWithPath:@"/api/survey/survey_phone/" parameters:nil result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withsuccess:msg];

            if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                
                NSString *phone = [obj valueForKey:@"phone"];
                NSString *moblie_phone = [obj valueForKey:@"moblie_phone"];
                if (![ValidateUtil isEmptyStr:phone]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]];
                }else if(![ValidateUtil isEmptyStr:moblie_phone]){
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", moblie_phone]]];

                }
            }
            
        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
        }
    }];
    
}


@end
