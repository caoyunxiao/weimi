//
//  ExpectedViewController.m
//  微密
//
//  Created by APP on 15/6/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ExpectedViewController.h"

@interface ExpectedViewController ()<UIWebViewDelegate>

@end

@implementation ExpectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.text;
    // Do any additional setup after loading the view from its nib.
    NSString *str = [_strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    [_expectedWebView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

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
