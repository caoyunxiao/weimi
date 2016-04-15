//
//  MyChannelViewController.m
//  微密
//
//  Created by MacDev on 15/4/16.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MyChannelViewController.h"
#import "SerViceTableViewCell.h"
#import "NetworkErrorView.h"
#import "ChannelTableViewCell.h"
#import "DetailsOfAnchorViewController.h"
#import "ManagerViewController.h"
#import "DetailsOfChannelViewController.h"
#import "GroupChatViewCell.h"
#import "SetModelZFJ.h"
#import "MBProgressHUD+MJ.h"

@interface MyChannelViewController ()
{
    NSMutableArray *_dataArray;        //数据数组
    NSMutableArray *_myConcernArray;    //我关注的主播数组
    NSInteger _startPage;               //起始页
    NSInteger _startPageAnchor;               //主播起始页
    NSInteger _pageSize;                //每次拉多少数据
    NetworkErrorView * _errorView;
    NSInteger _dataCount;               //请求的数据条数
    NSInteger _pageCount;               //每次请求的条数
    BOOL _canRefresh;
    NSString *_requestType;             //数据请求类型
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  actionType=4+键设置 5++键设置
 */
@property(copy,nonatomic)NSString *actionType;
/**
 *  顶部tab view
 */
@property (weak, nonatomic) IBOutlet UIView *topTabView;
@property(nonatomic,strong)NSMutableArray *settingArr;
/**
 *  提示view
 */
@property(nonatomic,strong)UIAlertView *alert;

/**
 *  是否是第三方设备
 */
@property(nonatomic,copy)NSString *isThirdDevice;

/**
 *  当前选中的聊天按钮
 */
@property(nonatomic,strong)UIButton *currentChatBtn;

@end

@implementation MyChannelViewController

-(NSMutableArray *)settingArr{
    if (_settingArr.count<=0) {
         NSArray *arr=[NSArray arrayWithContentsOfFile:userKeyInfoDataPath];
        _settingArr=[NSMutableArray array];
        for (NSDictionary *dict in arr)
        {
            SetModelZFJ *model = [[SetModelZFJ alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_settingArr addObject:model];
        }
        
    }
    return _settingArr;
}
-(NSString *)isThirdDevice{
    _isThirdDevice=[UserDefaults objectForKey:@"isThirdModel"];
    return _isThirdDevice;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (_firstRefresh||_canRefresh)
    {
        [_tableView headerBeginRefreshing];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _firstRefresh = NO;
    _canRefresh = NO;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self.actionType isEqualToString:@"4"]){
        self.title=@"设置+键";
        self.topTabView.hidden=YES;
        self.tableView.frame=CGRectMake(0, self.tableView.frame.origin.y-34, ScreenWidth, self.tableView.frame.size.height);
        self.navigationItem.rightBarButtonItem=[self createEmptyBtn];
    }else if([self.actionType isEqualToString:@"5"]){
        if ([self.isThirdDevice isEqualToString:@"0"]) {
            self.title=@"设置++键";
        }else{
            self.title=@"设置主聊频道";
        }
        self.topTabView.hidden=YES;
        self.tableView.frame=CGRectMake(0, self.tableView.frame.origin.y-34, ScreenWidth, self.tableView.frame.size.height);
    }else{
        self.title = @"我的频道";
        self.topTabView.hidden=NO;
    }
//    if (iOS7)
//    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;          //视图控制器，四条边不指定
//        self.extendedLayoutIncludesOpaqueBars = NO;            //不透明的操作栏
//    }
    _requestType = @"1";
    self.firstRefresh = YES;
    _pageCount = 20;
    _startPage = 1;
    _startPageAnchor = 1;
    _tableView.clipsToBounds = YES;
    
    self.buttonView.layer.masksToBounds = YES;
    self.buttonView.layer.cornerRadius = 5;
    
    [self.createChannelButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myConcernChannelBtn addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changess) name:@"channelStatus" object:nil];
    [self refreshData];
}
/**
 *  创建置空按钮
 *
 *  @return <#return value description#>
 */
-(UIBarButtonItem*)createEmptyBtn{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 50, 44);
    [btn setTitle:@"置空" forState:UIControlStateNormal];
    btn.titleLabel.textColor=[UIColor whiteColor];
    [btn addTarget:self action:@selector(emptyBtn) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

/**
 *  置空按钮事件
 */
-(void)emptyBtn{
    NSString *iconStr=nil;
    if ([self.actionType isEqualToString:@"4"]) {
        iconStr=@"+";
    }else{
        iconStr=@"++";
    }
    NSString *alertMsg=[NSString stringWithFormat:@"选择置空后，您的%@键无法接收任何频道的聊天噢，确定要置空吗?",iconStr];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=111;
    [alert show];
    
    
    
}
- (void)topButtonClick:(UIButton *)button
{
    //requestType;//请求数据的类型  1我创建的 2我加入的 3我关注的
    
    NSString *buttonName = button.currentTitle;
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if([buttonName isEqualToString:@"我创建的群聊频道"])
    {
        //我创建的群聊频道
        [self.myConcernChannelBtn setTitleColor:[UIColor colorWithRed:11/255.0 green:96/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
        _requestType = @"1";
        if(_dataArray.count==0)
        {
            [self prepareDataWithType:_requestType];
        }
    }
    else
    {
        //我关注的主播频道
        [self.createChannelButton setTitleColor:[UIColor colorWithRed:11/255.0 green:96/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
        _requestType = @"3";
        if(_myConcernArray.count==0)
        {
            [self prepareDataWithType:_requestType];
        }
    }
    [_tableView reloadData];
    
}

- (void)changess
{
    _canRefresh = YES;
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
    if([_requestType isEqualToString:@"1"])
    {
        _startPage = 1;
    }
    else
    {
        _startPageAnchor = 1;
    }
    [self prepareDataWithType:@"1"];
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    if([_requestType isEqualToString:@"1"])
    {
        _startPage ++;
    }
    else
    {
        _startPageAnchor ++;
    }
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
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    NSString *startPageStr = [NSString stringWithFormat:@"%ld",_startPage];
    NSString *accountIDString = [PersonInfo sharePersonInfo].accountIDString;
    /////我创建的
    NSDictionary * dic = nil;
    if ([_requestType isEqualToString:@"1"])
    {
        dic = @{@"appKey":@"iOS",@"accountID":accountIDString,@"infoType":@"2",@"startPage":startPageStr,@"pageCount":pageCountStr};
        [self getDatawithDic:dic type:type];
    }
    /////我关注的
    else if ([_requestType isEqualToString:@"3"])
    {
        [RequestEngine getUserFollowListMicroChannel:_startPageAnchor pageCount:_pageCount completed:^(NSString *errorCode, NSMutableArray *dataArray)
        {
            _dataCount = dataArray.count;
            if ([errorCode isEqualToString:@"0"]&&dataArray.count>0)
            {
                if ([type isEqualToString:@"2"])
                {
                    //加载
                    [_myConcernArray addObjectsFromArray:dataArray];
                }
                else
                {
                    //刷新
                    _myConcernArray = dataArray;
                }
                [_tableView reloadData];
                [_errorView removeFromSuperview];
            }
            else if ([errorCode isEqualToString:@"0"]&&dataArray == nil)
            {
                if ([type isEqualToString:@"1"])
                {
                    [_myConcernArray removeAllObjects];
                    [_tableView reloadData];
                    [_errorView removeFromSuperview];
                    [self showNetWorkView];
                }
            }
            [self endRefresh];
        }];
    }
}
#pragma mark --请求数据我创建的，我加入的--
- (void)getDatawithDic:(NSDictionary *)dic type:(NSString *)type
{
    [RequestEngine fetchSecretChannelWithDic:dic completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
        _dataCount = dataArray.count;
        if ([errorCode isEqualToString:@"0"]&&dataArray.count>0) {
            if ([type isEqualToString:@"2"])
            {
                //加载
                [_dataArray addObjectsFromArray:dataArray];
            }
            else
            {
                //刷新
                _dataArray = dataArray;
            }
            [_tableView reloadData];
            [_errorView removeFromSuperview];
        }
        else if ([errorCode isEqualToString:@"0"]&&dataArray == nil)
        {
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
    if([_requestType isEqualToString:@"1"])
    {
        return [_dataArray count];
    }
    else
    {
        return _myConcernArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"ChannelCell";
//    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
     GroupChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatViewCell" owner:self options:nil]objectAtIndex:2];
    }
    if(_dataArray.count>0)
    {
        NewChannelModel * model = nil;
        if([_requestType isEqualToString:@"1"])
        {
            model = [_dataArray objectAtIndex:indexPath.row];
        }
        else
        {
            model = [_myConcernArray objectAtIndex:indexPath.row];
        }
        
        [cell setGroupChatThreeValue:model classArray:self.settingArr];
        [cell.GCJoinButton addTarget:self action:@selector(startTalkButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.GCJoinButton.tag =indexPath.row;
        NSString *title=[self AssignValueToBtn:model arr:self.settingArr];
        [cell.GCJoinButton setTitle:title forState:UIControlStateNormal];
        if ([_requestType isEqualToString:@"3"]) {
            cell.GCJoinButton.hidden=YES;
        }
        //[cell filleDataWithModel:model ChannelType:self.title];
    }
    return cell;
}


/**
 *得到GCJoinButton的title
 */
-(NSString*)AssignValueToBtn:(NewChannelModel*)model arr:(NSArray*)arr{
    
    NSMutableArray *numberArr = [NSMutableArray array];
    if(arr.count>0)
    {
        for (int i=0; i<arr.count; i++)
        {
            SetModelZFJ *modelClass = [arr objectAtIndex:i];
            NSString *number = modelClass.customParameter;
            if(number==nil){
                number=@"";
            }
            [numberArr addObject:number];
        }
    }
    if ([numberArr indexOfObject:model.number] != NSNotFound)
    {
        
        NSInteger arrIndex=[numberArr indexOfObject:model.number];//关联键的数组下标
        SetModelZFJ *model=[arr objectAtIndex:arrIndex];//得到关联键的信息
        if ([model.actionType isEqualToString:@"0"]) {
            return @"开始聊天";
        }else if([model.actionType isEqualToString:@"4"]){
            return @"关联+键中";
        }else if([model.actionType isEqualToString:@"5"]){
            NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
            if ([isThirdModel isEqualToString:@"1"]) {
                return @"主聊频道";
            }else{
                return @"关联++键中";
            }
        }
        
        
    };
    return @"开始聊天";
}

/**
 *  得到自定义键
 */
-(void)getUserkeyInfo{
    [RequestEngine getUserkeyInfo:@"" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
        
        if([errorCode isEqualToString:@"0"])
        {
            
            NSArray *list = [resultDic objectForKey:@"list"];
            for (NSDictionary *dict in list)
            {
                SetModelZFJ *model = [[SetModelZFJ alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [self.settingArr addObject:model];
            }
        }
        else
        {
            [MBProgressHUD showError:@"主人,网络不给力啊,请检查一下网络吧"];
        }
    }];
    
}

#pragma mark - 开始聊天
- (void)startTalkButton:(UIButton *)button
{
    self.currentChatBtn=button;
    static NSString *alertMsg=@"开始聊天后，您将进入新的聊天频道";
    if ([self.actionType isEqualToString:@"4"]||[self.actionType isEqualToString:@"5"]) {
        NSString *messageStr= @"开始聊天后，您将进入到新的聊天频道";
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"果断设置", nil];
        [_alert show];
    }else{
        if ([self.isThirdDevice isEqualToString:@"0"]) {
            _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联+键",@"关联++键", nil];
            [_alert show];
        }else{
            _alert=[[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"主聊频道", nil];
            [_alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==111&&buttonIndex==1) {
        [MBProgressHUD showMessage:@"主人正在置空中..." view:self.view isShow:NO];
        [RequestEngine setOnlyOneUserkeyInfoEmpty:self.actionType completed:^(NSString *errorCode, NSDictionary *resultDic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([errorCode isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"主人，置空成功!"];
                
                //==========
                NSNotification *notification=[NSNotification notificationWithName:emptyNotificationName object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                //==========
                
                /**
                 *  清空按钮上的关联键设置为 开始聊天 开始
                 */
                for (int i=0; i<=_dataArray.count; i++) {
   
                    NSIndexPath *index=[NSIndexPath indexPathForRow:i inSection:0];
                    GroupChatViewCell *cell=(GroupChatViewCell*)[self.tableView cellForRowAtIndexPath:index];
                    if ([cell.GCJoinButton.titleLabel.text isEqualToString:@"关联+键中"]) {
                        [cell.GCJoinButton setTitle:@"开始聊天" forState:UIControlStateNormal];
                    }
                }
                /**
                 *  结束
                 */
                
            }else{
                [MBProgressHUD showError:@"主人置空失败,请稍后试一试吧"];
            }
        }];
        return;
    }
    
    NewChannelModel *model=nil;
    NSString *myactionType=nil;
    if([_requestType isEqualToString:@"1"])
    {
        model = [_dataArray objectAtIndex:self.currentChatBtn.tag];
    }
    else
    {
        model = [_myConcernArray objectAtIndex:self.currentChatBtn.tag];
    }
    //&&buttonIndex==1
    if(alertView == _alert && buttonIndex>0){
    if([self.actionType isEqualToString:@"4"]||[self.actionType isEqualToString:@"5"]){
        myactionType=self.actionType;
        if(buttonIndex==1){
            //果断设置
            [MBProgressHUD showMessage:@"主人正在设置中..." view:self.view isShow:NO];
            
        }
    }else{
        //右边菜单点击进入
        
        if ([self.isThirdDevice isEqualToString:@"1"]) {
            if (buttonIndex==1) {
                myactionType=@"5";
                [MBProgressHUD showMessage:@"主人正在设置中..." view:self.view isShow:NO];
            }
        }else{
            
            if (buttonIndex==1) {
                myactionType=@"4";
                [MBProgressHUD showMessage:@"主人正在设置中..." view:self.view isShow:NO];
            }else if(buttonIndex==2){
                myactionType=@"5";
                [MBProgressHUD showMessage:@"主人正在设置中..." view:self.view isShow:NO];
            }
            
        }
    }
    }
    
    if([myactionType isEqualToString:@"4"]||[myactionType isEqualToString:@"5"])
    {
        [RequestEngine setOnlyOneUserkeyInfocustomType:@"" actionType:myactionType customParameter:model.InviteUniqueCode completed:^(NSString *errorCode, NSDictionary *resultDic) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([errorCode isEqualToString:@"0"])
            {
                [MBProgressHUD showSuccess:@"主人设置成功了噢"];
                
                NSNotification *notification=[NSNotification notificationWithName:refreshNotificationName object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                //-----------------------关联键改变了，更改数据源的信息   开始
                NSString *channelNumber=[resultDic objectForKey:@"channelNumber"];
                for (int i=0; i<_settingArr.count; i++) {
                    SetModelZFJ *model=_settingArr[i];
                    if ([model.actionType isEqualToString:myactionType]) {
                        model.customParameter=channelNumber;
                        [_settingArr removeObjectAtIndex:i];
                        [_settingArr addObject:model];
                        
                    }
                    
                }
                //[self prepareDataWithType:_requestType];
                if ([myactionType isEqualToString:@"4"]) {
                    [self.currentChatBtn setTitle:@"关联+键中" forState:UIControlStateNormal];
                }
                if ([myactionType isEqualToString:@"5"]&&[self.isThirdDevice isEqualToString:@"1"]) {
                    [self.currentChatBtn setTitle:@"主聊频道" forState:UIControlStateNormal];
                }else if([myactionType isEqualToString:@"5"]&&[self.isThirdDevice isEqualToString:@"0"]){
                    [self.currentChatBtn setTitle:@"关联++键中" forState:UIControlStateNormal];
                }
                [self.tableView reloadData];

            }
            else
            {
                [MBProgressHUD showError:@"主人,设置失败了，稍后再试试哟"];
            }
        }
        ];
       
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#pragma mark --点击tableview的cell调用的函数
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_requestType isEqualToString:@"2"]) //我加入的
    {
        DetailsOfAnchorViewController * vc = [[DetailsOfAnchorViewController alloc]init];
        vc.channelType = @"2";
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        vc.channelNumber = model.number;
        vc.getmodel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_requestType isEqualToString:@"1"])//我创建的
    {
        ManagerViewController * vc = [[ManagerViewController alloc]init];
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        vc.channelNumber = model.number;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([_requestType isEqualToString:@"3"])//我关注的
    {
        DetailsOfChannelViewController *dvc = [[DetailsOfChannelViewController alloc] init];
        NewChannelModel * model = [_myConcernArray objectAtIndex:indexPath.row];
        dvc.channelNumber = model.number;
        //dvc.model = [_dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];////
    // Dispose of any resources that can be recreated.
}


@end