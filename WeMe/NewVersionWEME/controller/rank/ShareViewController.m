//
//  ShareViewController.m
//  微密
//
//  Created by APP on 15/6/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
{
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"谢尔说明";
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *urlStr = @"http://open.daoke.me/level";
    NSURL *url = [NSURL URLWithString:urlStr];
    [_shareWebView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
