//
//  NewMoreViewController.m
//  微密
//
//  Created by wemeDev on 15/3/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewMoreViewController.h"
#import "MoreCell.h"
#import "MoreTopCell.h"
#import "MoreModely.h"
#import "MoreWebViewController.h"
#import <MapKit/MapKit.h>
#import "DetailWebViewController.h"

@interface NewMoreViewController ()<CLLocationManagerDelegate>
{
    NSMutableArray * _dataArr;
    CLLocationManager * _locationManager;
    NSString * _longitude;
    NSString * _latitude;
}
@end

@implementation NewMoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self judgeLocationManager];
    self.tabBarController.tabBar.hidden = NO;
//    NewRootViewController *rvc = [[NewRootViewController alloc]init];
//    [rvc GetEditionOfApp];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - 判断定位功能是否可用
- (void)judgeLocationManager
{
    if(![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:nil message:@"请开启定位:设置 -> 隐私 -> 位置 -> 定位服务" delegate:nil cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
        [alter show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDataBaseFromTwoWay];
    [self refreshData];
    [self setUIView];
    _NewMoreTableView.tableFooterView = [[UIView alloc]init];
    _locationManager=[[CLLocationManager alloc]init];;
    _locationManager.delegate=self;
    [_locationManager startUpdatingLocation];
    _showImageView = [[UIImageView alloc]init];
    _showImageView.image = [UIImage imageNamed:@"moreImageBig"];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_showImageView addGestureRecognizer:singleTap];
    _showImageView.userInteractionEnabled = YES;
    [self.view addSubview:_showImageView];
}

#pragma mark - 图片点击事件
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://item.m.jd.com/product/1553794.html"]];
}

#pragma mark - 从数据库或者网上加载更多数据
- (void)getDataBaseFromTwoWay
{
    NSString *strTable = @"MoreTable";
    DBOperation *db = [[DBOperation alloc]init];
    BOOL ret = [db createMoreTable:strTable];
    if(ret)
    {
        NSArray *markArray = [db selectMoreDataBaseWith:strTable];
        if(markArray.count<=0)
        {
            //请求数据
            [self requesData];
        }
        else
        {
            _NewMoreTableView.hidden = NO;
            _showImageView.hidden = YES;
            [_dataArr removeAllObjects];
            //[_dataArr addObjectsFromArray:markArray];
            for(int i=1;i<markArray.count;i++)
            {
                MoreModely *model = [markArray objectAtIndex:i];
                [_dataArr addObject:model];
            }
            [_NewMoreTableView reloadData];
        }
    }
    else
    {
        //请求数据
        [self requesData];
    }
}
#pragma mark - 定位
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
#pragma mark - 请求数据
- (void)requesData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * accountId = [PersonInfo sharePersonInfo].accountIDString.length==0?@"":[PersonInfo sharePersonInfo].accountIDString;
    NSString * lg = _longitude.length==0?@"":_longitude;
    NSString * lt = _latitude.length==0?@"":_latitude;
    NSDictionary * dic = @{@"accountID":accountId,@"longitude":lg,@"latitude":lt,@"isCountDownAd":@"0",@"appKey":@"ios"};
    [RequestEngine getMoreListWithDic:dic comple:^(NSString *errorCode, NSMutableArray *dataArr, NSMutableArray *adArray,NSDictionary *resultDict) {
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([errorCode isEqualToString:@"0"])
        {
            _NewMoreTableView.hidden = NO;
            _showImageView.hidden = YES;
            if (dataArr.count>0)
            {
                [_dataArr removeAllObjects];
                _dataArr = dataArr;
            }
            if(adArray.count>0)
            {
                [_adArray removeAllObjects];
                _adArray = adArray;
            }
            [self putInDataBaseWithMarks:_dataArr adArray:adArray];
            [_NewMoreTableView reloadData];
        }
        else
        {
            _NewMoreTableView.hidden = YES;
            _showImageView.hidden = NO;
            _showImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
            
        }
    }];
}
#pragma mark - 把数据存到数据库
- (void)putInDataBaseWithMarks:(NSArray *)array adArray:(NSArray *)adArray
{
    NSString *strTable = @"MoreTable";
    DBOperation *db = [[DBOperation alloc]init];
    BOOL ret = [db createMarksTable:strTable];
    if(ret)
    {
        BOOL retw = [db delectChatStrTable:strTable];
        if(retw)
        {
            //NSLog(@"删除成功");
        }
    }
    NSMutableArray *arrayData = [[NSMutableArray alloc]init];
    //[arrayData addObject:model];
    for (MoreModely * model in array)
    {
        [arrayData addObject:model];
    }
    if(arrayData.count>0)
    {
        DBOperation *db = [[DBOperation alloc]init];
        BOOL ret = [db createMarksTable:strTable];
        if(ret)
        {
            [db addMoreWithArray:arrayData withTableName:strTable];
        }
    }
}


#pragma mark - 配置UI界面
- (void)setUIView
{
    self.title = @"更多";
    _dataArray = [[NSMutableArray alloc]init];
    self.NewMoreTableView.delegate = self;
    self.NewMoreTableView.dataSource = self;
}
#pragma mark - 设置分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
#pragma mark - 设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else
    {
        return _dataArr.count;
    }
}
#pragma mark - 创建tableView的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 153;
    }
    return 60;
}

#pragma mark - 创建tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        static NSString *str = @"MoreTopCell";
        MoreTopCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MoreTopCell" owner:self options:nil]lastObject];
            cell.delegate = self;
        }
        if(_adArray.count>0)
        {
            [cell showUIViewWithNSArray:_adArray];
        }
        return cell;
    }
    else
    {
        static NSString *str = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MoreCell" owner:self options:nil]lastObject];
        }
        if(_dataArr.count>0)
        {
            MoreModely *model = [_dataArr objectAtIndex:indexPath.row];
            [cell filleDataWithModel:model];
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else
    {
        return 20;
    } 
}
#pragma mark - 选中tableView的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoreModely * model;
    if(indexPath.section==0)
    {
        //
    }
    else
    {
        model = [_dataArr objectAtIndex:indexPath.row];
        NSString *urlStr = model.url;
        
        if(urlStr.length>0&&urlStr!=nil)
        {
            [self jumpToTheSpecifiedConnection:model];
        }
    }
}
#pragma mark - 到转到指定连接
- (void)jumpToTheSpecifiedConnection:(MoreModely *)model
{
    if(model.markType==nil||model.markType.length==0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
    }
    else if ([model.markType isEqualToString:@"1"])//跳转到系统url
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
    }
    else if ([model.markType isEqualToString:@"2"])//跳转到app的webview的url
    {
        DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
        dvc.titleName = model.appName;
        dvc.urlStr = model.url;
        [self.navigationController pushViewController:dvc animated:YES];
    }
    else if ([model.markType isEqualToString:@"3"])//可分享
    {
        [self shareClickAction:model];
    }
    else
    {
        //不做处理
    }
}

#pragma mark - 刷新控件
- (void)refreshData
{
    [self.NewMoreTableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [self.NewMoreTableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    [self requesData];
}
#pragma mark - 上拉加载
- (void)footerRefresh
{
    [self requesData];
}
#pragma mark - 头部尾部停止刷新
- (void)endRefresh
{
    [self.NewMoreTableView  headerEndRefreshing];
    [self.NewMoreTableView footerEndRefreshing];
}
#pragma mark - 分享
- (void)shareClickAction:(MoreModely *)model
{

    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.picUrl]];
//    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"分享内容 %@",model.remark] images:@[[UIImage imageWithData:data]] url:[NSURL URLWithString:model.url] title:model.appName type:SSDKContentTypeImage];
//    
////    id<ISSContent> publishContent = [ShareSDK content:model.remark defaultContent:model.remark image:[ShareSDK imageWithUrl:model.picUrl] title:model.appName url:model.url description:model.remark mediaType:SSPublishContentMediaTypeNews];
//    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        if (state == SSDKResponseStateSuccess)
//        {
//            NSLog(@"分享成功");
//        }
//        else if (state == SSDKResponseStateFail)
//        {
//            NSLog(@"分享失败,错误描述:%@",error);
//        }
//    }];
//    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
//     {
//         if (state == SSResponseStateSuccess)
//         {
//             //NSLog(@"分享成功");
//         }
//         else if (state == SSResponseStateFail)
//         {
//             //NSLog(@"分享失败,错误码:%d,错误描述:%@", (int)[error errorCode], [error errorDescription]);
//         }
//     }];
}
#pragma mark - 轮播图片点击代理事件
- (void)selectMoreOneImageByClick:(MoreModely *)model
{
    if(model.markType==nil||model.markType.length==0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
    }
    else if ([model.markType isEqualToString:@"1"])//跳转到系统url
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
    }
    else if ([model.markType isEqualToString:@"2"])//跳转到app的webview的url
    {
        DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
        dvc.titleName = model.appName;
        dvc.urlStr = model.url;
        [self.navigationController pushViewController:dvc animated:YES];
    }
    else if ([model.markType isEqualToString:@"3"])//可分享
    {
        [self shareClickAction:model];
    }
    else
    {
        //不做处理
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
