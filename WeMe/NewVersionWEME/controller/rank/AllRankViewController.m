//
//  AllRankViewController.m
//  微密
//
//  Created by MacDev on 15/4/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "AllRankViewController.h"
#import "MobClick.h"
#import "RankTableViewCell.h"
#import "TestViewController.h"
@interface AllRankViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AllRankViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleName;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (ScreenHeight == 480)
    {
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    _dataArray = [[NSMutableArray alloc]init];
    [self requestData];//得到数据
}
#pragma mark --数据请求--
- (void)requestData
{
    NSString * requestUrl = [_titleName isEqualToString:@"全国排名"]?@"rankingAll":@"rankingMonth";
//    [RequestEngine getRankListWithUrl:requestUrl complete:^(NSString *errorCode, NSMutableArray *dataArray) {
//        _dataArray = dataArray;
//        [_tableView reloadData];
//    }];
    
    [RequestEngine getRankListWithUrl:requestUrl complete:^(NSString *errorCode, NSString *rankRuleText, RankModel *model, NSMutableArray *dataArray) {
        _dataArray = dataArray;
        [_tableView reloadData];
    }];
}
#pragma mark --表的设置--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifer = @"Cells";
     RankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RankTableViewCell" owner:self options:nil]firstObject];
    }
    [cell fileDataWithData:[_dataArray objectAtIndex:indexPath.row]];
    [cell.addFriendButton addTarget:self action:@selector(addFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)addFriendButtonClick:(UIButton *)btn
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