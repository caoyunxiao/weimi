//
//  DefindTextViewController.m
//  微密
//
//  Created by iOS Dev on 14-9-13.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "DefindTextViewController.h"
#import "ServiceAndProtocolView.h"
#import "DefindContractViewController.h"


@interface DefindTextViewController ()

@end

@implementation DefindTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"微密软件许可及服务协议";
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:LOGINURL(@"wemeagreement.html")]]];
    [self.view addSubview:_webView];
    
    //[self addView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{}

- (void)addView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 3210);
    [self.view addSubview:scrollView];

    ServiceAndProtocolView *serviceView = (ServiceAndProtocolView *)[[[NSBundle mainBundle]loadNibNamed:@"ServiceAndProtocolView" owner:self options:nil]lastObject];
    serviceView.delegate = self;
    [scrollView addSubview:serviceView];
}

- (void)daokeIsClick
{
    DefindContractViewController *ccvc = [[DefindContractViewController alloc]init];
    [self.navigationController pushViewController:ccvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
