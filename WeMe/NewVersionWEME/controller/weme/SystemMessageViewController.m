//
//  SystemMessageViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/29.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "SystemMessageViewController.h"

@interface SystemMessageViewController ()<UIWebViewDelegate>
{

    UIWebView *_webView;

}
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"系统消息";

}

- (void) _loadUrl{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight + 64)];
    
    _webView.delegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:self.webUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
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
