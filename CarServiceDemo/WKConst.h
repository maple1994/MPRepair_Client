
#import <Foundation/Foundation.h>


#pragma mark - 项目宏

// 0.1归档的实现
#define LyCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self encode:encoder]; \
}


//单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}


// 1.日志输出宏定义,DEBUG打印输出，release不打印输出
#ifdef DEBUG
//#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)   nil
#endif

//2.系统版本
#define kSYSTEMVESION [[UIDevice currentDevice].systemVersion doubleValue]
//2.1 系统版本, 特殊处理, iOS 11.1.1 版本的转场动画有问题.
#define kSYSTEMSPECIALVERSION [[UIDevice currentDevice].systemVersion isEqualToString:@"11.1.1"]?YES:NO

//3.内部版本号
#define kCurrentAppBuild [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];

//4.发布版本号
#define kCurrentAppVersion [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];

//5.设备是为iPad
#define kIsIPAD [[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad

//6.当前设备的方向
#define kDeviceCurrentOrientation [UIDevice currentDevice].orientation

//7.设备是iPhone5
#define kIsIPhone5 ([UIScreen mainScreen].bounds.size.height == 568)


//8.设备是iPhone6
#define kIsIPhone6 ([UIScreen mainScreen].bounds.size.height == 667)

//9.设备是iPhone6+
#define kIsIPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736)

//10.设备高度及宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


//10.横版设备高度及宽度
#define LSSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height?\
[UIScreen mainScreen].bounds.size.height\
:[UIScreen mainScreen].bounds.size.width\
)

#define LSSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height?\
[UIScreen mainScreen].bounds.size.width\
:[UIScreen mainScreen].bounds.size.height\
)

// 11.RGB颜色
#define kCOLOR_RGB(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]

// 12.RGBA颜色
#define kCOLOR_RGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]

//13.RGB随机色
#define kColor_Random kCOLOR_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//14.沙盒根目录
#define kHomeDirectory NSHomeDirectory()

//15.沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]

//16.沙盒tmp路径
#define kTempPath NSTemporaryDirectory()

//17.沙盒cache路径
#define kCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]

//18.NSNotificationCenter的defaultCenter
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//19.根据传入的数据对象、电脑用户名、文件名在桌面生成plist文件
#define kWritePlistToDesktop(obj,userName,filename) [obj writeToFile:[NSString stringWithFormat: @"/Users/%@/Desktop/%@.plist",userName,filename] atomically:YES];

//20.weakself
#define kWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define kStrongSelf(strongSelf) __strong __typeof(self)strongSelf = weakSelf;

//21.
#define ImageWithContentsOfFile(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]]

//22.检测是否为生产环境
#ifdef DEBUG

#define IsProduction   NO

#else
#define IsProduction   YES
#endif

//23.判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


//24.系统版本的对比
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)






#pragma mark - 项目自定义宏



//NavBar高度
#define NavigationBar_HEIGHT 44

// 加载时提示信息
#define LoadingMsg @"正在加载..."
#define LoginNoti  @"LoginNoti"
#define DefaultBannerImage    @"DefaultBannerImage"
#define DefaultHousesListImage    @"DefaultHousesListImage"
#define DefaultHouseTypeImage    @"DefaultHouseTypeImage"
#define DefaultEmptyDataImage    @"icon_data_empty"//暂无数据图片
#define KDefaultImage    @"defaultImage"//暂无数据图片


//用户类归档保存的文件路径
//#define kUserInfoPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.archive"]
#define kUserInfoPath @"/Users/maple/Desktop/user.plist"

#define KbgmMP3Path  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"bgmMP3Path.archive"]


#define TextNotification  @"TextNotification"
#define ScanNotification  @"ScanNotification"
#define LogoutNotification  @"LogoutNotification"
#define LoginNotification  @"LoginNotification"
#define LoginRefreshNotification  @"LoginRefreshNotification"

#define KLookTypePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lookType.archive"]

#define KNormWorkPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"normWork.archive"]


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height-KGESTURESHomeHeight
#define kHEADER (kStatusBarHeight + kNavBarHeight)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kFOOT ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define KGESTURESHomeHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)
#define kIphoneX kStatusBarHeight>20?YES:NO

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 11.RGB颜色
#define COLOR_RGB(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]

#define DefaultRedColor  [UIColor colorWithRed:247/255.0 green:86/255.0 blue:88/255.0 alpha:1.0]

#define DefaultBlueColor  [UIColor colorwithHexString:@"3CADFF"];

#define DefaultOrgColor  [UIColor colorWithRed:239/255.0 green:139/255.0 blue:113/255.0 alpha:1.0]



#define CorpsSelectIndexNotification @"CorpsSelectIndexNotification"

#define kFontSize(a) [UIFont systemFontOfSize:a]

//类型判断
#define NullStrable(value) (value != nil ? value : @"") 
#define StringNotNull(x)                         (![x isKindOfClass:[NSNull class]] && x != nil && ![x isEqual:@"<null>"] && ![x isEqualToString:@""])
#define StringNotZero(x)                         [ValueNotNSNull(x) floatValue]>0.f?[ValueNotNSNull(x) stringValue]:nil
#define ValueNotNSNull(value)                    ((value && ![value isEqual:[NSNull null]])? value : nil)
#define ValueIsKindNull(value)                    ((value && ![value isKindOfClass:[NSNull class]]))
#define StringNotEmpty(str)                      (str && (str.length > 0))
#define ArrayNotEmpty(arr)                       (arr && (arr.count > 0))
#define StringNew(obj)                           [NSString stringWithFormat:@"%@",obj]
#define StringNewLD(obj)                           [NSString stringWithFormat:@"%ld",obj]
#define StringNewData(obj)                           [NSString stringWithFormat:@"%lddata",obj]

#define Dictionary(obj)                          (obj && [obj isKindOfClass:[NSDictionary class]])
#define Array(obj)                               (obj && [obj isKindOfClass:[NSArray class]])

#define ClassNameStr(ClassName)                  (((void)(NO && ((void)ClassName.class, NO)), @#ClassName))



#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

///安全区域上边边距
#define SafeAreaTopHeight (KIsiPhoneX?\
    ([UIDevice currentDevice].orientation==UIDeviceOrientationPortrait?\
        (44.00+44.00)\
        :([UIDevice currentDevice].orientation==UIDeviceOrientationPortraitUpsideDown?\
            (34.00+44.00)\
            :(0.00)))\
    :(0.00))


///安全区域下边边距
#define SafeAreaBottomHeight (KIsiPhoneX?\
    ([UIDevice currentDevice].orientation==UIDeviceOrientationPortraitUpsideDown?\
        (44.00+34.00)\
        :([UIDevice currentDevice].orientation==UIDeviceOrientationPortrait?\
            (34.00)\
            :(21.00)))\
    :(0.00))



///安全区域左边边距
#define SafeAreaLeftWidth (KIsiPhoneX?\
    ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft?\
        (44.00)\
        :([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight?\
            (44.00)\
            :(0.00)))\
    :(0.00))

///安全区域右边边距
#define SafeAreaRightWidth (KIsiPhoneX?\
    ([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeRight?\
        (44.00)\
        :([UIDevice currentDevice].orientation==UIDeviceOrientationLandscapeLeft?\
            (44.00)\
            :(0.00)))\
    :(0.00))

///安全区域的宽度
#define SafeAreaWidth   (SCREEN_WIDTH-SafeAreaLeftWidth-SafeAreaRightWidth)

///安全区域的高度
#define SafeAreaHeight  (SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomHeight)


#define kMAIN_WINDOW [[[UIApplication sharedApplication] delegate] window]
///通知
#define kNotificationCenter [NSNotificationCenter defaultCenter]
///属性列表
#define kUserDefault [NSUserDefaults standardUserDefaults]
//下载沙盒地址
#define kDownloadPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

///客服电话
#define kServiceTel @"02087618887"
///第一次安装标识
#define kIsFirstInstall @"isFirstInstall"
#define kIsFirstInstallTime @"isFirstInstallTime"
#define kWeXinKeyID @"wx43bdade617c80760"
#define kZhifubaoKeyID @"2018090461272416"

///指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
//NSString * const jPushChannel = @"http://www.dalacar.com";

///用于标识当前应用所使用的APNs证书环境:0 (默认值)表示采用的是开发证书;1 表示采用生产证书发布应用。
//BOOL  jPushIsProduction = IsProduction;

#pragma mark - 定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)(void);
typedef void (^NetWorkBlock)(BOOL netConnetState);
//常用的block
typedef void (^GetBackIDBlock)(id obj);
typedef void (^GetBackBoolBlock)(BOOL result);
typedef void (^GetBackStringBlock)(NSString *result);
typedef void (^GetBackArrayMBlock)(NSMutableArray *result);
typedef void (^GetBackDictionaryBlock)(NSDictionary *result);
typedef void (^GetBackNSUIntegerBlock)(NSUInteger result);
typedef void (^GetFailBlock)(id error);
