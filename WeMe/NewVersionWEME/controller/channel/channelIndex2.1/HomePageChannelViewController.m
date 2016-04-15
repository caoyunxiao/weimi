//
//  HomePageChannelViewController.m
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "HomePageChannelViewController.h"
#import "GroupChatView.h"
#import "AnchorView.h"
#import "ServiceView.h"
#import "CreateChannelViewController.h"
#import "ScanQRViewController.h"
#import "WEMEMyChannelViewController.h"
#import "ChannelViewController.h"
#import "DetailsOfAnchorViewController.h"
#import "MoreChannelViewController.h"
#import "DetailsClassViewController.h"
#import "DetailSerViceViewController.h"
#import "DetailsAnchorViewController.h"
#import "DetailsOfChannelViewController.h"
#import "FunctionSettingViewController.h"
#import "MyChannelViewController.h"
#import "PlistHelper.h"
#import "HistoryModel.h"
#import "RequestManager.h"
#import "MoreCateViewController.h"
#import "TestViewController.h"
#import "httpTool.h"


#define  historyKey @"history"//历史纪录key

@interface HomePageChannelViewController()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *historyListDataSource;//搜索历史纪录数据源
@property(nonatomic,strong)UITableView *historyTableView;//历史纪录tableview
@property(nonatomic,strong)UIButton *rightBtn;//导航栏右边的更多按钮
@property(nonatomic,strong)UIButton *leftBackBtn;//导航栏左边的取消按钮
@property(nonatomic,strong)NSMutableArray *historyData;//历史记录数据
@end

@implementation HomePageChannelViewController

-(UITableView *)historyTableView{
    if (_historyTableView==nil) {
        _historyTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-55-49)];
        [_historyTableView setScrollEnabled:YES];
        _historyTableView.allowsSelection=YES;
        _historyTableView.separatorStyle=NO;
    }
    return _historyTableView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshDevice) name:refreshDeviceNotificationName object:nil];
    if (iOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;          //视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;            //不透明的操作栏
    }
    self.historyData=[NSMutableArray array];
    [self setSearchView];
    [self uiConfig];
    [self refreshDevice];
}
/**
 *  刷新设备
 */
-(void)refreshDevice{
    //终端类型
    self.modelLabel.textColor=[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0 alpha:1];
    NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
    NSString *brandType=[UserDefaults objectForKey:@"brandType"];
    if ([isThirdModel isEqualToString:@"1"]) {
        if (brandType==nil||[brandType isEqualToString:@""]||[brandType isEqualToString:@"NULL"]||[brandType isEqualToString:@"null"]) {
            self.modelLabel.text=@"你正在 未知设备 上使用频道功能";
        }else{
            self.modelLabel.text=[NSString stringWithFormat:@"你正在 %@ 上使用频道功能",brandType];
        }
        
    }else{
        self.modelLabel.text=@"你正在 weme终端 上使用频道功能";
    }
    
}
#pragma 顶部的cell跳转到管理我的频道
/**
 *  顶部的cell跳转到管理我的频道
 */
-(void)homePageRedict:(UIGestureRecognizer*)recognizer{
    //频道管理
    MyChannelViewController *mvc = [[MyChannelViewController alloc]init];
    NSInteger tag=recognizer.view.tag;
    [mvc setValue:[NSString stringWithFormat:@"%ld",(long)tag] forKey:@"actionType"];
    [self.navigationController pushViewController:mvc animated:YES];

}
#pragma mark - 设置UI界面
- (void)uiConfig
{
    self.title = @"频道";
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotButton) name:@"hotButton" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classButtonCenter) name:@"classButtonCenter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showModelView) name:@"showModelView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeModelView) name:@"removeModelView" object:nil];
    
    _touchView = [[UIView alloc]init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [_touchView addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [_touchView addGestureRecognizer:pan];
    [self.view addSubview:_touchView];
    
    self.moreView.clipsToBounds = YES;
    
    
    self.HomePageScrollView.frame = CGRectMake(0, 71, ScreenWidth, ScreenHeight-71-64-50);
    self.HomePageScrollView.pagingEnabled = YES;
    self.HomePageScrollView.delegate = self;
    self.HomePageScrollView.showsHorizontalScrollIndicator = NO;
    self.HomePageScrollView.showsVerticalScrollIndicator = NO;
    self.HomePageScrollView.bounces=NO;
    
    _buttonArray = [[NSMutableArray alloc]init];
    [_buttonArray addObject:self.GroupChatButton];
    [_buttonArray addObject:self.AnchorButton];
    [_buttonArray addObject:self.ServiceButton];
    
    [self.GroupChatButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.AnchorButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ServiceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //右上角弹出框
    [self.createButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ScanningButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.AdministrationButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.functionSettingButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //判断是否是第三方设备，如果是，不显示服务频道
    NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
    if ([isThirdModel isEqualToString:@"1"]) {
        self.ServiceButton.hidden=YES;
        self.GroupChatButton.frame=CGRectMake(0, 0, ScreenWidth/2, 40);
        self.AnchorButton.frame=CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 40);
        
        //群聊频道
        GroupChatView *groupChat = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatView" owner:self options:nil]lastObject];
        groupChat.delegate = self;//代理
        groupChat.frame = CGRectMake(0, 0, ScreenWidth, self.HomePageScrollView.frame.size.height);
        [self.HomePageScrollView addSubview:groupChat];
        
        //主播频道
        AnchorView *anchorView = [[[NSBundle mainBundle]loadNibNamed:@"AnchorView" owner:self options:nil]lastObject];
        anchorView.clipsToBounds = YES;
        anchorView.delegate = self;
        anchorView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.HomePageScrollView.frame.size.height);
        [self.HomePageScrollView addSubview:anchorView];
        self.HomePageScrollView.contentSize= CGSizeMake(ScreenWidth*2, ScreenHeight-71-64-50);
 
    }
    else
    {
        self.HomePageScrollView.contentSize = CGSizeMake(ScreenWidth*3, ScreenHeight-71-64-50);
        //群聊频道
        GroupChatView *groupChat = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatView" owner:self options:nil]lastObject];
        groupChat.delegate = self;//代理
        groupChat.frame = CGRectMake(0, 0, ScreenWidth, self.HomePageScrollView.frame.size.height);
        [self.HomePageScrollView addSubview:groupChat];
        
        //主播频道
        AnchorView *anchorView = [[[NSBundle mainBundle]loadNibNamed:@"AnchorView" owner:self options:nil]lastObject];
        anchorView.clipsToBounds = YES;
        anchorView.delegate = self;
        anchorView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.HomePageScrollView.frame.size.height);
        [self.HomePageScrollView addSubview:anchorView];
        
        //服务频道
        ServiceView *ServiceView = [[[NSBundle mainBundle]loadNibNamed:@"ServiceView" owner:self options:nil]lastObject];
        ServiceView.clipsToBounds = YES;
        ServiceView.delegate = self;
        ServiceView.frame = CGRectMake(ScreenWidth*2, 0, ScreenWidth, self.HomePageScrollView.frame.size.height);
        [self.HomePageScrollView addSubview:ServiceView];
    }
   
    
    //导航栏右边更多按钮
    self.rightBtn=[Custom addBtnWithFrame:CGRectMake(0, 0, 20, 20) nomalImage:@"channelMore" title:nil titleColor:nil target:self action:@selector(moreActionButton)];
    UIBarButtonItem *btnItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.rightBtn.hidden=NO;
    self.moreView.hidden=NO;
    
    self.navigationItem.rightBarButtonItem=btnItem;
    
    self.downView.layer.masksToBounds = YES;
    self.downView.layer.cornerRadius = 5;
    
    [self.view bringSubviewToFront:self.moreView];
    
    //搜索框点击视图，点击后隐藏键盘
    _searchButton=[UIButton buttonWithType:UIButtonTypeSystem];
    _searchButton.frame=CGRectMake(0, 71, ScreenWidth, ScreenHeight-64-49);
    [self.view addSubview:_searchButton];
    _searchButton.hidden=YES;
    
    //终端类型
    self.modelLabel.text=[NSString stringWithFormat:@"你正在 %@ 上使用频道功能",[UserDefaults objectForKey:@"brandType"]];
    
    
}
//#pragma mark - 更多群聊频道
//- (void)hotButton
//{
//    //群聊频道
//    ChannelViewController *cvc = [[ChannelViewController alloc]init];
//    cvc.titleStr = @"群聊频道";
//    cvc.firstRefresh = YES;
//    [self.navigationController pushViewController:cvc animated:YES];
//}
//#pragma mark - 更多分类
//- (void)classButtonCenter
//{
//    MoreChannelViewController * vc = [[MoreChannelViewController alloc]init];
//    vc.isQunLiao = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 显示加载视图
- (void)showModelView
{
    if (!_modelView) {
        _modelView = [[ModelView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_modelView];
    }
}
- (void)removeModelView
{
    if(_modelView != nil)
    {
        [_modelView removeFromSuperview];
    }
}
#pragma mark - 设置搜索框
- (void)setSearchView
{
    //导航条的搜索条
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f,220.0f,25.0f)];
    _searchBar.delegate = self;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.cornerRadius = 5;
    [_searchBar setPlaceholder:@"搜索频道号/频名称"];
    _searchBar.backgroundColor=[UIColor whiteColor];
    _searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_searchBar.bounds.size];
    
    //将搜索条放在一个UIView上
    _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 220, 25)];
    [_searchView addSubview:_searchBar];
    self.navigationItem.titleView = _searchView;
}
#pragma mark -- 搜索根据频道名称,号码,管理员,所在地区查询主播频道/群聊频道
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _searchMessage = searchBar.text;
    
//    //添加到搜索记录
//    [PlistHelper addToSearchHistory:_searchMessage];
   [self.historyTableView removeFromSuperview];
    
    if(_indexButton == 0)
    {
        //群聊频道
        DetailsClassViewController *dvc = [[DetailsClassViewController alloc]init];
        dvc.isUISearchBar = YES;
        dvc.searchMessage = _searchMessage;
        
        [self.navigationController pushViewController:dvc animated:NO];
    }
    else if (_indexButton == 1)
    {
        //主播频道
        DetailsAnchorViewController *dvc = [[DetailsAnchorViewController alloc]init];
        dvc.isUISearchBar = YES;
        dvc.searchMessage = _searchMessage;
        
        [self.navigationController pushViewController:dvc animated:NO];
    }
    else if (_indexButton == 2)
    {
        //服务频道
    }
    searchBar.text = @"";
    [self.view endEditing:YES];
}
#pragma mark - 获取历史记录的数据
-(void)getHIstoryData
{
    if (self.historyData.count>0) {
        [self.historyData removeAllObjects];
    }
 
    AFHTTPRequestOperationManager *manager=[RequestManager getManager];
    NSDictionary *dic=@{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"actionType":@""};
    [manager POST:LOGINURL(@"getUserKeyHistoryList") parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableArray *tmpArray=[NSMutableArray array];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *errorStr = [responseObject objectForKey:@"ERRORCODE"];
            if ([errorStr isEqualToString:@"0"]) {
                NSDictionary *resultDict = [responseObject objectForKey:@"RESULT"];
                NSArray *list=resultDict[@"list"];
                for (NSDictionary *dic in list) {
                    HistoryModel *model=[[HistoryModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    NSString *typeTime=[self settingTimeType:model.updateTime];
                    model.updateTime=typeTime;
                    if (![model.parameterName isEqualToString:@""]) {
                        [tmpArray addObject:model];
                    }
            }
                if (tmpArray.count>6) {
                    for (int i=0; i<6; i++) {
                        [self.historyData addObject:tmpArray[i]];
                    }
                }else{
                    self.historyData=[NSMutableArray arrayWithArray:tmpArray];
                }
  
            }
            [self.historyTableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];

}
#pragma mark - 时间戳转化
-(NSString *)settingTimeType:(NSString *)timeStr
{
    NSTimeInterval time=[timeStr doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    [dateFormat setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *curTime=[dateFormat stringFromDate:detailDate];
    return curTime;
    
//    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
//    NSString *number=@"1441718266";
//    long long time1=[number longLongValue];
//    long long time2=dTime-time1;
//    NSDate *now=[NSDate date];
//    NSDate * yesDay = [now addTimeInterval:-time2];
//    NSDateFormatter * f = [[NSDateFormatter alloc] init];
//    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString * str = [f stringFromDate:yesDay];
//    NSLog(@"str:%@",str);
//    return str;
}


#pragma mark - 搜索框开始编辑
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
     [self.view addSubview:self.historyTableView];
     [self getHIstoryData];

    self.historyTableView.hidden=NO;
    self.historyTableView.delegate=self;
    self.historyTableView.dataSource=self;
    [self.historyTableView reloadData];
    
//    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
//    NSString *title=self.historyListDataSource.count>0?@"清空按键设置历史记录":@"无按键设置历史记录";
//    UIButton *footerBtn=[Custom addBtnWithFrame:CGRectMake(0, 0, ScreenWidth, 20) nomalImage:nil title:title titleColor:nil target:self action:@selector(deleteAllHistroy)];
//    [footerView addSubview:footerBtn];
//    footerBtn.tag=1111;
//    self.historyTableView.tableFooterView=footerView;
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    NSString *title=@"按键设置历史";
    UILabel *headerLabel=[Custom addLabelWithFrame:headerView.frame labelText:title textColor:[UIColor blueColor]];
    headerLabel.font=[UIFont systemFontOfSize:13.0f];
    [headerView addSubview:headerLabel];
    self.historyTableView.tableHeaderView=headerView;
    
    //隐藏之前的频道更多按钮，添加取消按钮
    self.rightBtn.hidden=YES;
    self.moreView.hidden=YES;
    
    self.leftBackBtn=[Custom addBtnWithFrame:CGRectMake(0, 0, 30, 20) nomalImage:nil title:@"取消" titleColor:nil target:self action:@selector(backHome:)];
    self.leftBackBtn.hidden=NO;
    self.leftBackBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    UIBarButtonItem *leftBtnItem=[[UIBarButtonItem alloc]initWithCustomView:self.leftBackBtn];
    self.navigationItem.leftBarButtonItem=leftBtnItem;
    
    //点击隐藏键盘事件
    _searchButton.hidden=NO;
    [_searchButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return YES;
}
#pragma mark - 搜索点击屏幕隐藏键盘
-(void)btnClick:(id)sender
{
    [_searchBar resignFirstResponder];
    _searchButton.hidden=YES;
}
#pragma mark -返回搜索之前的界面
-(void)backHome:(id)sender
{
    self.leftBackBtn.hidden=YES;
    
    self.historyTableView.hidden=YES;
    self.rightBtn.hidden=NO;
    self.moreView.hidden=NO;
    
    [_searchBar resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_searchBar resignFirstResponder];
}

#pragma mark - 清空历史记录
//-(void)deleteAllHistroy{
//    [PlistHelper EmptyHistory];
//    self.historyListDataSource=[PlistHelper GetHistoryList];
//    
//    UIButton *btn=(UIButton *)[self.historyTableView.tableFooterView viewWithTag:1111];
//    [btn setTitle:@"无按键设置历史记录" forState:UIControlStateNormal];
//    
//    [self.historyTableView reloadData];
//}

#pragma mark - 历史纪录tableview代理相关
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId=@"historyCellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]init];
        HistoryModel *model=self.historyData[indexPath.row];
        cell.textLabel.text=model.parameterName;
        cell.textLabel.font=[UIFont systemFontOfSize:13.0f];
        
        CGFloat wd=cell.contentView.bounds.size.width;
        CGFloat hg=cell.contentView.bounds.size.height;
        UILabel *timeLabel=[Custom addLabelWithFrame:CGRectMake(wd-150, 0, 150, hg) labelText:model.updateTime textColor:[UIColor grayColor]];
        timeLabel.font=[UIFont systemFontOfSize:13.0f];
        [cell.contentView addSubview:timeLabel];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    HistoryModel *model=self.historyData[indexPath.row];
    _searchMessage =model.parameterName;
    
    if(_indexButton == 0)
    {
        //按键设置历史详情跳转
        //群聊频道
        DetailsClassViewController *dvc = [[DetailsClassViewController alloc]init];
        dvc.isUISearchBar = YES;
        dvc.searchMessage = _searchMessage;
        [self.navigationController pushViewController:dvc animated:NO];
    }
    else if (_indexButton == 1)
    {
        //主播频道
        DetailsAnchorViewController *dvc = [[DetailsAnchorViewController alloc]init];
        dvc.isUISearchBar = YES;
        dvc.searchMessage = _searchMessage;
        
        [self.navigationController pushViewController:dvc animated:YES];
    }
    else if (_indexButton == 2)
    {
        //服务频道
    }
    [self.view endEditing:YES];
}

#pragma mark - 右上角弹出框事件
- (void)rightButtonClick:(UIButton *)button
{
    NSInteger index = button.tag - 1240;
    if(index==0)
    {
        //创建频道
        CreateChannelViewController * vc = [[CreateChannelViewController alloc]init];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if (index==1)
    {
        //扫一扫
        ScanQRViewController *scanVC = [[ScanQRViewController alloc]init];
        scanVC.isErWeiMa = YES;
        UINavigationController *scanNav = [[UINavigationController alloc]initWithRootViewController:scanVC];
        [self presentViewController:scanNav animated:YES completion:nil];
    }
    else if (index==2)
    {
        //频道管理
        MyChannelViewController *mvc = [[MyChannelViewController alloc]init];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    else if (index==3)
    {
        //我的小密
        FunctionSettingViewController *function = [[FunctionSettingViewController alloc]init];
        [self.navigationController pushViewController:function animated:YES];
    }
}

#pragma mark - 取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 更多
- (void)moreActionButton
{
    if (self.moreView.frame.size.height == 0)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.moreView.frame = CGRectMake(ScreenWidth-108, 0, 100, 141);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.moreView.frame = CGRectMake(ScreenWidth-108, 0, 100, 0);
        }];
    }
    _touchView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-44);
}
#pragma mark - 屏幕点击事件
- (void)singleTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        self.moreView.frame = CGRectMake(ScreenWidth-108, 0, 100, 0);
    }];
    _touchView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-44);
}

#pragma mark - ScrollView代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UIButton *buttonOld in _buttonArray)
    {
        [buttonOld setTitleColor:[UIColor colorWithRed:11/255.0 green:96/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    }
    _indexButton = self.HomePageScrollView.contentOffset.x/ScreenWidth;
    UIButton *button = (UIButton *)[self.view viewWithTag:(_indexButton+1230)];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if (_indexButton==2) {
        NSString *imei=[PersonInfo sharePersonInfo].IMEIString;
        
        if ([imei isEqualToString:@""]) {
            Alert(@"主人，您还没有绑定IMEI号，只有绑定IMEI号才能使用服务频道功能哦");
        }
    }
}
#pragma mark - 头部三个button点击视图切换
- (void)buttonClick:(UIButton *)button
{
    self.historyTableView.hidden=YES;
    self.rightBtn.hidden=NO;
    self.moreView.hidden=NO;
    
    self.leftBackBtn.hidden=YES;
    [_searchBar resignFirstResponder];
    
    [self.view endEditing:YES];
    for (UIButton *buttonOld in _buttonArray)
    {
        [buttonOld setTitleColor:[UIColor colorWithRed:11/255.0 green:96/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    }
    _indexButton = button.tag - 1230;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    CGPoint pt = self.HomePageScrollView.contentOffset;
    pt.x = ScreenWidth*_indexButton;
    [UIView animateWithDuration:0.5 animations:^{
        [self.HomePageScrollView setContentOffset:pt];
    }];
    if (_indexButton==2) {
       
        NSString *imei=[PersonInfo sharePersonInfo].IMEIString;
        
        if ([imei isEqualToString:@""]) {
            Alert(@"主人，您还没有绑定IMEI号，只有绑定IMEI号才能使用服务频道功能哦");
        }
    }
}

#pragma mark - 视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.moreView.frame = CGRectMake(ScreenWidth-108, 0, 100, 0);
    self.tabBarController.tabBar.hidden = NO;
    [self refreshDevice];
}
#pragma mark - 群聊代理事件
- (void)selectHotChannelCell:(NewChannelModel *)model
{
    DetailsOfAnchorViewController *vc = [[DetailsOfAnchorViewController alloc]init];
    vc.getmodel = model;
    vc.channelNumber = model.number;
    vc.channelType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 更多事件
- (void)moreButton:(NSInteger)index
{
    if(index==1)
    {
        //群聊频道
        ChannelViewController *cvc = [[ChannelViewController alloc]init];
        cvc.titleStr = @"群聊频道";
        cvc.firstRefresh = YES;
        [self.navigationController pushViewController:cvc animated:YES];
    }
    else if (index==8)
    {
        //分类推荐更多
        MoreCateViewController * vc = [[MoreCateViewController alloc]init];
        vc.isQunLiao = YES;

        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 选择分类
- (void)selectClassChannelView:(NewChannelModel *)model
{
    DetailsClassViewController *dvc = [[DetailsClassViewController alloc]init];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 服务频道cell选择
- (void)selectServiceChannelCell:(ServerZFJModel *)model
{
    DetailSerViceViewController *dvc = [[DetailSerViceViewController alloc]init];
    dvc.serverChannelID = model.customType;
    dvc.name = model.defineName;
    dvc.dict = model.codeMenu;
    dvc.latitude = [HeaderModel sharedHeaderModel].latitude;
    dvc.longitude = [HeaderModel sharedHeaderModel].longitude;
    [self.navigationController pushViewController:dvc animated:YES];
}
#pragma mark - 主播选择分类按钮事件
- (void)selectAnchorOneClassButton:(NewChannelModel *)model
{
    DetailsAnchorViewController *dvc = [[DetailsAnchorViewController alloc]init];
    dvc.model = model;
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - 主播详情
- (void)selectAnchorDetailInforOfView:(NewChannelModel *)model
{
    DetailsOfChannelViewController *dvc = [[DetailsOfChannelViewController alloc] init];
    dvc.channelNumber = model.number;
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
//跳到验证界面
-(void)pushToTestViewController:(NewChannelModel *)model applyIdx:(NSString *)applyIdx actionType:(NSString*)actionType
{
    TestViewController *test=[[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
   
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:test];
    test.model=model;
    test.applyIdx=applyIdx;
    if (model.adminName!=nil) {
        [self setUserKey:model actionType:actionType];
        [self presentViewController:nav animated:YES completion:nil];
    }else
    {
        Alert(@"主人，获取失败了，再试一次吧");
    }
    

}

-(void)setUserKey:(NewChannelModel*)model actionType:(NSString*)actionType{
    [RequestEngine setOnlyOneUserkeyInfocustomType:@"" actionType:actionType customParameter:model.InviteUniqueCode completed:^(NSString *errorCode, NSDictionary *resultDic) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
        if([errorCode isEqualToString:@"0"]){
            [MBProgressHUD showSuccess:@"主人设置成功了噢"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
            
//            //-----------------------关联键改变了，更改数据源的信息   开始
//            NSString *channelNumber=[resultDic objectForKey:@"channelNumber"];
//            for (int i=0; i<_settingArr.count; i++) {
//                SetModelZFJ *model=_settingArr[i];
//                if ([model.actionType isEqualToString:actionType]) {
//                    model.customParameter=channelNumber;
//                    [_settingArr removeObjectAtIndex:i];
//                    [_settingArr addObject:model];
//                    
//                }
//                
//            }
        }else{
            Alert(@"主人,设置失败了，稍后再试试哟");
        }
    }];

}
- (void)didReceiveMemoryWarning
{
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
