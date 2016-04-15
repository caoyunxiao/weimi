//
//  MyTrafficViewController.m
//  微密
//
//  Created by ZFJ on 15/8/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MyTrafficViewController.h"
#import "SDProgressView.h"
#import "SDDemoItemView.h"
#import "DetailWebViewViewController.h"

@interface MyTrafficViewController ()

@end

@implementation MyTrafficViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的流量";
    
    _progress = 0;
    self.MyTrafficScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+20);
    
    // 添加progressView示例模型图
    _demoView = [SDDemoItemView demoItemViewWithClass:[SDPieLoopProgressView class]];
    _demoView.progressView.progress = 0;
    _demoView.frame = CGRectMake((ScreenWidth-180)/2, 20, 180, 180);
    [self.MyTrafficScrollView addSubview:_demoView];

    // 模拟下载进度
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progressSimulation) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)progressSimulation
{
    if(_threshold != nil && _sum_data != nil)
    {
        float threshold = [_threshold floatValue];
        float sum_data = [_sum_data floatValue];
        float number = sum_data/threshold;
        if (_progress < number)
        {
            _progress += 0.01;
            _demoView.progressView.progress = _progress;
        }
        else
        {
            _demoView.progressView.progress = number;
            [_timer setFireDate:[NSDate distantFuture]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getFlowInfoCompleted];
}

#pragma mark - 获取流量信息
- (void)getFlowInfoCompleted
{
    [Request1617 getFlowInfoCompleted:^(NSString *errorCode, NSDictionary *resultDict) {
        if([errorCode isEqualToString:@"0"])
        {
            _threshold = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"threshold"]];
            _sum_data = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"sum_data"]];
            _unit = [resultDict objectForKey:@"unit"];
            if(_threshold != nil && _sum_data != nil)
            {
                [self setUIView];
            }
        }
        else if ([errorCode isEqualToString:@"ME01021"]||[errorCode isEqualToString:@"ME24903"])
        {
            Alert(@"主人,请与公司客服联系吧");
        }
        else if ([errorCode isEqualToString:@"ME18908"])
        {
            Alert(@"主人,你还没有绑定微密呢");
        }
        else if([errorCode isEqualToString:@"ME24902"]){
            [MBProgressHUD showError:@"主人,流量卡没插入"];
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}
#pragma mark - 填充数据
- (void)setUIView
{
    if(_unit)
    _demoView.progressView.thresholdStr = _threshold;
    _demoView.progressView.sum_dataStr = _sum_data;
    _demoView.progressView.unit = _unit;
  
    NSInteger threshold=[_threshold integerValue];
    NSInteger sum_data=[_sum_data integerValue];
    self.thresholdLabel.text = [NSString stringWithFormat:@"%ld%@",threshold,_unit];
    self.sum_dataLabel.text = [NSString stringWithFormat:@"%ld%@",sum_data,_unit];
    self.flowSet.text = [NSString stringWithFormat:@"%ld%@/月",threshold,_unit];
   
    [_timer setFireDate:[NSDate distantPast]]; //开始动画
}
#pragma mark - 去兑换流量

- (IBAction)exchange:(id)sender {
    DetailWebViewViewController *webView=[[DetailWebViewViewController alloc]init];
    webView.url=[NSString stringWithFormat:@"http://store.daoke.me/index.php/app/cashFlow?accountID=%@",[PersonInfo sharePersonInfo].accountIDString];
    [self.navigationController pushViewController:webView animated:YES];
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
