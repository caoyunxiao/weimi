//
//  FeedbackViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/21.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PersonInfo.h"
@interface FeedbackViewController ()
{
    UIWebView *web;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self _createWebView];
}

- (void)_createWebView{

    PersonInfo *info = [PersonInfo sharePersonInfo];
    NSString *infoUrl = info.accountIDString;
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight + 50)];
    NSString *urlString = [NSString stringWithFormat:@"http://help.daoke.me/feedback/index.html?appName=weme&accountID=%@",infoUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [web loadRequest:request];
    [self.view addSubview:web];

    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    [self.navigationItem setRightBarButtonItem:closeBtn];
    
    UIBarButtonItem *leftBut = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    [leftBut setImage:[UIImage imageNamed:@"BarItemBack"]];
    [leftBut setImageInsets:UIEdgeInsetsMake(5, -10, 1, 10)];
    [self.navigationItem setLeftBarButtonItem:leftBut];
    
}
- (void)leftAction
{
    NSString *currentURL= web.request.URL.absoluteString;
    NSRange range = [currentURL rangeOfString:@"index.html"];
    int leight = (int)range.length;
    if (leight == 0)
    {
        [web goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)closeAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
