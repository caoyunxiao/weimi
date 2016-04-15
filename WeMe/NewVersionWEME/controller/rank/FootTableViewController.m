//
//  FootTableViewController.m
//  微密
//
//  Created by APP on 15/6/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FootTableViewController.h"
#import "FootHeaderView.h"
#import "CityTableViewCell.h"
#import "HotPointTableViewCell.h"
#import "TrackTableViewCell.h"
#import "PathModel.h"
#import "MapDetailViewController.h"
#import "PathTableViewCell.h"
#import "PathTableViewController.h"
#import "FootCityWebTableViewCell.h"
#import "MobClick.h"
#import <ShareSDK/ShareSDK.h>

@interface FootTableViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate>
{
    FootHeaderView *_headerView;
    NSArray *_cityArray;
    NSMutableArray *_pathArray;
    PathModel *_pathModel;
    NetworkErrorView *_errorView;
    UIActivityIndicatorView *activityIndicator1;
    UIActivityIndicatorView *activityIndicator2;
    MapDetailViewController *_mapDetailViewController;
    ModelView *_modelView;
    UIWebView *_hotPointWebView;
    UIWebView *_cityWebView;
    NSString *footImageUrl;
}
@end

@implementation FootTableViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pathArray = [NSMutableArray array];
        _pathModel = [[PathModel alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:self.title];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:[NSString stringWithFormat:@"%@%@",[PersonInfo sharePersonInfo].accountIDString,[self getMonthBeginWith:nil]]];//删除当月日历中保存的数据
    [defaults synchronize];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的足迹";
    [self customUI];
    [self refreshList];
}
#pragma 定制UI界面
- (void)customUI
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    _hotPointWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 228)];
    _hotPointWebView.delegate = self;
    _hotPointWebView.scrollView.bounces = NO;
    _hotPointWebView.backgroundColor = [UIColor colorWithRed:27/255.0 green:27/255.0 blue:27/255.0 alpha:1];
    _cityWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 87, ScreenWidth, 228)];
    _cityWebView.delegate = self;
    _cityWebView.scalesPageToFit = YES;
    _cityWebView.scrollView.bounces = NO;
    _hotPointWebView.scalesPageToFit = YES;
    _cityWebView.backgroundColor = [UIColor colorWithRed:27/255.0 green:27/255.0 blue:27/255.0 alpha:1];
    
}
#pragma 跳到轨迹页面
- (void)footBtnClick
{
    PathTableViewController *pathVc = [[PathTableViewController alloc] init];
    [self.navigationController pushViewController:pathVc animated:YES];
}
#pragma 分享
-(void)rightButtonClick
{
    [self shareClickAction];
}

#pragma mark -- 右侧点击函数-->分享

- (NSString *)screenshot
{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, self.tableView.opaque, 0.0);
    CGPoint savedContentOffset = self.tableView.contentOffset;
    CGRect savedFrame = self.tableView.frame;
    
    self.tableView.contentOffset = CGPointZero;
    self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
    
    [self.tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.tableView.contentOffset = savedContentOffset;
    self.tableView.frame = savedFrame;
    
    //[self uploadImageWithImage:image];
    
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/screenshot"];
    
    NSString *imagePath = [path stringByAppendingFormat:@"/%d.png",0];
    
    BOOL isDir= NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES])
    {
        return imagePath;
    }
    return nil;
}
- (void)uploadImageWithImage:(UIImage *)image
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine uploadFootmarkShareWithImage:image completed:^(NSString *errorCode, NSString *url) {
        if ([errorCode isEqualToString:@"0"]) {
            footImageUrl = url;
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - 分享
-(void)shareClickAction
{
    NSString *imagePath = [self screenshot];
    
    id<ISSContent> publishContent = [ShareSDK content:@"道客们，快来看看我去过的城市、热点和我的轨迹吧，是不是比你们多啊？哈哈" defaultContent:@"默认分享内容，没内容时显示" image:[ShareSDK imageWithPath:imagePath] title:@"道客分享" url:@"https://appsto.re/cn/iYkI2.i" description:@"微密" mediaType:SSPublishContentMediaTypeImage];

    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateSuccess)
        {
            NSLog(@"分享成功");
        }
        else if (state == SSResponseStateFail)
        {
            NSLog(@"分享失败,错误码:%d,错误描述:%@", (int)[error errorCode], [error errorDescription]);
        }
    }];



}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        [MBProgressHUD showSuccess:@"主人分享成功!"];
//    }else{
//        [MBProgressHUD showError:@"主人分享失败!"];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --刷新控件--
- (void)refreshList
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshList)];//头部刷新
    
    [self.tableView headerBeginRefreshing];
}
#pragma mark --下拉刷新--
- (void)headerRefreshList
{
    [self requestData];
    [self requestWebData];
}
- (void)requestData
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    [RequestEngine getArriveCity:^(NSString *errorcode, NSArray *cityArray) {
        if ([errorcode isEqualToString:@"0"]) {
            _cityArray = cityArray;
            [self.tableView reloadData];
        }else{
        
            Alert(@"主人,请检查下你的网络");
        }
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView headerEndRefreshing];
    }];
    [_pathModel pathTravelRefrsh:^(NSMutableArray *travelBlock)
     {
         if ([travelBlock count] >0)
         {
             [_pathArray removeAllObjects];
             
             //[_sectionArray removeAllObjects];
             
             _pathArray = [travelBlock mutableCopy];
             
             [self.tableView reloadData];
         }
         else
         {
             
             if ([_pathArray count] == 0)
             {
                 [_errorView removeFromSuperview];
                 //[self showNetWorkView];
             }
         }
         
         [self.tableView headerEndRefreshing];
     }];
   
    
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 312;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 225;
            break;
        case 3:
            return 300;
            break;
        default:
            return 145;
            break;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else if (section == 1){
        return [self creatLabelWithTitle:@"   城市"];
    }else if (section == 2){
        return [self creatLabelWithTitle:@"   热点"];
    
    }else if(section == 3){
        return [self creatLabelWithTitle:@"   行驶天数和里程"];
    }else if(section == 4+_pathArray.count){
        return [self creatView];
    }else{
        return [self creatLabelWithTitle:[NSString stringWithFormat:@"   轨迹 %@",[[_pathArray objectAtIndex:section-4] objectForKey:kDateString]]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0;
    }
    return 30;
}
- (UILabel *)creatLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    label.text = title;
    label.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:238/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:12];
    return label;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (_pathArray.count == 0) {
//        return 4;
//    }
    return 1+3+_pathArray.count+1;//头视图+三个模块+...+更多
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _cityArray.count+1;
    }else if (section == 2){
        return 1;
        
    }else if(section == 3){
        return 1;
    }else if(section == 4+_pathArray.count){
        return 0;
    }else{
        if (_pathArray.count > 0) {
            return [_pathArray[section- 4][kTravelString] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cityCellId = @"cityCellId";
    static NSString *hotPointCellId = @"hotPointCellId";
    static NSString *calenderCellId = @"calenderCellId";
    static NSString *cellID = @"cellID";
    static NSString *footWebID = @"webID";
        if (indexPath.section == 0) {
            FootCityWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:footWebID];
            if (cell ==nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"FootCityWebTableViewCell" owner:self options:nil][0];
            }
            cell.cityAndPointLabel.text = self.cityAndPointText;
            [cell.contentView addSubview:_cityWebView];
            return cell;
        }else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellId];
                if (cell == nil) {
                    cell = [[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil][0];
                }
                cell.cityNameLabel.text = @"城市";
                cell.firstArriveTimeLabel.text = @"第一次去该城市的时间";
                return cell;
            }
            CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellId];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"CityTableViewCell" owner:self options:nil][0];
            }
            cell.cityNameLabel.text = _cityArray[indexPath.row-1][@"cityName"];
            cell.firstArriveTimeLabel.text = _cityArray[indexPath.row-1][@"firstArriveTime"];
            return cell;
        }else if (indexPath.section==2){
            HotPointTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotPointCellId];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"HotPointTableViewCell" owner:self options:nil][0];
                
                [cell.contentView addSubview:_hotPointWebView];
                
            }
            return cell;
        }else if (indexPath.section == 3){
            TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:calenderCellId];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TrackTableViewCell" owner:self options:nil][0];
            }
            return cell;
        }else{
            PathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (cell == nil)
            {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"PathTableViewCell" owner:self options:nil]lastObject];
            }
            
            NSUInteger section = indexPath.section-4;
            NSUInteger row = indexPath.row;
            if ([_pathArray count]  > 0)
            {
                if ([[[_pathArray objectAtIndex:section] objectForKey:kTravelString] count] > 0)
                {
                    PathTravelInfo *info = [[[_pathArray objectAtIndex:section] objectForKey:kTravelString] objectAtIndex:row];
                    [cell fillData:info];
                }
            }
            [cell.lineView removeFromSuperview];
            return cell;
        }
        return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section<4) {
        return;
    }
    PathDetailInfo *info =  [[[[_pathArray objectAtIndex:indexPath.section-4] objectForKey:kTravelString] objectAtIndex:indexPath.row] detailInfo];
    
    if (_mapDetailViewController == nil)
    {
        _mapDetailViewController = [[MapDetailViewController alloc]init];
    }
    
    [self.navigationController pushViewController:_mapDetailViewController animated:YES];
    
    _mapDetailViewController.detailInfo = info;
}

#pragma webView

- (void)requestWebData
{
//    [MBProgressHUD showHUDAddedTo:_hotPointWebView animated:YES];
//    [MBProgressHUD showHUDAddedTo:_cityWebView animated:YES];
    
    activityIndicator1 = [[UIActivityIndicatorView alloc] init];
    activityIndicator1.color = [UIColor blackColor];
    CGPoint center = _hotPointWebView.center;
    center.y = 112;
    activityIndicator1.center = center;
    [_cityWebView addSubview: activityIndicator1];
    activityIndicator2 = [[UIActivityIndicatorView alloc] init];
    activityIndicator2.color = [UIColor blackColor];
    activityIndicator2.center = _hotPointWebView.center;
    
    [_hotPointWebView addSubview:activityIndicator2];
    [activityIndicator1 startAnimating];
    [activityIndicator2 startAnimating];
    [RequestEngine getHotPointForWebView:^(NSString *errorcode,NSDictionary *dic) {
       
        
    if ([errorcode isEqualToString:@"0"]) {
        if(![dic[@"powerOffHotList"] count]){
            NSString *str = LOGINURL(@"showData/hot.html");
            NSURL *url = [NSURL URLWithString:str];
            [_hotPointWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }else{
            NSString *string = LOGINURL(@"showData/hot.html?param=%@");
            NSString *str = [self dictionaryToJson:dic[@"powerOffHotList"]];//
            NSString *str1 = [NSString stringWithFormat:string,str];
            NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:str2];
            [_hotPointWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }
        if(![dic[@"cityCodeList"] count]){
            NSString *str = LOGINURL(@"showData/city.html");
            NSURL *url = [NSURL URLWithString:str];
            [_cityWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }else{
            NSString *string = LOGINURL(@"showData/city.html?param=%@");
            NSString *str = [self dictionaryToJson:dic[@"cityCodeList"]];
            NSString *str1 = [NSString stringWithFormat:string,str];
            NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:str2];
            [_cityWebView loadRequest:[NSURLRequest requestWithURL:url]];
        }
        }else{
            
            //NSLog(@"获取城市列表失败");
        }
    }];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=2"];
    //<meta content="width=device-width,initial-scale=1.0,minimum-scale=.5,maximum-scale=3" name="viewport">
    [activityIndicator1 stopAnimating];
    [activityIndicator2 stopAnimating];
    [activityIndicator1 removeFromSuperview];
    [activityIndicator2 removeFromSuperview];
}

- (NSString*)dictionaryToJson:(NSArray *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (NSString *)getMonthBeginWith:(NSDate *)newDate{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    //NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        //endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    return beginString;
}
#pragma mark -
#pragma mark UITableViewDelegate
- (UIView *)creatView
{
    UIButton *footBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    footBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:238/255.0 alpha:1];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    footBtn.tintColor = [UIColor blackColor];
    footBtn.frame = CGRectMake(0, 0, ScreenWidth, 40);
    [footBtn addTarget:self action:@selector(footBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footBtn setTitle:@"点击查看更多轨迹" forState:UIControlStateNormal];
    return footBtn;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.tableView.tableFooterView = [self creatView];
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
