//
//  MoreWebViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/29.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MoreWebViewController.h"
#import "MobClick.h"
@interface MoreWebViewController ()<UIWebViewDelegate>
{
    UIWebView * _webView;
}
@end

@implementation MoreWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"更多网页"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"更多网页"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _Moretitle;
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.alpha = 0;
    [self.view addSubview:_webView];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
} 
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(getWeb) withObject:self afterDelay:0.5];
}
- (void)getWeb
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _webView.alpha = 1;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
