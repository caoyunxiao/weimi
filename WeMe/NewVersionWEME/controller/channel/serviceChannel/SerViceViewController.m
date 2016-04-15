//
//  SerViceViewController.m
//  微密
//
//  Created by MacDev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "SerViceViewController.h"
#import "SerViceTableViewCell.h"
#import "ChatFamilyViewController.h"
#import "MobClick.h"
#import "ShareWayViewController.h"
#import "DetailSerViceViewController.h"
#import "ServerZFJModel.h"


@interface SerViceViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SerViceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:self.title];
    [_tableView headerBeginRefreshing];
    [self refreshWithStatus:YES];
 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"服务频道";
    [self refreshData];
    _startPage = 1;
    _pageCount = 20;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [[NSMutableArray alloc]init];
    _locationManager=[[CLLocationManager alloc]init];;
    _locationManager.delegate=self;
    [_locationManager startUpdatingLocation];
   
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations!=nil&&locations.count>0)
    {
        CLLocation *cllocat=[locations firstObject];
        _longitude = [NSString stringWithFormat:@"%f",cllocat.coordinate.longitude];
        _latitude = [NSString stringWithFormat:@"%f",cllocat.coordinate.latitude];
        [HeaderModel sharedHeaderModel].latitude = _latitude;
        [HeaderModel sharedHeaderModel].longitude = _longitude;
        [_locationManager stopUpdatingLocation];
    }
}

#pragma mark- 创建每个tableview的分组数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * indentifer = @"Cell";
    SerViceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SerViceTableViewCell" owner:self options:nil]firstObject];
    }
    if(_dataArray.count>0)
    {
        ServerZFJModel *model = [_dataArray objectAtIndex:indexPath.row];
        [cell showUIViewWithModel:model];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}
#pragma mark - 表的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ServerZFJModel *model = [_dataArray objectAtIndex:indexPath.row];
    DetailSerViceViewController *dvc = [[DetailSerViceViewController alloc]init];
    dvc.serverChannelID = model.customType;
    dvc.name = model.defineName;
    dvc.dict = model.codeMenu;
    dvc.latitude = _latitude;
    dvc.longitude = _longitude;
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 获取服务频道数据列表
- (void)getServerChannelstartPage:(NSString *)startPage pageCount:(NSString *)pageCount
{
    NSString * longitude = _longitude.length==0?@"":_longitude;
    NSString * latitude = _latitude.length==0?@"":_latitude;
    [self refreshWithStatus:YES];
    [Request1617 getCustomDefineInfo:startPage pageCount:pageCount longitude:longitude latitude:latitude defineName:@"" actionType:@"" completed:^(NSString *errorCode, NSDictionary *resultDict) {
        [self endRefresh];
        [self refreshWithStatus:NO];
        if([errorCode isEqualToString:@"0"])
        {
            NSArray *list = [resultDict objectForKey:@"list"];
            for (NSDictionary *dict in list)
            {
                ServerZFJModel *model = [[ServerZFJModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            if(_dataArray.count>0)
            {
                [self.tableView reloadData];
            }
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}

#pragma mark --刷新控件--
- (void)refreshData
{
    [self refreshWithStatus:YES];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark --下拉刷新--
- (void)headerRefresh
{
    _startPage = 1;
    [_dataArray removeAllObjects];
    [self getServerChannelstartPage:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount]];
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    _startPage ++;
    [self getServerChannelstartPage:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount]];
}
///头部尾部停止刷新
- (void)endRefresh
{
    [self refreshWithStatus:NO];
    [_tableView  headerEndRefreshing];
    [_tableView footerEndRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
