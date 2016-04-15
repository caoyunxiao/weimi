//
//  DetailWebViewViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/19.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailWebViewViewController.h"
#import "MBProgressHUD+MJ.h"

@interface DetailWebViewViewController ()<UIWebViewDelegate>{
    NSInteger _timeCount;
}
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation DetailWebViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=[self createLeftBtn];
    [self _loadUrl];
}

/**
 *  左边导航栏
 *
 *  @return UIBarButtonItem
 */
-(UIBarButtonItem*)createLeftBtn{

    UIButton *btn=[Custom addBtnWithFrame:CGRectMake(0, 0, 40, 44) nomalImage:nil title:@"返回" titleColor:[UIColor whiteColor] target:self action:@selector(webViewGoBack)];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

/**
 *  返回
 */
-(void)webViewGoBack{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void) _loadUrl{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight + 45)];
    
    _webView.delegate = self;
        
    NSURL *url = [[NSURL alloc] initWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideHUDForView:self.view];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showMessage:@"主人正在加载中..." view:self.view isShow:NO];
    _timeCount=20;
    
    //解决有些时候提示消息一直不消失的bug-------------------------------
    self.timer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(subTimer) userInfo:nil repeats:YES];
    //解决有些时候提示消息一直不消失的bug-------------------------------
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)subTimer{
    _timeCount=_timeCount-10;
    [MBProgressHUD hideHUDForView:self.view];
    if (_timeCount==0) {
        [self.timer invalidate];
        self.timer=nil;
    }
    
}
@end
