//
//  MapLocationSelectionAddressVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/14.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "MapLocationSelectionAddressVC.h"
#import <MAMapKit/MAMapKit.h>
#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "PlaceAroundTableView.h"
#import <AMapFoundationKit/AMapFoundationKit.h>


@interface MapLocationSelectionAddressVC ()<MAMapViewDelegate, AMapSearchDelegate, PlaceAroundTableViewDeleagate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mapBagView;

@property (strong, nonatomic)MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI        *search;
@property (nonatomic, strong) AMapSearchAPI        *tipSearch;

@property (weak, nonatomic) IBOutlet PlaceAroundTableView *tableview;

@property (nonatomic, strong) UIImageView          *centerAnnotationView;
@property (nonatomic, assign) BOOL                  isMapViewRegionChangedFromTableView;

@property (nonatomic, assign) BOOL                  isLocated;

@property (nonatomic, strong) UIButton             *locationBtn;
@property (nonatomic, strong) UIImage              *imageLocated;
@property (nonatomic, strong) UIImage              *imageNotLocate;

@property (nonatomic, assign) NSInteger             searchPage;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *searchTableBagView;


@property (nonatomic, strong) NSMutableArray *searchPoiArray;
@property (nonatomic, strong) AMapPOI *selectedPoi;

@property (nonatomic, assign) BOOL isFromMoreButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnWidth;

@end

@implementation MapLocationSelectionAddressVC

#pragma mark - Utility

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiWithCenterCoordinate:(CLLocationCoordinate2D )coord
{
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coord.latitude  longitude:coord.longitude];
    
    request.radius   = 1000;
//    request.types = self.currentType;
    request.sortrule = 0;
    request.page     = self.searchPage;
    
    [self.search AMapPOIAroundSearch:request];
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}

#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == MAUserTrackingModeNone)
    {
        [self actionSearchAroundAt:self.mapView.centerCoordinate];
    }
    self.isMapViewRegionChangedFromTableView = NO;
}

#pragma mark - TableViewDelegate

- (void)didTableViewSelectedChanged:(AMapPOI *)selectedPoi
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(selectedPoi.location.latitude, selectedPoi.location.longitude);
    
    [self.mapView setCenterCoordinate:location animated:YES];
}

- (void)didTableViewSelectedTipChanged:(AMapTip *)selectedPoi
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(selectedPoi.location.latitude, selectedPoi.location.longitude);
    
    [self.mapView setCenterCoordinate:location animated:YES];
    [self actionSearchAroundAt:location];
}


- (void)didPositionCellTapped
{
    // 防止连续点两次
    if(self.isMapViewRegionChangedFromTableView == YES)
    {
        return;
    }
    
    self.isMapViewRegionChangedFromTableView = YES;
    
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)didLoadMorePOIButtonTapped
{
    self.searchPage++;
    [self searchPoiWithCenterCoordinate:self.mapView.centerCoordinate];
}

#pragma mark - userLocation

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(!updatingLocation)
        return ;
    
    if (userLocation.location.horizontalAccuracy < 0)
    {
        return ;
    }
    
    // only the first locate used.
    if (!self.isLocated)
    {
        self.isLocated = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
        [self actionSearchAroundAt:userLocation.location.coordinate];
    }
}

- (void)mapView:(MAMapView *)mapView  didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MAUserTrackingModeNone)
    {
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    }
    else
    {
        [self.locationBtn setImage:self.imageLocated forState:UIControlStateNormal];
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}

#pragma mark - Handle Action

- (void)actionSearchAroundAt:(CLLocationCoordinate2D)coordinate
{
    [self searchReGeocodeWithCoordinate:coordinate];
    [self searchPoiWithCenterCoordinate:coordinate];
    
    self.searchPage = 1;
    [self centerAnnotationAnimimate];
}

- (void)actionLocation
{
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }
    else
    {
        self.searchPage = 1;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
}


#pragma mark - Initialization

- (void)initMapView
{
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.mapBagView.bounds];
    self.mapView.distanceFilter = kCLLocationAccuracyBest;
    self.mapView.desiredAccuracy = kCLLocationAccuracyBest;
    self.mapView.delegate = self;
    [self.mapBagView addSubview:self.mapView];
    
    self.isLocated = NO;
}

- (void)initSearch
{
    self.searchPage = 1;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self.tableview;
    
    self.tipSearch = [[AMapSearchAPI alloc]init];
    self.tipSearch.delegate = self;
}

- (void)initTableview{
//    self.tableview = [[PlaceAroundTableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height/2)];
    self.tableview.delegate = self;
    
//    [self.view addSubview:self.tableview];
}

- (void)initCenterView
{
    self.centerAnnotationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wateRedBlank"]];
    self.centerAnnotationView.center = CGPointMake(self.mapView.center.x, self.mapView.center.y - CGRectGetHeight(self.centerAnnotationView.bounds) / 2);
    
    [self.mapView addSubview:self.centerAnnotationView];
}

- (void)initLocationButton
{
    self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
    self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
    
    self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.mapView.bounds) - 40, CGRectGetHeight(self.mapView.bounds), 32, 32)];
    self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.locationBtn.backgroundColor = [UIColor whiteColor];
    
    self.locationBtn.layer.cornerRadius = 3;
    [self.locationBtn addTarget:self action:@selector(actionLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];
    
    [self.view addSubview:self.locationBtn];
}


/* 移动窗口弹一下的动画 */
- (void)centerAnnotationAnimimate
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y -= 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
    
    [UIView animateWithDuration:0.45
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGPoint center = self.centerAnnotationView.center;
                         center.y += 20;
                         [self.centerAnnotationView setCenter:center];}
                     completion:nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.textColor =[UIColor whiteColor];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    UIButton *leftBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.textColor =[UIColor whiteColor];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self initTableview];

    [self initSearch];
    [self initMapView];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initCenterView];
    [self initLocationButton];
    
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.searchTableBagView.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.cancelBtnWidth.constant = 40;
    [self.navigationController  setNavigationBarHidden:YES animated:NO];
//    [self.view layoutIfNeeded];
//    [self.view layoutSubviews];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchTipsWithKey:searchBar.text];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchTableBagView.hidden = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchTableBagView.hidden = YES;
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    self.searchTableBagView.hidden = YES;
    self.cancelBtn.hidden = YES;
    self.cancelBtnWidth.constant = 0;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.navigationController  setNavigationBarHidden:NO animated:NO];
//    [self.view layoutIfNeeded];
//    [self.view layoutSubviews];
}

#pragma mark - Utility

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = @"广州";
    tips.cityLimit = YES;
    [self.tipSearch AMapInputTipsSearch:tips];
}


#pragma mark - Interface

- (AMapPOI *)selectedTableViewCellPoi
{
    return self.selectedPoi;
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    
    [self.searchPoiArray setArray:response.tips];
    [self.searchTableView reloadData];
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.mapView removeAnnotations:self.mapView.annotations];
    
    AMapTip *tip = self.searchPoiArray[indexPath.row];
    
    if (tip.uid != nil && tip.location != nil) /* 可以直接在地图打点  */
    {
        [self didTableViewSelectedTipChanged:tip];
    }
    [self searchPOIWithTip:tip];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    self.searchTableBagView.hidden = YES;
    [self cancelBtnAction:self.cancelBtn];
}

- (void)searchPOIWithTip:(AMapTip *)tip
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.cityLimit = YES;
    request.keywords         = tip.name;
    request.city             = @"广州";
    request.requireExtension = YES;
    [self.search AMapPOIKeywordsSearch:request];
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//}

#pragma mark - UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedIndentifier = @"reusedIndentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIndentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusedIndentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    }
    
    AMapPOI *poi = self.searchPoiArray[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchPoiArray.count == 0) {
        self.searchTableView.hidden = YES;
    }else{
        self.searchTableView.hidden = NO;
    }
    return self.searchPoiArray.count;
}


#pragma mark - Handle Action

- (void)actionMoreButtonTapped
{
    // 防止快速连续点两次
    if (self.isFromMoreButton == YES)
    {
        return;
    }
    
    self.isFromMoreButton = YES;
    [self didLoadMorePOIButtonTapped];
}

#pragma mark - Initialization

- (NSMutableArray *)searchPoiArray
{
    if (_searchPoiArray == nil)
    {
        _searchPoiArray = [[NSMutableArray alloc] init];
    }
    return _searchPoiArray;
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


- (void)confirmBtnAction{
    
    if (self.delegte && [self.delegte respondsToSelector:@selector(getSelectAddress:Lat:lng:)]) {
        [self.delegte getSelectAddress:self.tableview.currentSelectAddress Lat:self.tableview.currentlat lng:self.tableview.currentlng];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)cancelBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
}

@end
