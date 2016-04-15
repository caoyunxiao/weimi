//
//  TaskSystemViewController.m
//  微密
//
//  Created by APP on 15/5/21.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TaskSystemViewController.h"
#import "RequestEngine.h"
#import "TaskOSViewController.h"
#import "ShareViewController.h"
@interface TaskSystemViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *markView;


@end

@implementation TaskSystemViewController
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"任务系统";
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatViewWithControllers:self.viewControllers];
    //根据后边页面传来的page切换到不同的任务类型
    UIView *sender = [_backView viewWithTag:_currentPage+10];
    self.markView.frame = CGRectMake(sender.frame.origin.x, CGRectGetMaxY(sender.frame)-2, sender.frame.size.width, 2);
    self.currentPage = sender.tag-10;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitle:@"谢尔" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareActionButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}
#pragma 什么是谢尔
- (void)shareActionButton
{
    //谢尔
    ShareViewController *vc = [[ShareViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma 四个任务类型被点击
- (IBAction)titleButtonClick:(UIButton *)sender {
    if (_currentPage == sender.tag-10) {
        return;
    }
    self.currentPage = sender.tag-10;
    [UIView animateWithDuration:0.25f animations:^{
        self.markView.frame = CGRectMake(sender.frame.origin.x, CGRectGetMaxY(sender.frame)-2, sender.frame.size.width, 2);
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 创建滚动视图
- (void)creatViewWithControllers:(NSArray *)viewControllers {
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, ScreenWidth, 40)];
    //_backView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_backView];
    NSArray *titleArray = @[@"每日任务",@"每周任务",@"每月任务",@"成就任务"];
    
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        //[button setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
        button.layer.borderWidth = 0.5;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //button.titleLabel.text = titleArray[i];
        button.tag = 10+i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake((i*ScreenWidth)/4, 0, ScreenWidth/4+0.5, 40);
        [self.backView addSubview:button];
    }
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, ScreenWidth/4, 2)];
    _markView.backgroundColor = [UIColor colorWithRed:91.0 / 255.0 green:195.0 / 255.0 blue:88.0 / 255.0 alpha:1];

    [_backView addSubview:_markView];
    CGFloat x = 0.0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64-40)];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator   = NO;
    _scrollView.bounces                        = NO;
    _scrollView.pagingEnabled                  = YES;
    [self.view addSubview:_scrollView];
    for (UIViewController *viewController in _viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, ScreenWidth, ScreenHeight-64-40);
        [self.scrollView addSubview:viewController.view];
        x += CGRectGetWidth(self.scrollView.frame);
        _scrollView.contentSize   = CGSizeMake(x, 0);
    }
}
#pragma 重写set方法
- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.scrollView setContentOffset:CGPointMake(_currentPage*_scrollView.frame.size.width, 0) animated:YES]; 
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _currentPage = currentPage;
    UIView *sender = [_backView viewWithTag:_currentPage+10];
    [UIView animateWithDuration:0.25f animations:^{
        self.markView.frame = CGRectMake(sender.frame.origin.x, CGRectGetMaxY(sender.frame)-2, sender.frame.size.width, 2);
    } completion:nil];
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
