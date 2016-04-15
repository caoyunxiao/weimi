//
//  ServiceProtocolViewController.m
//  微密
//
//  Created by wemeDev on 15/6/2.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ServiceProtocolViewController.h"

@interface ServiceProtocolViewController ()

@end

@implementation ServiceProtocolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"服务协议";
    self.ServiceWebView.frame = CGRectMake(0, 0, 0, 0);
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    [self.navigationItem setRightBarButtonItem:closeBtn];
    self.ServiceWebView.delegate = self;
    _filePath = [[NSBundle mainBundle]pathForResource:@"wemeagreement" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
    [self.ServiceWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:_filePath]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL absoluteString];
    
    NSArray *array = [url componentsSeparatedByString:@"/"];
    if ([array indexOfObject:@"servicenote.html"] != NSNotFound)
    {
        _filePath = [[NSBundle mainBundle]pathForResource:@"servicenote" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
        [self.ServiceWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:_filePath]];
    }
    if ([array indexOfObject:@"contract.html"] != NSNotFound)
    {
        _filePath = [[NSBundle mainBundle]pathForResource:@"contract" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
        [self.ServiceWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:_filePath]];
    }
    
    return YES;
}
- (void)closeAction
{
    NSRange range = [_filePath rangeOfString:@"wemeagreement.html"];
    int leight = (int)range.length;
    if (leight == 0)
    {
        _filePath = [[NSBundle mainBundle]pathForResource:@"wemeagreement" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:nil];
        [self.ServiceWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:_filePath]];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //加载完成
    self.ServiceWebView.frame = self.view.frame;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //加载失败
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
