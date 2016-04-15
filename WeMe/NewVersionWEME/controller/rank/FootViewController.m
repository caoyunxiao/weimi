//
//  FootViewController.m
//  微密
//
//  Created by APP on 15/5/23.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FootViewController.h"
#import "FootHeaderView.h"

#import "DayViewController.h"
#define kHeight 300
@interface FootViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation FootViewController
{
    FootHeaderView *_headerView;
    UIScrollView *_backScrollView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    self.title = @"我的足迹";
    [self customUI];
}
- (void)customUI
{
    _backScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backScrollView.delegate = self;
    
    
    [self.view addSubview:_backScrollView];
    
    _headerView = [[NSBundle mainBundle] loadNibNamed:@"FootHeaderView" owner:self options:0][0];
    _headerView.cityAndPointLabel.text = self.cityAndPointText;
    _headerView.frame = CGRectMake(0, 64, _headerView.frame.size.width, _headerView.frame.size.height);
    __block FootViewController *vc = self;
    _headerView.headerCallBack = ^(int tag){
        if (tag-10 == _currentPage) {
            return;
        }
        vc.currentPage = tag-10;
    };
    [_backScrollView addSubview:_headerView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame), ScreenWidth, kHeight)];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    //_scrollView.backgroundColor = [UIColor yellowColor];
    [_backScrollView addSubview:self.scrollView];
    _backScrollView.contentSize = CGSizeMake(0, ScreenHeight+kHeight- (ScreenHeight-CGRectGetMaxY(_headerView.frame)));
    CGFloat x = 0.0;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:viewController.view];
        x += CGRectGetWidth(self.scrollView.frame);
        _scrollView.contentSize   = CGSizeMake(x, 0);
    }
    
}
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.scrollView setContentOffset:CGPointMake(_currentPage*_scrollView.frame.size.width, 0) animated:YES];
//    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), ScreenWidth, [_viewControllers[_currentPage] view].frame.size.height);
    UIView *sender = [_headerView.backView viewWithTag:_currentPage+10];
    [UIView animateWithDuration:0.25f animations:^{
        _headerView.markView.frame = CGRectMake(sender.frame.origin.x, CGRectGetMaxY(sender.frame)-2, sender.frame.size.width, 2);
    } completion:nil];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    self.currentPage = currentPage;
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
