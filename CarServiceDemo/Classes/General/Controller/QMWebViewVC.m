//
//  WKWebViewVC.m
//  2.0
//
//  Created by  on 16/11/2.
//  Copyright © 2016年 . All rights reserved.
//

#import "QMWebViewVC.h"
//#import "UIBarButtonItem+Extension.h"



@interface QMWebViewVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QMWebViewVC

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupProperty];
    
    self.webView.delegate = self;
    
    if (self.urlStr.length) {
        
        [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
        
        [self.webView loadRequest:request];
        
    }
}

- (void)setupProperty{
    UIBarButtonItem *dismissSelf = [self itemWithTarget:self action:@selector(dismissSelf) image:@"icon_return-1" highImage:@"icon_return-1"];
    
    UIBarButtonItem *back = [self itemWithTarget:self action:@selector(back) image:@"icom_h5_close" highImage:@"icom_h5_close"];

    
    self.navigationItem.leftBarButtonItems = @[dismissSelf,back];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)dismissSelf{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UIWebViewDelegate>
-(void)webViewDidStartLoad:(UIWebView *)webView {
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [MBProgressHUD dismissHUDForView:self.view];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD dismissHUDForView:self.view withError:@"网络异常，请稍后再试！"];
}


//遵守UIWebViewDelegate代理协议。
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //拿到网页的实时url
    NSString *requestStr = [[request.URL absoluteString] stringByRemovingPercentEncoding];
    
    return YES;
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)dealloc{
    
}


- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[self imageRenderingModeWithImageName:image] forState:UIControlStateNormal];
    [btn setImage:[self imageRenderingModeWithImageName:image] forState:UIControlStateHighlighted];
    btn.size = CGSizeMake(30, 30);
    btn.imageEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 12);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (UIImage *)imageRenderingModeWithImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}


@end
