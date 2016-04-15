//
//  DetailWebViewController.m
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailWebViewController.h"

@interface DetailWebViewController ()

@end

@implementation DetailWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self viewDidLoadWebView];
}

- (void)viewDidLoadWebView
{
    self.title = self.titleName;
    _DetailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_DetailWebView];
    _DetailWebView.delegate = self;
    [_DetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self refreshWithStatus:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(getWeb) withObject:self afterDelay:0.5];
    _DetailWebView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}
- (void)getWeb
{
    [self refreshWithStatus:NO];
    _DetailWebView.alpha = 1;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self refreshWithStatus:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
