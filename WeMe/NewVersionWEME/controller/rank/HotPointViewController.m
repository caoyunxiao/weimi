//
//  HotPointViewController.m
//  微密
//
//  Created by APP on 15/5/22.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "HotPointViewController.h"

@interface HotPointViewController ()<UIWebViewDelegate>
{
    NSString *_str;
}
@end

@implementation HotPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //加载webView
    [self requestData];
}
- (void)requestData
{
//    [RequestEngine getHotPointForWebView:^(NSDictionary *dic) {
//        _str = [self dictionaryToJson:dic];
//        NSString *str1 = [NSString stringWithFormat:@"http://192.168.11.85/echart_test/map.html?param=%@",_str];
//        NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:str2];
//        [_hotWebView loadRequest:[NSURLRequest requestWithURL:url]];
//
//    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
#pragma mark webView
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
