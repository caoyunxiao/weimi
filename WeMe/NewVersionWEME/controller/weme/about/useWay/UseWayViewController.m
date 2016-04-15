//
//  UseWayViewController.m
//  微密
//
//  Created by MacDev on 15/3/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "UseWayViewController.h"
#import "MobClick.h"
@interface UseWayViewController ()<UIWebViewDelegate>
{
    UIWebView * _webView;
}
@end

@implementation UseWayViewController
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"使用说明";
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.alpha = 0;
    _webView.scalesPageToFit= NO;
    [self.view addSubview:_webView];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://help.daoke.me"]];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
