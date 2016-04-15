//
//  transferGoodsViewController.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "transferGoodsViewController.h"
#import "GoodsView.h"
#import "MobClick.h"

@interface transferGoodsViewController ()
{
    ModelView *_modelView;
}
@end

@implementation transferGoodsViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"微密换货";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uiConfig];
    
}

#pragma mark --初始化视图
- (void)uiConfig
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight+100);
    [self.view addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    
    GoodsView *goods = [[[NSBundle mainBundle]loadNibNamed:@"GoodsView" owner:self options:nil]lastObject];
    goods.delegate = self;
    [scrollView addSubview:goods];

}
#pragma mark - 微密换货代理方法
- (void)applyExchangeGoods:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany name:(NSString *)name telephone:(NSString *)telephone address:(NSString *)address exchangeReason:(NSString *)exchangeReason
{
    if (_modelView == nil) {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }
    
    [self.view addSubview:_modelView];
    //押金密码可以给空
    //depositPassword
    [RequestEngine applyExchangeGoods:@"" expressNumber:expressNumber expressCompany:expressCompany name:name telephone:telephone address:address exchangeReason:exchangeReason completed:^(NSString *errorCode, NSDictionary *resultDic)
    {
        NSInteger isGoods = [errorCode integerValue];
        NSString *massage;
        if (isGoods == 0)
        {
            massage = @"主人,申请维修成功了哦";
        }
//        else if (isGoods == 1)
//        {
//            massage = @"主人,你输入的押金密码有误";
//        }
        else if (isGoods == 2)
        {
            massage = @"主人,你还未付押金呢";
        }
//        else if (isGoods == 3)
//        {
//            massage = @"主人,你输入的押金密码有误";
//        }
        else if (isGoods == 4)
        {
            massage = @"主人,网络不给力啊,请检查一下网络吧";
        }else
        {
            massage = @"主人,网络好像不给力啊,检查一下网络吧";
        }
        [_modelView removeFromSuperview];
        
        Alert(massage);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];//友盟统计
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];//友盟统计
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}








@end
