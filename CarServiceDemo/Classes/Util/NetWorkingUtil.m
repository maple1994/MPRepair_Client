//
//  NetWorkingUtil.m
//  Agencies
//
//  Created by mac on 16/1/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NetWorkingUtil.h"
#import "CommonFunc.h"
#import "IOSmd5.h"
#import "WkPieProgressView.h"
#import "AppDelegate.h"
#import "LoginVC.h"

#define TypeJsonArray  999

static NSString *Api_version;

///登录接口，自动登录接口
#define LoginPath   @"/api/login/login/"
#define AutoLoginPath   @"/app/auth/auto-login/"
#define RefreshTokenPath   @"/api/login/refresh/"

///无网络链接提示
#define NetWorkNoneMsg  @"网络已断开，请连接后再试！"
#define KalreadySettingNetwork @"alreadySettingNetwork"
///无网络链接提示
#define CheckNetwork()      {\
    if (!_isNetwork) {\
    \
    if ((!_alreadySettingNetwork)&&_nonFirstTimeUseApp&&(!_alreadyCheckNetwork)) {\
    _alreadyCheckNetwork = YES;\
    \
    UIAlertController *AC = [UIAlertController alertControllerWithTitle:@"无网络或“无线数据”已关闭" message:@"请检测您的网络是否连接，还可以在“设置”中为此应用打开“无线数据”服务！" preferredStyle:UIAlertControllerStyleAlert];\
    \
    UIAlertAction *op = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {\
    \
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];\
    if ([[UIApplication sharedApplication] canOpenURL:url]) {\
    [[UIApplication sharedApplication] openURL:url];\
    exit(0);\
    }\
    }];\
    \
    UIAlertAction *op1 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {\
    }];\
    \
    [AC addAction:op1];\
    [AC addAction:op];\
    \
    UIWindow *window = [UIApplication sharedApplication].keyWindow;\
    [window.rootViewController presentViewController:AC animated:YES completion:nil];\
    \
    }else {\
    result(nil,-1, NetWorkNoneMsg); \
    return;\
    }\
    \
    }\
}

///检测无网络设置
#define CheckAlreadySettingNetwork()  {\
if (!_alreadySettingNetwork) {\
[[NSUserDefaults standardUserDefaults] setBool:YES forKey:KalreadySettingNetwork];\
}\
}




static BOOL _isNetwork = YES;
static BOOL _alreadySettingNetwork = NO;
static BOOL _nonFirstTimeUseApp = NO;
static BOOL _alreadyCheckNetwork = NO;


@interface NetWorkingUtil ()
{
    int  _requstSessionKeyStatus; //是否请求sessionKey结束  0:未请求 1:请求中  2：请求完毕
    BOOL _requstSessionKey; //是否需要从新
}

@property(nonatomic,strong)WkPieProgressView *pieProgressView;

@end
//单例实现
@implementation NetWorkingUtil

static NetWorkingUtil *instance = nil;
//正式环境
//static NSString *mainURL=@"";//
//测试环境
//static NSString *mainURL=@"";

static NSString *URL = @"";
static int netWorkState = 1;
//static NSString *token;

///处理登录过期的,
static bool isRelogin = NO;
static NSString *loginPath;
static NSDictionary *loginParameters;
static NSString *authLoginPath;
static NSDictionary *authLoginPathParameters;
static bool isAbsolutePath = NO; //是否绝对路径
static int requestType; //0:get  1:post
static NSString *requestPath;
static NSDictionary *requestParameters;


#pragma mark - lazy

#pragma mark -- 网络工具类的单例
static AFHTTPSessionManager *manager;

+ (NetWorkingUtil *)netWorkingUtil {
    if (!instance) {
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setHTTPShouldHandleCookies:YES];
        instance = [[super allocWithZone:NULL] init];
        [NetWorkingUtil reach];
        ///当前版本号
        Api_version = kCurrentAppVersion;
        
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self netWorkingUtil];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}

/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */
#pragma mark - 演练
#pragma mark -- 检测网络连接
+ (void)reach
{
    ///NO 第一次使用APP，  YES不是第一次使用APP
    _nonFirstTimeUseApp = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstTimeUseApp"];
    if (!_nonFirstTimeUseApp) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstTimeUseApp"];
    }
    
    ///记录是否设置过网络
    _alreadySettingNetwork = [[NSUserDefaults standardUserDefaults] boolForKey:KalreadySettingNetwork];
    
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //        NSLog(@"state..%d",status);
        netWorkState = status;
        //        NSLog(@"state..%d",netWorkState);
        
        if ([NetWorkingUtil netWorkingUtil].netWorkStateChangeBlcok!=nil) {
            [NetWorkingUtil netWorkingUtil].netWorkStateChangeBlcok(netWorkState);
        }
        
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: //未知网络
                _isNetwork = NO;
                
                break;
            case AFNetworkReachabilityStatusNotReachable: //无网络
                _isNetwork = NO;
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: //手机自带网络
                _isNetwork = YES;
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: //WIFI
                _isNetwork = YES;
                
                break;
        }
    }];
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


/**
 //检测当前网络
 AFNetworkReachabilityStatusUnknown          = -1,  // 未知
 AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
 AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
 AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
 */
+ (AFNetworkReachabilityStatus)netWorkState {
    return netWorkState;
}

+ (BOOL)netWorkWhetherConnect{
    return _isNetwork;
}


/**
 get请求一个Dictionary
 输入参数：
 path：方法名
 parameters:请求参数
 输出：void (^)(id obj 结果Dic
 ,int status  -1:失败 1;成功，
 ,NSString *msg 信息)
 */
- (void)getDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result{
    
    parameters = (parameters==nil)?@{}:parameters;
    [self getObjWithPath:path parameters:parameters result:result];
}


/**
 post请求一个Dictionary
 输入参数：
 path：方法名
 parameters:请求参数
 输出：void (^)(id obj 结果Dic
 ,int status  -1:失败 1;成功，
 ,NSString *msg 信息)
 */
- (void)postDataWithPath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int status,NSString *msg)) result{
    
    parameters = (parameters==nil)?@{}:parameters;
    [self postObjWithPath:path parameters:parameters result:result];
}


#pragma mark -- 重新登录
- (void)reLoginWithResult:(void (^)(id obj,int  status,NSString *msg))result {
    
    if ([ValidateUtil isEmptyStr:authLoginPath] || authLoginPathParameters==nil) {
        
        //登录过期了，发通知到tabbar登录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCookiesTimeOut" object:nil];
        
        result(nil,-1, NetWorkErrorMsg);
        return;
    }
    
    [manager POST:authLoginPath parameters:authLoginPathParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self resultDealWithresponseObject:responseObject result:result];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (netWorkState==0 || netWorkState==-1) { ///网络断开
            
            result(nil,-1, @"网络已断开，请请链接后再试！");
            
        }else { //有网络
            
            //登录过期了，发通知到tabbar登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCookiesTimeOut" object:nil];
            
            result(nil,-1, NetWorkErrorMsg);
        }
        
    }];
    
}


#pragma mark -- get请求
- (void)getObjWithPath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg))result {
    
    CheckNetwork();
    
    NSString *baseUrl = UrlCar(@"");
    if ([ValidateUtil isEmptyStr:baseUrl]) return;

    requestType = 0; //get
    requestPath = path;
    requestParameters = parameters;
    
    NSString *getURL =  [NSString stringWithFormat:@"%@%@", baseUrl, path];
    
    NSMutableDictionary *appendParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    
    ///去除没值得参数
//    NSArray *keys = [appendParameters allKeys];
//    for (NSString *key in keys) {
//        NSString *vStr = [NSString stringWithFormat:@"%@", appendParameters[key]];
//        if ([ValidateUtil isEmptyStr:vStr]) {//没有值得参数
//            [appendParameters removeObjectForKey:key];
//        }
//    }
//
    //    //登录接口
    if ([path isEqualToString:LoginPath]) {
        loginPath = getURL;
        loginParameters = appendParameters;
    }else{
        [appendParameters setObject:@"ios" forKey:@"system"];
        [appendParameters setObject:[UserInfo userInfo].sign forKey:@"sign"];
        [appendParameters setObject:[UserInfo userInfo].timestamp forKey:@"timestamp"];
        [appendParameters setObject:Api_version forKey:@"version"];
        [appendParameters setObject:[UserInfo userInfo].user_id forKey:@"user_id"];
        [appendParameters setObject:@"user" forKey:@"app_type"];
    }

    __block NSString *printStr = [NSString stringWithFormat:@"%@?", getURL];
    [appendParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *appendStr = [NSString stringWithFormat:@"%@=%@&", key, obj];
        printStr = [printStr stringByAppendingString:appendStr];
    }];
    printStr = [printStr substringToIndex:printStr.length - 1];
    NSLog(@"%@", printStr);

    ///AFNet请求数据
    [manager GET:getURL parameters:appendParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ///请求结果处理
        [self resultDealWithresponseObject:responseObject result:result];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ///登录失败
        result(nil,-1, NetWorkErrorMsg);
    }];
}

#pragma mark -- post请求
- (void)postObjWithPath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int status,NSString *msg))result{
    
    CheckNetwork();
    
    NSString *baseUrl = UrlCar(@"");
    if ([ValidateUtil isEmptyStr:baseUrl]) return;
    
    requestType = 1; //post
    requestPath = path;
    requestParameters = parameters;

    NSString *postURL =  [NSString stringWithFormat:@"%@%@", baseUrl, path];
    
    NSMutableDictionary *appendParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    // 自动登录登录接口
    if ([path isEqualToString:AutoLoginPath]) {
        authLoginPath = postURL;
        authLoginPathParameters = appendParameters;
    }
    // 登录接口
    if ([path isEqualToString:LoginPath]) {
        loginPath = postURL;
        loginParameters = appendParameters;
    }else{
        [appendParameters setObject:@"ios" forKey:@"system"];
        [appendParameters setObject:[UserInfo userInfo].sign forKey:@"sign"];
        [appendParameters setObject:[UserInfo userInfo].timestamp forKey:@"timestamp"];
        [appendParameters setObject:Api_version forKey:@"version"];
        [appendParameters setObject:[UserInfo userInfo].user_id forKey:@"user_id"];
        [appendParameters setObject:@"user" forKey:@"app_type"];
    }
    __block NSString *printStr = [NSString stringWithFormat:@"%@?", postURL];
    [appendParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *appendStr = [NSString stringWithFormat:@"%@=%@&", key, obj];
        printStr = [printStr stringByAppendingString:appendStr];
    }];
    printStr = [printStr substringToIndex:printStr.length - 1];
    NSLog(@"%@", printStr);
    
    ///AFNet请求数据
    [manager POST:postURL parameters:appendParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ///请求结果处理
        [self resultDealWithresponseObject:responseObject result:result];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ///请求出错
        NSLog(@"%@",error);
        result(nil,-1, NetWorkErrorMsg);
    }];
}

#pragma mark -- 上传文件到服务器
-(void)postImageToServerNoProgressWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters view:(UIView *)view result:(void (^)(id obj,int  status,NSString *msg))result {
    
    parameters = (parameters==nil)?@{}:parameters;
    CheckNetwork();
    
    NSString *baseUrl = UrlCar(@"");
    if ([ValidateUtil isEmptyStr:baseUrl]) return;
    
    requestType = 1; //post
    requestPath = urlString;
    requestParameters = parameters;
    
    NSString *postURL =  [NSString stringWithFormat:@"%@%@", baseUrl, urlString];
    
    NSMutableDictionary *appendParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    ///AFNet请求数据
    [manager POST:postURL parameters:appendParameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ///请求结果处理
        [self resultDealWithresponseObject:responseObject result:result];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        result(nil,-1, NetWorkErrorMsg);
    }];
    
}

-(void)postImageToServerWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters view:(UIView *)view result:(void (^)(id obj,int  status,NSString *msg))result {
    
    parameters = (parameters==nil)?@{}:parameters;
    CheckNetwork();
    
    NSString *baseUrl = UrlCar(@"");
    if ([ValidateUtil isEmptyStr:baseUrl]) return;
    
    requestType = 1; //post
    requestPath = urlString;
    requestParameters = parameters;
    
    NSString *postURL =  [NSString stringWithFormat:@"%@%@", baseUrl, urlString];
    
    NSMutableDictionary *appendParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

    self.pieProgressView = [[WkPieProgressView alloc]initWithFrame:view.bounds];
    [self.pieProgressView updatePercent:0 animation:YES];
    [view addSubview:self.pieProgressView];
    
    ///AFNet请求数据
    kWeakSelf(weakSelf);
    [manager POST:postURL parameters:appendParameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%lld",uploadProgress.totalUnitCount);
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        float percent = (float)100 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"percent = %f",percent);
        [strongSelf.pieProgressView updatePercent:percent animation:YES];
        
        if (percent >= 100) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.pieProgressView removeFromSuperview];
                strongSelf.pieProgressView = nil;
            });
            
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.pieProgressView removeFromSuperview];
            strongSelf.pieProgressView = nil;
        });
        
        ///请求结果处理
        [self resultDealWithresponseObject:responseObject result:result];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ///请求出错
        dispatch_async(dispatch_get_main_queue(), ^{
             __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.pieProgressView removeFromSuperview];
            strongSelf.pieProgressView = nil;
        });
        
        NSLog(@"%@",error);
        result(nil,-1, NetWorkErrorMsg);
    }];

}
#pragma mark -- 请求回来的网络数据，处理方法
- (void)resultDealWithresponseObject:(id)responseObject result:(void (^)(id obj, int status, NSString *msg))result{
    NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSString *resultMsg=@"";
    int statusInt;
    //json对象转换为oc对象 //下面转为字典
    NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *resultObj = [
        NSJSONSerialization JSONObjectWithData: jsonData
        options: NSJSONReadingMutableContainers
        error: &err
    ];
    if (resultObj == nil || resultObj.count == 0) {
        //网络异常
        statusInt = -1;
        resultMsg = NetWorkErrorMsg;
        result(nil,statusInt,resultMsg);
        return;
    }
    ///判断状态数据的存在
    //下面为出错结果处理
    NSInteger code = [resultObj[@"code"] integerValue];
    if (code != 100) { //bu正确
        if (code == 200) {
            statusInt = -1;
            resultMsg = resultObj[@"msg"];
            result(nil,statusInt,resultMsg);
            return;
        }
        // 下面处理cookies过期
        if (code == 300) {
            // 登录过期了，发通知到tabbar登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCookiesTimeOut" object:nil];
            result(nil,-1, NetWorkErrorMsg);
            return;
        }
    }
    
    ///下面是重新登录处理
    if (isRelogin) { //重新登录成功
        isRelogin = NO;
        if (requestType==0) { //get请求
            [self getObjWithPath:requestPath parameters:requestParameters result:result];
        }else { //post请求
            [self postObjWithPath:requestPath parameters:requestParameters result:result];
        }
        return;
    }

    ///返回的msg信息
    if ([resultObj[@"msg"] isKindOfClass:[NSString class]]) {
        resultMsg = resultObj[@"msg"];
    }
    ///服务器程序没出错
    statusInt = 1;
    
    ///没有返回数据
    if (resultObj[@"data"]==nil) {
        
        ///后台没有返回数据，返回一个空字典给请求处，
        NSDictionary *dic = [NSDictionary dictionary];
        
        result(dic,statusInt,resultMsg);
        return;
    }
    
    ///检测无网络设置
    CheckAlreadySettingNetwork();
    ///返回的结果可能是字典，也可能是数组
    result(resultObj[@"data"],statusInt,resultMsg);
}

/**
 描述：加载网络图片资源
 输入参数：
 imageView：需要加载的图片view
 imageUrl : 图片地址
 */
+(void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl defaultIconName:(NSString*)defaultIconName completed:(SDExternalCompletionBlock)webImageCompletionBlock{
    if ([ValidateUtil isEmptyStr:imageUrl]) {
        [imageView setImage:[UIImage imageNamed:defaultIconName]];
        return ;
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:defaultIconName] options:SDWebImageRetryFailed completed:webImageCompletionBlock];
}

+ (void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl defaultIconName:(NSString*)defaultIconName
{
    if ([ValidateUtil isEmptyStr:imageUrl]) {
        [imageView setImage:[UIImage imageNamed:defaultIconName]];
        return ;
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:defaultIconName] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (imageView.image==nil) {
            imageView.image = [UIImage imageNamed:defaultIconName];
        }
    }];
}

-(void) getImage {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    UIImageView *imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:URL]];
}


/**
 根据绝对路径 get请求一个Dictionary 或 array
 */
- (void)getDataWithAbsolutePath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result {
    
    parameters = (parameters==nil)?@{}:parameters;
    ///检查网络状态，无网络不请求
    CheckNetwork();
    
    NSString *baseUrl = UrlCar(@"");
    if ([ValidateUtil isEmptyStr:baseUrl]) return;
    
    isAbsolutePath = YES;
    requestType = 0; //get绝对路径
    requestPath = path;
    requestParameters = parameters;
    
    NSString *getURL =  [NSString stringWithFormat:@"%@", path];
    
    NSMutableDictionary *appendParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    [appendParameters setObject:@"ios" forKey:@"auth_client"];
//    [appendParameters setObject:@"ios" forKey:@"client_type"];
//    [appendParameters setObject:@"ios" forKey:@"system"];
//    [appendParameters setObject:Api_version forKey:@"api_version"];
    ///去除没值得参数
    NSArray *keys = [appendParameters allKeys];
    for (NSString *key in keys) {
        NSString *vStr = [NSString stringWithFormat:@"%@", appendParameters[key]];
        if ([ValidateUtil isEmptyStr:vStr]) {//没有值得参数
            [appendParameters removeObjectForKey:key];
        }
    }
    
    
    [manager GET:getURL parameters:appendParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self resultDealWithresponseObject:responseObject result:result ];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        result(nil,-1, NetWorkErrorMsg);
    }];
    
}


/**
 根据绝对路径 post请求一个Dictionary 或 array
 */
- (void)postDataWithAbsolutePath:(NSString *)path parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg))result {
    
    parameters = (parameters==nil)?@{}:parameters;
    ///检查网络状态，无网络不请求
    CheckNetwork();
    
    NSString *baseUrl = UrlCar(@"");
    if ([ValidateUtil isEmptyStr:baseUrl]) return;
    
    isAbsolutePath = YES;
    requestType = 1; //post绝对luj
    requestPath = path;
    requestParameters = parameters;
    
    NSString *postURL =  [NSString stringWithFormat:@"%@%@", @"", path];
    
    NSMutableDictionary *appendParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [appendParameters setObject:@"ios" forKey:@"auth_client"];

//    [appendParameters setObject:@"app" forKey:@"auth_client"];
//    [appendParameters setObject:@"ios" forKey:@"client_type"];
//    [appendParameters setObject:@"ios" forKey:@"system"];
//    [appendParameters setObject:Api_version forKey:@"api_version"];
    ///去除没值得参数
    NSArray *keys = [appendParameters allKeys];
    for (NSString *key in keys) {
        NSString *vStr = [NSString stringWithFormat:@"%@", appendParameters[key]];
        if ([ValidateUtil isEmptyStr:vStr]) {//没有值得参数
            [appendParameters removeObjectForKey:key];
        }
    }
    
    [manager POST:postURL parameters:appendParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self resultDealWithresponseObject:responseObject result:result];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        result(nil,-1, NetWorkErrorMsg);
    }];
}

@end

