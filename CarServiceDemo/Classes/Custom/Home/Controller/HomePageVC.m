//
//  HomePageVC.m
//  CarServiceDemo
//
//  Created by lj on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageSearchVC.h"
/// 地图相关
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MAInfowindowView.h"
#import "POIAnnotation.h"
#import "LocationAnnotationView.h"
#import "CustonMAPointAnnotation.h"
#import <MapKit/MapKit.h>

#import "ScheduledRepairVC.h"
#import "ServicePointDetailsVC.h"
#import "OrderMaintainController.h"
#import "ViolationInformationView.h"
#import "RepairShopInfoModel.h"
#import "VehicleViolationInfoModel.h"
#import "MyManager.h"
#import "AddCarController.h"


@interface HomePageVC ()<UISearchBarDelegate,MAMapViewDelegate, AMapSearchDelegate>
{
     LocationAnnotationView *_locationAnnotationView;
}
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (weak, nonatomic) IBOutlet UIView *mapContentView;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *gotoMapBtn;

@property (weak, nonatomic) IBOutlet UIButton *currentCityBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;

@property (nonatomic ,strong)NSMutableArray *repairShopInfoDataArr;
@property (nonatomic ,strong)NSMutableArray *vehicleViolationInfoDataArr;

@property (nonatomic ,strong)RepairShopInfoModel *selectRepairShopInfoModel;

@property (weak, nonatomic) IBOutlet UIView *selectRepairShopInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectRepairShopInfoViewHeight;

/// 当前定位
@property (nonatomic ,strong)MAUserLocation *currentLocation;


@property (weak, nonatomic) IBOutlet UIButton *weiXiuBtn;
@property (weak, nonatomic) IBOutlet UIButton *baoYangBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myContentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myContentViewBottom;

@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;

@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

///
@property (nonatomic ,copy)NSString *selectedRepairShopID;
@end

@implementation HomePageVC

#pragma mark -- 懒加载
- (NSMutableArray *)repairShopInfoDataArr{
    if (!_repairShopInfoDataArr) {
        _repairShopInfoDataArr = [NSMutableArray array];
    }
    return _repairShopInfoDataArr;
}

- (NSMutableArray *)vehicleViolationInfoDataArr{
    if (!_vehicleViolationInfoDataArr) {
        _vehicleViolationInfoDataArr = [NSMutableArray array];
    }
    return _vehicleViolationInfoDataArr;
}

- (void)searchPoiKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    request.city = @"广州";
    request.offset = 20;
    [self.search AMapPOIKeywordsSearch:request];
}

#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    if ([view isMemberOfClass:[LocationAnnotationView class]]) {
        return;
    }
    
    CustonMAPointAnnotation *poi =(CustonMAPointAnnotation *)view.annotation;
//    NSString *title = [NSString stringWithFormat:@"%@",poi.title];
    for (RepairShopInfoModel *model in self.repairShopInfoDataArr) {
        if ([model.ID isEqualToString:poi.ID]) {
            self.selectRepairShopInfoModel = model;
            [self setUpSelectRepairShopInfo];
            break;
        }
    }
    
    NSLog(@"poi :%@", poi.address);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isMemberOfClass:[CustonMAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"location"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }else if ([annotation isKindOfClass:[MAUserLocation class]])
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

#pragma mark - AMapSearchDelegate

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        POIAnnotation *anno = [[POIAnnotation alloc] initWithPOI:obj];
        [poiAnnotations addObject:anno];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}



#pragma mark - Initialization

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.mapView setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.mapView setDistanceFilter:kCLLocationAccuracyNearestTenMeters];
//    [self.mapView setCenterCoordinate:userLocation.coordinate];
    [self.mapView setZoomLevel:17.0 animated:NO];
    [self.mapContentView sendSubviewToBack:self.mapView];
    [self.mapContentView addSubview:self.mapView];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
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


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && _locationAnnotationView != nil)
    {
        _locationAnnotationView.rotateDegree = userLocation.heading.trueHeading - _mapView.rotationDegree;
        self.currentLocation = userLocation;
        [self requestRepairShopInfo];
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        regeo.requireExtension = YES;
        [self.search AMapReGoecodeSearch:regeo];
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [self initCLLocationManager];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        NSLog(@"%@-- %@",response.regeocode.addressComponent,response.regeocode.addressComponent.city);
        self.currentCityLabel.text = response.regeocode.addressComponent.city;
        self.user.currentCity = response.regeocode.addressComponent.city;
        //解析response获取地址描述，具体解析见 Demo
    }
}


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

- (void)initSearch
{
    
//    NSMutableArray *paramsArr = [NSMutableArray array];
//    for (int i = 0 ; i< 100 ; i ++) {
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"lat"] = @((23.139226 + (0.001 * i)));
//        params[@"lng"] = @((113.33214 + (0.001 * i)));
//        params[@"titlte"] = @((113.33214 + (0.001 * i)));
//        [paramsArr addObject:params];
//    }
    
//    [self.mapView reloadMap];
    
    if (self.repairShopInfoDataArr.count > 0) {
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        for (int i =0 ;i < self.repairShopInfoDataArr.count ; i++) {
            RepairShopInfoModel *model = self.repairShopInfoDataArr[i];

            CustonMAPointAnnotation *pointAnnotation = [[CustonMAPointAnnotation alloc] init];

            CLLocationDegrees lat = [model.latitude doubleValue];
            CLLocationDegrees lng = [model.longitude doubleValue];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
            pointAnnotation.title = model.name;
            pointAnnotation.subtitle = model.address;
            pointAnnotation.address =model.address;
            pointAnnotation.mobi =model.mobile_phone;
            //        pointAnnotation.star =params[@"titlte"];
            //        pointAnnotation.juli =model.ju;
            pointAnnotation.ID =model.ID;
            [self.mapView addAnnotation:pointAnnotation];


        }
        if (!self.selectRepairShopInfoModel) {
            if (self.repairShopInfoDataArr.count > 0) {
                self.selectRepairShopInfoModel = self.repairShopInfoDataArr[0];
                [self setUpSelectRepairShopInfo];
                self.selectRepairShopInfoView.hidden = NO;
                self.gotoMapBtn.hidden = NO;
                self.weiXiuBtn.hidden = NO;
                self.baoYangBtn.hidden = NO;
                self.selectRepairShopInfoViewHeight.constant = 148;
            }
            
        }else{
            for (RepairShopInfoModel *model in self.repairShopInfoDataArr) {
                if ([self.selectRepairShopInfoModel.ID isEqualToString:model.ID]) {
                    self.selectRepairShopInfoModel = model;
                    [self setUpSelectRepairShopInfo];
                    break;
                }
            }
        }
        
    }
  
}

- (void)setUpSelectRepairShopInfo{
    self.addressLabel.text =[NSString stringWithFormat:@"距您%.01f公里   %@", self.selectRepairShopInfoModel.distance.floatValue,self.selectRepairShopInfoModel.address] ;
    self.nameLabel.text = self.selectRepairShopInfoModel.name;
    for (int i = 0 ; i < 5; i++) {
        UIImageView *imageView = [self.view viewWithTag:100+i];
        if (i < self.selectRepairShopInfoModel.score.integerValue) {
            
            imageView.hidden = NO;
            
        }else{
            
            imageView.hidden = YES;
        }
        
    }
    
    
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


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupProperty];
    
    [self initCLLocationManager];
    
    [self initMapView];
    
//    [self initSearch];
//    [self searchPoiKeyword:@"汽车维修"];
    /// 请求汽修厂详情
    
    
//    /// 请求违章信息
//    AppDelegate *delegate =[[UIApplication sharedApplication] delegate];
    if (self.appDelegate.rootViewControllerType != RootViewControllerTypeMain) {
        [self requestVehicleViolationInfo];
        [self loadCarData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//    if(self.repairShopInfoDataArr.count == 0){
//        [self requestRepairShopInfo];
//    }
    
    if (@available(iOS 11.0, *)) {//防止Y轴偏移64像素
        
    } else {
        self.myContentViewTop.constant = 20;
        self.myContentViewBottom.constant = -54;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setupProperty{
    
    
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    //设置背景图片
    [_searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
    [_searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor colorwithHexString:@"A3A3A3"];
    [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [searchField setValue:[UIColor colorwithHexString:@"A3A3A3"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.serviceBtn setCornerRadius:14];
    [self.callPhoneBtn setCornerRadius:14];
    self.callPhoneBtn.layer.borderColor = [UIColor colorWithHexStringToRGB:@"3CADFF"].CGColor;
    self.callPhoneBtn.layer.borderWidth = 1.0;
    [self scheduledRepairBtnAction:self.weiXiuBtn];
    [self.locationBtn setCornerRadius:4];
}


- (void)loadCarData{
    
    kWeakSelf(weakSelf)
    [MyManager getCarportListDataIsDefault:YES successBlock:^(NSMutableArray *result) {
        if (result.count==0) {
            AddCarController *addCarVC = [[AddCarController alloc]init];
            [weakSelf.navigationController pushViewController:addCarVC animated:YES];
        }
    } failBlock:^(id error) {
    }];
}
/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 请求维修点信息
- (void)requestRepairShopInfo{
    
    kWeakSelf(weakSelf);
    
//    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderby"] = @"all";

    params[@"latitude"] = @(self.currentLocation.coordinate.latitude);
    params[@"longitude"] = @(self.currentLocation.coordinate.longitude);

    [self.util getDataWithPath:@"/api/maintain/garage/" parameters:params result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            weakSelf.repairShopInfoDataArr = nil;
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                for (NSDictionary *modelDict in obj) {
                    RepairShopInfoModel *model =[[RepairShopInfoModel alloc]initWithDictionary:modelDict error:nil];
                    [weakSelf.repairShopInfoDataArr addObject:model];
                }
            }
            [weakSelf initSearch];
            
//            [MBProgressHUD dismissHUDForView:weakSelf.view];
            
        }else{
            
//            [MBProgressHUD dismissHUDForView:weakSelf.view];

        }
    }];
    
}

#pragma mark -- 请求车辆违章信息
- (void)requestVehicleViolationInfo{
    
    kWeakSelf(weakSelf);
    
    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
    
    [self.util getDataWithPath:@"/api/service/rules/" parameters:nil result:^(id obj, int status, NSString *msg) {
        if (status == 1) {
            if (obj && [obj isKindOfClass:[NSArray class]]) {
                for (NSDictionary *modelDict in obj) {
                    VehicleViolationInfoModel *model =[[VehicleViolationInfoModel alloc]initWithDictionary:modelDict error:nil];
                    [weakSelf.vehicleViolationInfoDataArr addObject:model];
                }
            }
            
            [MBProgressHUD dismissHUDForView:weakSelf.view];

            
            if(weakSelf.vehicleViolationInfoDataArr.count > 0){
                ViolationInformationView *view =[ViolationInformationView violationInformationViewWithDataArr:weakSelf.vehicleViolationInfoDataArr];
                view.frame = CGRectMake(0, 0, SafeAreaWidth, SafeAreaHeight);
                [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:view];
            }
            
        }else{
            
            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
            
        }
    }];
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    HomePageSearchVC *searchVC = [[HomePageSearchVC alloc]init];
    searchVC.currentLng = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    searchVC.currentLat = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    [self.navigationController pushViewController:searchVC animated:YES];
    
    [self.view endEditing:YES];
    [searchBar resignFirstResponder];
    return NO;
}


- (IBAction)scheduledRepairBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.baoYangBtn.selected = NO;

}


- (IBAction)gotoMapBtnAction:(UIButton *)sender {
    ///能否打开高德地图
    BOOL flag2 = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://map/"]];
    

    UIAlertController *AC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (1) {
        
        UIAlertAction *op = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.selectRepairShopInfoModel.latitude doubleValue], [self.selectRepairShopInfoModel.longitude doubleValue]);
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
            toLocation.name = self.selectRepairShopInfoModel.name;
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
                                    self.selectRepairShopInfoModel.name,
                                    [self.selectRepairShopInfoModel.latitude doubleValue],
[self.selectRepairShopInfoModel.longitude doubleValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (IBAction)gotoDetailsVCBtnAction:(UIButton *)sender {
    
    ServicePointDetailsVC *detailsVC = [[ServicePointDetailsVC alloc]init];
    detailsVC.dataModel = self.selectRepairShopInfoModel;

    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (IBAction)gotoReservationVCBtnAction:(UIButton *)sender {
    if (self.appDelegate.rootViewControllerType == RootViewControllerTypeMain) {
        [self.appDelegate switchRootViewControllerWithType:RootViewControllerTypeLogin];
    }
    if (!self.weiXiuBtn.selected && !self.baoYangBtn.selected) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择维修或者保养进行预约!"];
        return;
    }
    if (self.weiXiuBtn.selected) {
        
        ScheduledRepairVC *repairaVC = [[ScheduledRepairVC alloc]init];
        repairaVC.dataModel = self.selectRepairShopInfoModel;
        [self.navigationController pushViewController:repairaVC animated:YES];
    }else{
        
        OrderMaintainController *maintainVC = [[OrderMaintainController alloc]init];
        maintainVC.dataModel = self.selectRepairShopInfoModel;
        
        [self.navigationController pushViewController:maintainVC animated:YES];
    }
    
   
}

- (IBAction)gotoOrderMaintainVCBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.weiXiuBtn.selected = NO;
    
}


- (IBAction)callPhoneBtnAction:(UIButton *)sender {
    NSString *str = @"";
    
    if ([ValidateUtil isEmptyStr:self.selectRepairShopInfoModel.mobile_phone] && self.selectRepairShopInfoModel.phone) {
        [MBProgressHUD showMessagOnView:self.view withMessage:@"暂无联系电话，请导航到店！"];
        return;
    }
    
    if (![ValidateUtil isEmptyStr:self.selectRepairShopInfoModel.phone]) {
        str = self.selectRepairShopInfoModel.phone;
    }
    
    if (![ValidateUtil isEmptyStr:self.selectRepairShopInfoModel.mobile_phone]) {
        str = self.selectRepairShopInfoModel.mobile_phone;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", str]]];
}


- (IBAction)locationBtnAction:(id)sender {
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }
    else
    {
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}


@end