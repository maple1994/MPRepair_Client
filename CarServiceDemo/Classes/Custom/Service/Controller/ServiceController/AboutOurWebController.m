

//
//  AboutOurWebController.m
//  CarServiceDemo
//
//  Created by superButton on 2018/9/12.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "AboutOurWebController.h"

@interface AboutOurWebController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UIWebView *nowWebView;

@end

@implementation AboutOurWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAllView];
    [self loadAllData];
}

- (void)loadAllView{
    
    self.title = @"关于我们";
    [_backView addSubview:self.nowWebView];
    kWeakSelf(weakSelf)
    [self.nowWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.backView);
    }];
}

- (void)loadAllData{
    
}

#pragma mark - WebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    NSString *htmlTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
//    self.title = htmlTitle;
    
    _nowWebView.hidden = NO;
    
    kWeakSelf(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD dismissHUDForView:weakSelf.view];
    });
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    kWeakSelf(weakSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD dismissHUDForView:weakSelf.view];
    });
    
}

#pragma 懒加载
- (UIWebView *)nowWebView{
    if (!_nowWebView) {
        _nowWebView = [[UIWebView alloc] init];
        _nowWebView.delegate = self;
        _nowWebView.hidden = YES;
        _nowWebView.backgroundColor = [UIColor whiteColor];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
        [_nowWebView loadRequest:request];
    }
    return _nowWebView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end