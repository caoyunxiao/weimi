//
//  AddSettingViewController.m
//  微密
//
//  Created by MacDev on 15/4/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//
#import "AddSettingViewController.h"
#import "SerViceTableViewCell.h"
#import "NetworkErrorView.h"
#import "ChannelTableViewCell.h"
#import "DetailsOfAnchorViewController.h"
#import "ManagerViewController.h"
#import "DetailsOfChannelViewController.h"

@interface AddSettingViewController ()
{
    NSMutableArray * _dataArray;//数据数组
    NSInteger _startPage;//起始页
    NSInteger _pageSize;//每次拉多少数据
    NetworkErrorView * _errorView;
    NSInteger _dataCount;//请求的数据条数
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddSettingViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    //[_tableView headerBeginRefreshing];
    [_tableView headerBeginRefreshing];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.titleStr;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    [self refreshData];
}
#pragma mark --刷新控件--
- (void)refreshData
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark --下拉刷新--
- (void)headerRefresh
{
    _startPage = 1;
    [self prepareDataWithType:@"1"];
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    _startPage ++;
    if (_dataCount <8)
    {
        [self endRefresh];
        return;
    }
    [self prepareDataWithType:@"2"];
}
///头部尾部停止刷新
- (void)endRefresh
{
    [_tableView  headerEndRefreshing];
    [_tableView footerEndRefreshing];
}
#pragma mark --获取数据--
- (void)prepareDataWithType:(NSString *)type
{
    /////我创建的
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"infoType":@"4",@"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],@"pageCount":@"20"};
    [self getDatawithDic:dic type:type];
}
#pragma mark --请求数据我创建的，我加入的--
- (void)getDatawithDic:(NSDictionary *)dic type:(NSString *)type
{
    [RequestEngine fetchSecretChannelWithDic:dic completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
        _dataCount = dataArray.count;
        if ([errorCode isEqualToString:@"0"]&&dataArray.count>0)
        {
            //加载
            if ([type isEqualToString:@"2"])
            {
                [_dataArray addObjectsFromArray:dataArray];
            }
            else
            {
                _dataArray = dataArray;
            }
            [_tableView reloadData];
            [_errorView removeFromSuperview];
        }
        else if ([errorCode isEqualToString:@"0"]&&dataArray == nil)
        {
            //刷新
            if ([type isEqualToString:@"1"])
            {
                [_dataArray removeAllObjects];
                [_tableView reloadData];
                [_errorView removeFromSuperview];
                [self showNetWorkView];
            }
        }
        [self endRefresh];
    }];
}
#pragma mark --没有数据时显示的画面--
- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5-64);
    
    [self.tableView addSubview:_errorView];
}

#pragma mark -- 表的实现 --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"ChannelCell";
    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChannelTableViewCell" owner:self options:nil]lastObject];
    }
    if(_dataArray.count>0)
    {
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        [cell filleDataWithModel:model ChannelType:self.title];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#pragma mark --点击tableview的cell调用的函数
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
    NSString *actionType = nil;
    if([self.titleStr isEqualToString:@"+键设置"])
    {
        actionType = @"4";
    }
    if([self.titleStr isEqualToString:@"++键设置"])
    {
        actionType = @"5";
    }
    [RequestEngine setOnlyOneUserkeyInfocustomType:@"10" actionType:actionType customParameter:[NSString stringWithFormat:@"%@",model.number] completed:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"0"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            NSDictionary * dict = @{@"modelName":model.name,@"actionType":actionType};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddSettingViewController" object:nil userInfo:dict];
        }
        else
        {
            Alert(@"主人,设置失败了，稍后再试试哟");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];////
    // Dispose of any resources that can be recreated.
}


@end

