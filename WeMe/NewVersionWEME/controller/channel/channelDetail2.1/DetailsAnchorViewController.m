//
//  DetailsAnchorViewController.m
//  微密
//
//  Created by ZFJ on 15/8/11.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailsAnchorViewController.h"
#import "ChannelTableViewCell.h"
#import "DetailsOfChannelViewController.h"
#import "NetworkErrorView.h"
@interface DetailsAnchorViewController ()
{
    NetworkErrorView *_errorView;//没有数据的时候显示
}
@end

@implementation DetailsAnchorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData];
    [self uiConfig];
    [self prepareDataWithDic];
}

#pragma mark - 获取数据
- (void)prepareDataWithDic
{
    [self refreshWithStatus:YES];
    NSString *startPageStr = [NSString stringWithFormat:@"%ld",(long)_startPage];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",(long)_pageCount];
    NSString *accountIDString = [PersonInfo sharePersonInfo].accountIDString;
    NSDictionary *dict = nil;
    if(self.isUISearchBar)
    {
        dict = @{@"appKey":@"iOS",@"accountID":accountIDString,@"channelNumber":@"",@"infoType":@"2",@"channelStatus":@"2",@"startPage":startPageStr,@"pageCount":pageCountStr,@"cityCode":@"",@"channelName":_searchMessage,@"catalogID":@"",@"channelKeyWord":_searchMessage};
    }
    else
    {
        dict = @{@"appKey":@"iOS",@"accountID":accountIDString,@"channelNumber":@"",@"channelStatus":@"2",@"infoType":@"2",@"startPage":startPageStr,@"pageCount":pageCountStr,@"cityCode":@"",@"channelName":@"",@"catalogID":_catalogID,@"channelKeyWord":@""};
    }
    [RequestEngine getAnchorList:dict completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
        
        if (dataArray.count==0) {
            [self.detailsAnchorTableView setSeparatorColor:[UIColor clearColor]];
            [self refreshWithStatus:NO];
            [self endRefresh];
            [self showErrorView];
        }
        
        [self refreshWithStatus:NO];
        [self endRefresh];
        if([errorCode isEqualToString:@"0"])
        {
            [_dataArray addObjectsFromArray:dataArray];
        }
        else
        {
            
        }
        [self.detailsAnchorTableView reloadData];
    }];
}
#pragma mark - 无数据时显示视图
-(void)showErrorView
{
    if (_errorView !=nil) {
        [_errorView removeFromSuperview];
    }
    _errorView = [[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:nil options:nil]lastObject];
    _errorView.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height*0.5-64);
    [self.detailsAnchorTableView addSubview:_errorView];
}


#pragma mark - 设置UI界面
- (void)uiConfig
{
    self.title = self.model.name;
    _startPage = 1;
    _pageCount = 20;
    _dataArray = [[NSMutableArray alloc]init];
    _catalogID = [NSString stringWithFormat:@"%@",_model.number];
    self.detailsAnchorTableView.delegate = self;
    self.detailsAnchorTableView.dataSource = self;
    [self setExtraCellLineHidden:self.detailsAnchorTableView];
}

#pragma mark - 隐藏多余的cell分界面
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailsOfChannelViewController *dvc = [[DetailsOfChannelViewController alloc] init];
    NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
    dvc.channelNumber = model.number;
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark --刷新控件--
- (void)refreshData
{
    [self.detailsAnchorTableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [self.detailsAnchorTableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark --下拉刷新--
- (void)headerRefresh
{
    _startPage = 1;
    [_dataArray removeAllObjects];
    [self prepareDataWithDic];
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    _startPage ++;
    
    if (_dataArray.count < 20) {
        [self endRefresh];
        return;
    }
    [self prepareDataWithDic];
}
///头部尾部停止刷新
- (void)endRefresh
{
    [self.detailsAnchorTableView  headerEndRefreshing];
    [self.detailsAnchorTableView footerEndRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
