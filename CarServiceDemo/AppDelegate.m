//
//  AppDelegate.m
//  CarServiceDemo
//
//  Created by  on 2018/8/1.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "LoginVC.h"
#import <MAMapKit/MAMapKit.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayManager.h"
#import "JPUSHService.h"
#import "JPushInfoModel.h"

/// 页面跳转相关
#import "MyOrderController.h"

@interface AppDelegate ()<UIScrollViewDelegate>

@property (strong,nonatomic) NSArray *scrollImageArr;
@property (strong,nonatomic) UIPageControl *scrollPage;
@property (strong,nonatomic) UIButton *gotoLogin;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    [[UserInfo userInfo] readLocalData];
    //向微信注册,发起支付必须注册
    [WXApi registerApp:kWeXinKeyID enableMTA:YES];
    
    // 处理推送信息
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo == nil) {
        userInfo = self.userInfo;
    }
    self.userInfo = userInfo;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    
    QMBaseVC *vc= [[QMBaseVC alloc] init];
    vc.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    imageView.image = [UIImage imageNamed:@"Launch"];
    [vc.view addSubview:imageView];
    self.window.rootViewController=vc;
    [self.window makeKeyAndVisible];
    
    ///注册/初始化其他三方的SDK
    [self setupOtherSDKWithOptions:launchOptions];
    
    [self initCLLocationManager];
    
    NSString *installType = [kUserDefault objectForKey:kIsFirstInstall];
    
    if (![ValidateUtil isEmptyStr:installType]&&[installType isEqualToString:@"1"]){
        //不是第一次安装,且没有更新
        [self switchRootViewController];
        [self loadScrollViewImage];
    }else{
        UIViewController *emptyView = [[ UIViewController alloc ]init];
        self.window.rootViewController = emptyView;
        [self createLoadingScrollViewWithType:installType];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLoginView) name:@"LoginCookiesTimeOut" object:nil];
    
    
    return YES;
}
#pragma mark -- 注册/初始化其他三方SDK
- (void)setupOtherSDKWithOptions:(NSDictionary *)launchOptions {
    
    [AMapServices sharedServices].apiKey = @"893cf8537c7f4904b4cf10e0404cb03a";
    UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    //极光注册
    [JPUSHService registerForRemoteNotificationTypes:type categories:nil];
    [JPUSHService  setupWithOption:launchOptions appKey:@"52b368c955e53792d3680657" channel:@"http://www.dalacar.com" apsForProduction: IsProduction];
}

- (void)loadScrollViewImage{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"system"] = @"ios";
    params[@"app_type"] = @"user";
    params[@"version"] = kCurrentAppVersion;
    
    [[NetWorkingUtil netWorkingUtil] getDataWithPath:@"/api/system/cover/" parameters:params result:^(id obj, int status, NSString *msg) {
        
        if (status == 1) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *oldTime = [kUserDefault objectForKey:kIsFirstInstallTime];
                if (![oldTime isEqualToString:obj[@"update_time"]]) {
                    NSArray *imageUrlArr = obj[@"pic_url_list"];
                    
                    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSString * imageFilePath = [docsdir stringByAppendingPathComponent:@"scrollImage"];//将需要创建的串拼接到后面
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    BOOL isDir = NO;
                    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
                    BOOL existed = [fileManager fileExistsAtPath:imageFilePath isDirectory:&isDir];
                    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
                        [fileManager createDirectoryAtPath:imageFilePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    int count = 0;
                    NSEnumerator *enumerator = [[fileManager subpathsAtPath:imageFilePath] objectEnumerator];
                    NSString* fileName;
                    while ((fileName = [enumerator nextObject]) != nil){
                        [fileManager removeItemAtPath:[imageFilePath stringByAppendingPathComponent:fileName] error:nil];
                    }
                    
                    for (NSString *imageUrl in imageUrlArr) {
                        NSString *imagePath = [imageFilePath stringByAppendingString:[NSString stringWithFormat:@"/%d.png",count]];
                        count++;
                        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
                    }
                    
                    [kUserDefault setObject:@"2" forKey:kIsFirstInstall];
                    [kUserDefault setObject:obj[@"update_time"] forKey:kIsFirstInstallTime];
                }
            });
        }
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (application.applicationState == UIApplicationStateActive) {
        if ([UserInfo userInfo].isLogin && self.userInfo) {
            [self dealRemoteNotificationHandleWithDict:self.userInfo];
            //            self.userInfo = nil;
        }
    }
    
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
    
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - 切换window的显示根控制器
- (void)switchRootViewController {
    self.window.rootViewController = [[TabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
}

#pragma mark -- 初始化地图定位
- (void)initCLLocationManager
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        ///请求权限
        [[[CLLocationManager alloc] init] requestWhenInUseAuthorization];
        
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertController *AC = [UIAlertController alertControllerWithTitle:@"定位失败，请打开定位开关！" message:@"定位服务未开启，请进入系统［设置］> [隐私] > [定位服务]中打开开关，并允许使用定位服务！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *op = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [AC addAction:op];
        [AC addAction:cancelAction];
        
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:AC animated:YES completion:nil];
    }
}

#pragma mark - 登录界面
- (void)gotoLoginView {
    [[UserInfo userInfo] removeUserInfo];
    //延时,因为启动makeKeyAndVisible会调用这里,直接使用会导致window混乱
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0000000001 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self switchRootViewController];
    });
    
}

#pragma mark - 引导页
- (void)createLoadingScrollViewWithType:(NSString*)type
{//引导页
    
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:self.window.bounds];
    sc.pagingEnabled = YES;
    sc.delegate = self;
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    [self.window.rootViewController.view addSubview:sc];
    
    NSArray *arr ;
    if (!type) {
        arr = @[@"qidongLogo0",@"qidongLogo1",@"qidongLogo2"];
    }else{
        NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * imageFilePath = [docsdir stringByAppendingPathComponent:@"scrollImage/"];
        NSArray *nameArr = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:imageFilePath error:nil];
        NSSet *set = [NSSet setWithArray:nameArr];
        NSArray *userArray = [set allObjects];
        NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
        NSArray *myary = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
        
        NSMutableArray *tempArrM = [NSMutableArray array];
        if (myary && myary.count !=0 ) {
            for (int i =0 ; i < myary.count; i++) {
                
                UIImage * image = [UIImage imageWithContentsOfFile:[imageFilePath stringByAppendingPathComponent:nameArr[i]]];
                [tempArrM addObject:image];
            }
        }
        
        arr = tempArrM;
    }
    
    if (!arr) {
        [self immediatelyGotoLogin];
    }else{
        self.scrollImageArr = arr;
        for (NSInteger i = 0; i<arr.count; i++)
        {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, self.window.frame.size.height)];
            if (!type) {
                img.image = [UIImage imageNamed:arr[i]];
            }else{
                img.image = arr[i];
            }
            
            [sc addSubview:img];
            img.userInteractionEnabled = YES;
            
            if (i==arr.count-1) {
                self.gotoLogin = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW/2-56, sc.height-KGESTURESHomeHeight-117, 112, 30)];
                [self.gotoLogin setTitle:@"立即体验" forState:UIControlStateNormal];
                [self.gotoLogin setTitleColor:[UIColor colorwithHexString:@"#3CADFF"] forState:UIControlStateNormal];
                [self.gotoLogin setBackgroundImage:[UIImage imageNamed:@"buttonLine_blue"] forState:UIControlStateNormal];
                [self.gotoLogin addTarget:self action:@selector(immediatelyGotoLogin) forControlEvents:UIControlEventTouchUpInside];
                [img addSubview:self.gotoLogin];
                self.gotoLogin.hidden = YES;
            }
        }
        sc.contentSize = CGSizeMake(kScreenW*arr.count, self.window.frame.size.height);
        
        self.scrollPage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, sc.height-KGESTURESHomeHeight-80, kScreenW, 40)];
        self.scrollPage.numberOfPages = arr.count;
        self.scrollPage.currentPage = 0;
        self.scrollPage.pageIndicatorTintColor = [UIColor colorwithHexString:@"#EDEDED"];
        self.scrollPage.currentPageIndicatorTintColor = [UIColor colorwithHexString:@"#333333"];
        self.scrollPage.hidesForSinglePage = YES;
        [self.window.rootViewController.view addSubview:self.scrollPage];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger nowCount = scrollView.contentOffset.x/kScreenW;
    self.scrollPage.currentPage = nowCount;
    
    if (nowCount==self.scrollImageArr.count-1){
        self.gotoLogin.hidden = NO;
    }else{
        self.gotoLogin.hidden = YES;
    }
}

- (void)immediatelyGotoLogin{
    [kUserDefault setObject:@"1" forKey:kIsFirstInstall];
    [self switchRootViewController];
}

#pragma mark - 支付跳转相关
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([url.absoluteString hasPrefix:kWeXinKeyID]) {
        return  [WXApi handleOpenURL:url delegate:[PayManager sharedManager]];
    }else if([url.host isEqualToString:@"safepay"]){
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"AliPay result = %@",resultDic);
            [[PayManager sharedManager] handleOpenURL:resultDic];
        }];
    }
    return YES;
}


//已经获得设备标识符
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{

    [JPUSHService registerDeviceToken:deviceToken];

}

#pragma mark -- 极光推送
//ios7以后
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {


    //代码自定义处理
    [JPUSHService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateBackground) {

        self.userInfo = userInfo;

    }else{

        [self dealRemoteNotificationHandleWithDict:userInfo];
    }

    
    
    completionHandler(UIBackgroundFetchResultNewData);

}

#pragma mark - ///根据推送的内容进入指定的页面
- (void)remoteNotificationHandleWithPath:(NSString*)path {


}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error
{

    NSLog(@"远程消息接收失败");


}

- (void)dealRemoteNotificationHandleWithDict:(NSDictionary *)userInfo{
    if (![UserInfo userInfo].isLogin) {
        return;
    }


    if (userInfo !=nil) {
        NSDictionary *params =userInfo[@"data"];
        JPushInfoModel *infoModel = [[JPushInfoModel alloc]initWithDictionary:params error:nil];

//        NavigationController *rootNavC = (NavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        NavigationController *rootNavC = [[NavigationController alloc]init];
        if ([rootVC isKindOfClass:[TabBarViewController class]]) {
            TabBarViewController* tabVC = (TabBarViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            
            rootNavC = tabVC.viewControllers[tabVC.selectedIndex];
            
        }
        else if ([rootVC isKindOfClass:[NavigationController class]])
        {
            
            rootNavC = (NavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            
        }
       
            if (rootNavC) {
                if ([infoModel.type isEqualToString:@"maintain_order"]) {
                    if (infoModel.data.state.boolValue) {
                        
                        [OnlyConfirmWithTitleImageAlertView onlyConfirmWithTitleImageAlertViewWithTitle:@"您已预约成功，请及时查看！" ImageName:@"appointmentsuccess" ConfirmBtnTitle:@"确认" ConfirmBtnTitleColor:nil Handle:^(AlertViewSelectState selectState) {
                            if (selectState == AlertViewSelectStateConfirm) {
                                MyOrderController *myOrderVC = [[MyOrderController alloc] init];
                                myOrderVC.isBackRoot = YES;
                                myOrderVC.selectIndex = -1;
                                [rootNavC pushViewController:myOrderVC animated:YES];
                            }
                        }];
                    }else{
                        
                        [ConfirmAndCancelWithTitleImageAlertView confirmAndCancelWithTitleImageAlertViewWithTitle:@"很抱歉，您的预约失败了。" ImageName:@"appointmentfailed" ConfirmBtnIsShow:YES ConfirmBtnTitle:@"重新预约" ConfirmBtnTitleColor:[UIColor colorWithHexStringToRGB:@"3CADFF"] CancelBtnIsShow:YES CancelBtnTitle:@" 确认" CancelBtnTitleColor:[UIColor colorWithHexStringToRGB:@"9B9B9B"] Handle:^(AlertViewSelectState selectState) {
                            if (selectState == AlertViewSelectStateConfirm) {
                                [rootNavC popToRootViewControllerAnimated:YES];
                            }
                        }];
                        
                    }
                }
                
 
            }

    }
    self.userInfo = nil;
}

- (void)dealRemoteNotificationPush{
    if(self.userInfo){
        [self dealRemoteNotificationHandleWithDict:self.userInfo];
    }
    
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
