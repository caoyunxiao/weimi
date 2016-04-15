//
//  FootPrintViewController.m
//  微密
//
//  Created by MacDev on 15/4/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FootPrintViewController.h"
#import "FootPrintTableViewCell.h"
#import "MobClick.h"
#import "TestViewController.h"
#import "FootHeaderView.h"
#import "CityTableViewCell.h"
@interface FootPrintViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FootPrintViewController

{
    int _kHeaderTag;//10 加好友 11 城市 12 热点 13轨迹 14 行驶天数和里程
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的足迹";
    _kHeaderTag = 11;
    [self customTableHeaderView];

    
//    if (ScreenHeight == 480)
//    {
//        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    }
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
- (void)customTableHeaderView
{
    FootHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"FootHeaderView" owner:self options:nil][0];
    self.tableView.tableHeaderView = headerView;
    headerView.headerCallBack = ^(int kHeaderTag){
        _kHeaderTag = kHeaderTag;
        if (kHeaderTag == 10) {//加好友
            [self addFriendButtonClick];
        }else{
            [_tableView reloadData];
        }
        
    };
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_kHeaderTag == 0 || _kHeaderTag == 11) {
        return 5;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifer = @"Cell";
//    FootPrintTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
//    if (!cell)
//    {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"FootPrintTableViewCell" owner:self options:nil]firstObject];
//    }
//    [cell.addFriendButton addTarget:self action:@selector(addFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil][_kHeaderTag-11];
    }
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 15;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 15;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark --跳转到添加好友--
- (void)addFriendButtonClick
{
    TestViewController * vc = [[TestViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
