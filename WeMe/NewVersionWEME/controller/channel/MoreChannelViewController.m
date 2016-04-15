//
//  MoreChannelViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/25.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MoreChannelViewController.h"
#import "ChannelTableViewCell.h"
#import "DetailsOfAnchorViewController.h"
#import "DetailsOfChannelViewController.h"
@interface MoreChannelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _fenleiArray;//分类标签
    NSMutableArray * _dataArray;
    NSInteger _startPage;
    NSInteger _dataCount;
     NetworkErrorView * _errorView;
    NSString * _catagory;//搜索的分类标签
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MoreChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    self.tabBarController.tabBar.hidden = YES;
    _fenleiArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _startPage = 1;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self refreshData];
    [self getDataBaseFromTwoWay];
}

#pragma mark - 从数据库或者网上加载标签数据
- (void)getDataBaseFromTwoWay
{
    NSString * type = _isQunLiao?@"2":@"1";
    NSString *strTable = nil;
    if(_isQunLiao)
    {
        strTable = @"GroupChatChannelMore";
    }
    else
    {
        strTable = @"AnchorChannelMore";
    }
    DBOperation *db = [[DBOperation alloc]init];
    BOOL ret = [db createMarksTable:strTable];
    if(ret)
    {
        NSArray *markArray = [db selectMarksDataBaseWith:strTable];
        if(markArray.count<=0)
        {
            [self getFenLeiWithType:type];
        }
        else
        {
            [_fenleiArray removeAllObjects];
            [_fenleiArray addObjectsFromArray:markArray];
            [self uiConfig];
        }
    }
    else
    {
        [self getFenLeiWithType:type];
    }
}

#pragma mark--得到搜索类 别标签--
- (void)getFenLeiWithType:(NSString *)type
{
    [self refreshWithStatus:YES];
    [RequestEngine getCatalogInfoWithType:type startPg:1 pageSize:19 completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *result) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            //NSLog(@"dataArray=====%ld",dataArray.count);
            for (int i = 7; i<dataArray.count; i++)
            {
                NewChannelModel * model = [dataArray objectAtIndex:i];
                [_fenleiArray addObject:model];
            }
            [self putInDataBaseWithMarks:_fenleiArray];
            [self uiConfig];
        }
        else
        {
            Alert(@"主人,获取类别失败,请稍后再试吧");
        }
    }];
}
#pragma mark - 把数据存到数据库
- (void)putInDataBaseWithMarks:(NSArray *)array
{
    NSString *strTable = nil;
    if(_isQunLiao)
    {
        strTable = @"GroupChatChannelMore";
    }
    else
    {
        strTable = @"AnchorChannelMore";
    }
    NSMutableArray *arrayData = [[NSMutableArray alloc]init];
    for (NewChannelModel * model in array)
    {
        MarksModel *markModel = [[MarksModel alloc]init];
        markModel.catalogType = @"2";
        markModel.name = model.name;
        markModel.number = model.number;
        markModel.markType = @"moremarks";
        [arrayData addObject:markModel];
    }
    if(arrayData.count>0)
    {
        DBOperation *db = [[DBOperation alloc]init];
        BOOL ret = [db createMarksTable:strTable];
        if(ret)
        {
            [db addMarksWithArray:arrayData withTableName:strTable];
        }
    }
}

#pragma mark - 设置UI界面
- (void)uiConfig
{
    
    for (UIButton *button in self.backView.subviews)
    {
      
        if (_fenleiArray.count>0)
        {
            NewChannelModel * model = [_fenleiArray objectAtIndex:button.tag-100];
            [button setTitle:model.name forState:UIControlStateNormal];
        }
    }
}

#pragma mark --点击函数--
- (IBAction)buttonClick:(UIButton *)sender
{
    for (UIButton * btn in self.backView.subviews)
    {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [sender setBackgroundColor:[UIColor blueColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startPage = 1;
    NewChannelModel * model =  [_fenleiArray objectAtIndex:sender.tag-100];
    _catagory = model.number;
    [self requestDataWithId:_catagory refreshtype:@"1"];
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
    [self requestDataWithId:_catagory refreshtype:@"1"];
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    _startPage ++;
    if (_dataCount <8) {
        [self endRefresh];
        return;
    }
    [self requestDataWithId:_catagory refreshtype:@"2"];
}
///头部尾部停止刷新
- (void)endRefresh
{
    [_tableView  headerEndRefreshing];
    [_tableView footerEndRefreshing];
}

- (void)requestDataWithId:(NSString *)catalogID refreshtype:(NSString *)type
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(catalogID==nil||type==nil)
    {
        [self endRefresh];
        return;
    }
    if (_isQunLiao)
    {
        NSDictionary * dic = @{@"appKey":@"iOS",
                               @"accountID":[PersonInfo sharePersonInfo].accountIDString,
                               @"infoType":@"1",
                               @"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],
                               @"pageCount":@"20",
                               @"catalogID":catalogID};
        [RequestEngine fetchSecretChannelWithDic:dic completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
            if (dataArray)
            {
                _dataCount = dataArray.count;
            }
            else
            {
                _dataCount = 0;
            }
            //NSLog(@"数量 ：：%ld",(long)_dataCount);
            if ([errorCode isEqualToString:@"0"]&&dataArray.count>0) {
                ///加载
                if ([type isEqualToString:@"2"]) {
                    [_dataArray addObjectsFromArray:dataArray];
                }
                else
                {
                    _dataArray = dataArray;
                }
                [self endRefresh];
                [_tableView reloadData];
                [_errorView removeFromSuperview];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            else if ([errorCode isEqualToString:@"0"]&&dataArray == nil){
                if ([type isEqualToString:@"1"])
                {
                    [_dataArray removeAllObjects];
                    [_tableView reloadData];
                    [_errorView removeFromSuperview];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self showNetWorkView];
                    [self endRefresh];
                    
                }
                
            }
        }];
    }
    else
    {
        NSDictionary * dict = @{
                                @"appKey":@"iOS",
                                @"accountID":[PersonInfo sharePersonInfo].accountIDString,
                                @"channelNumber":@"",
                                @"channelStatus":@"2",
                                @"infoType":@"2",
                                @"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],
                                @"pageCount":@"20",
                                @"cityCode":@"",
                                @"channelName":@"",
                                @"catalogID":catalogID,
                                @"channelKeyWord":@""
                                };
        [RequestEngine getAnchorList:dict completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
            if (dataArray)
            {
                _dataCount = dataArray.count;
            }
            else
            {
                _dataCount = 0;
            }
            if ([errorCode isEqualToString:@"0"]&&dataArray.count>0) {
                if ([type isEqualToString:@"2"]) {
                    [_dataArray addObjectsFromArray:dataArray];
                }
                else{
                    _dataArray = dataArray;
                }
                [self endRefresh];
                [_tableView reloadData];
                [_errorView removeFromSuperview];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
            else if (dataArray == nil){
                if ([type isEqualToString:@"1"])
                {
                    [_dataArray removeAllObjects];
                    [_tableView reloadData];
                    [_errorView removeFromSuperview];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self showNetWorkView];
                    [self endRefresh];
                    
                }
            }
            
        }];
    }
}
#pragma mark --表的配置--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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
#pragma mark-tableView选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!_isQunLiao)
    {
        DetailsOfChannelViewController *dvc = [[DetailsOfChannelViewController alloc] init];
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        dvc.channelNumber = model.number;
        dvc.isGenduo = YES;
        //dvc.model = [_dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    else
    {
        DetailsOfAnchorViewController * vc = [[DetailsOfAnchorViewController alloc]init];
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        vc.getmodel = model;
        vc.channelNumber = model.number;
        vc.channelType = @"1";
        vc.isGenduo = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5-100);
    
    [self.tableView addSubview:_errorView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
