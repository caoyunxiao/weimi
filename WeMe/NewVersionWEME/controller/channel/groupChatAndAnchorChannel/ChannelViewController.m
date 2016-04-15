//
//  ChannelViewController.m
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ChannelViewController.h"
#import "ChannelTableViewCell.h"
#import "DetailsOfChannelViewController.h"
#import "DetailsOfAnchorViewController.h"
#import "MobClick.h"
#import "NetworkErrorView.h"
#import "MoreChannelViewController.h"
#import "MarksModel.h"
#import "GroupChatViewCell.h"
#import "SetModelZFJ.h"
#import "MBProgressHUD+MJ.h"
#import "TestViewController.h"

@interface ChannelViewController ()<UISearchBarDelegate>
{
    NSString * _url;
    NSMutableArray * _fenleiArray;   //类别数组
    NSInteger  _startPage;           //起始索引
    NSInteger  _refreshType;         //刷新哪一个（0一开始进入刷新，1点击搜索框的刷新，2点击标签的刷新）
    NSString * _searchMessage;       //点击搜索框要搜索的内容
    NSString * _catalogID;           //频道类别编码
    NetworkErrorView * _errorView;
    NSInteger  _dataCount;           //获得到的数据数量
    BOOL _canRefresh;
    NewChannelModel *_testModel;//验证消息请求的数据
   NSString    *_testNumber;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/**
 *  是否是第三方设备
 */
@property(nonatomic,copy)NSString *isThirdDevice;
@property(nonatomic,strong)PersonInfo *person;

/**
 *  当前开始聊天按钮
 */
@property(nonatomic,strong)UIButton *currentChatBtn;

@end

@implementation ChannelViewController

-(NSString *)isThirdDevice{
    if (_isThirdDevice==nil) {
        _isThirdDevice=[UserDefaults objectForKey:@"isThirdModel"];
    }
    return _isThirdDevice;
}

-(PersonInfo *)person{
    if (_person==nil) {
        _person=[PersonInfo sharePersonInfo];
    }
    return _person;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    if (_firstRefresh||_canRefresh)
    {
        [_tableView headerBeginRefreshing];
    }
    for (UIButton *button in self.viewTwo.subviews)
    {
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
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
    [self getUserkeyInfoCompleted];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change) name:@"channelStatus" object:nil];
    //设置UI界面
    _refreshType = 0;
    _isSearch = NO;
    self.title = self.titleStr;
    self.tabBarController.tabBar.hidden = YES;
    _fenleiArray = [NSMutableArray array];
    _settingArr = [[NSMutableArray alloc]init];
    [self refreshData];
    _dataArray = [[NSMutableArray alloc]init];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self getDataBaseFromTwoWay];
   
}

#pragma mark - 从数据库或者网上加载标签数据
- (void)getDataBaseFromTwoWay
{
    _url = [_titleStr isEqualToString:@"群聊频道"]?@"2":@"1";
    NSString *strTable = nil;
    if([self.titleStr isEqualToString:@"群聊频道"])
    {
        strTable = @"GroupChatChannel";
    }
    else if([self.titleStr isEqualToString:@"主播频道"])
    {
        strTable = @"AnchorChannel";
    }
    DBOperation *db = [[DBOperation alloc]init];
    BOOL ret = [db createMarksTable:strTable];
    if(ret)
    {
        NSArray *markArray = [db selectMarksDataBaseWith:strTable];
        if(markArray.count<=0)
        {
            [self getFenLeiWithType:_url];
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
        [self getFenLeiWithType:_url];
    }
}
- (void)change
{
    _canRefresh = YES;
}
#pragma mark--得到搜索类别标签--
- (void)getFenLeiWithType:(NSString *)type
{
    [self refreshWithStatus:YES];
    [RequestEngine getCatalogInfoWithType:type startPg:1 pageSize:7 completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *result) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            _fenleiArray = dataArray;
            NewChannelModel * model = [[NewChannelModel alloc]init];
            model.name = @"更多";
            [_fenleiArray addObject:model];
            [self putInDataBaseWithMarks:dataArray];
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
    if([self.titleStr isEqualToString:@"群聊频道"])
    {
        strTable = @"GroupChatChannel";
    }
    else if([self.titleStr isEqualToString:@"主播频道"])
    {
        strTable = @"AnchorChannel";
    }
    NSMutableArray *arrayData = [[NSMutableArray alloc]init];
    for (NewChannelModel * model in array)
    {
        MarksModel *markModel = [[MarksModel alloc]init];
        markModel.catalogType = @"2";
        markModel.name = model.name;
        markModel.number = [NSString stringWithFormat:@"%@",model.number];
        markModel.markType = @"marks";
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
    
    if ([_titleStr isEqualToString:@"主播频道"]) {
        
        [self anchorListWithType:_refreshType refreshType:@"1"];
    }
    else
    {
        [self prepareDataWithType:_refreshType refreshType:@"1"];
    }
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    _startPage ++;
    
    if (_dataCount <8) {
        [self endRefresh];
        return;
    }
    if ([_titleStr isEqualToString:@"主播频道"]) {
        [self anchorListWithType:_refreshType refreshType:@"2"];
    }
    else
    {
        [self prepareDataWithType:_refreshType refreshType:@"2"];
    }
    
}
///头部尾部停止刷新
- (void)endRefresh
{
    [self refreshWithStatus:NO];
    [_tableView  headerEndRefreshing];
    [_tableView footerEndRefreshing];
}
#pragma mark --获取数据--群聊
- (void)prepareDataWithType:(NSInteger)type refreshType:(NSString *)refreshType
{
    ///进入界面获取到的数据--
    NSDictionary * dic = nil;
    if (type == 0)
    {
        dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"infoType":@"1",@"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],@"pageCount":@"20",@"cityCode":@"",@"channelNumber":@"",@"catalogID":@"",@"channelName":@"",@"channelKeyWords":@""};
    }
    ////点击搜索框获取数据
    else if (type == 1)
    {
        dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"infoType":@"1",@"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],@"pageCount":@"20",@"channelName":_searchMessage};
    }
    else
        ////点击标签获取数据
    {
        dic = @{@"appKey":@"iOS",
                @"accountID":[PersonInfo sharePersonInfo].accountIDString,
                @"infoType":@"1",
                @"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],
                @"pageCount":@"20",
                @"catalogID":_catalogID};
    }
    [self prepareDataWithDic:dic type:refreshType];
}

#pragma mark -获取主播数据-
- (void) anchorListWithType:(NSInteger)type refreshType:(NSString *)refreshType{
    
    NSDictionary *dict = nil;
    if (type == 0) {
        dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":@"",@"infoType":@"2",@"channelStatus":@"2",@"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],@"pageCount":@"20",@"cityCode":@"",@"channelName":@"",@"catalogID":@"",@"channelKeyWord":@""};
    }//默认刷新
    else if(type == 1){
        dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":@"",@"infoType":@"2",@"channelStatus":@"2",@"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],@"pageCount":@"20",@"cityCode":@"",@"channelName":_searchMessage,@"catalogID":@"",@"channelKeyWord":_searchMessage};
    }//搜索框刷新
    else{
        dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":@"",@"channelStatus":@"2",@"infoType":@"2",@"startPage":[NSString stringWithFormat:@"%ld",(long)_startPage],@"pageCount":@"20",@"cityCode":@"",@"channelName":@"",@"catalogID":_catalogID,@"channelKeyWord":@""};
    }//标签数据
    
    [self prepareDataWithDic:dict type:refreshType];
}

- (void)prepareDataWithDic:(NSDictionary *)dic type:(NSString *)type
{
    if ([_titleStr isEqualToString:@"群聊频道"])
    {
        [self refreshWithStatus:YES];
        [RequestEngine fetchSecretChannelWithDic:dic completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
            [self refreshWithStatus:NO];
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
            }
            else if ([errorCode isEqualToString:@"0"]&&dataArray == nil){
                if ([type isEqualToString:@"1"])
                {
                    _dataArray = dataArray;
                    [_tableView reloadData];
                    [_errorView removeFromSuperview];
                    [self showNetWorkView];
                    [self endRefresh];
                }
            }
        }];
    }
    
    else if([_titleStr isEqualToString:@"主播频道"]){
        [self refreshWithStatus:YES];
        [RequestEngine getAnchorList:dic completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
            [self refreshWithStatus:NO];
            if (dataArray)
            {
                _dataCount = dataArray.count;
            }
            else
            {
                _dataCount = 0;
            }
            //            if (_dataCount == 0)
            //            {
            //                [self endRefresh];
            //                return;
            //            }
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
            }
            else if ([errorCode isEqualToString:@"0"]&&dataArray==nil){
                if ([type isEqualToString:@"1"])
                {
                    _dataArray = dataArray;
                    [_tableView reloadData];
                    [_errorView removeFromSuperview];
                    [self showNetWorkView];
                    [self endRefresh];
                }
            }
            
        }];
    }
    
}
- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5-64);
    
    [self.tableView addSubview:_errorView];
}
#pragma mark - 设置UI界面
- (void)uiConfig
{
    for (UIButton *button in self.viewTwo.subviews)
    {
        if (_fenleiArray.count>0)
        {
            NSInteger index = button.tag-100;
            if(index<_fenleiArray.count)
            {
                NewChannelModel * model = [_fenleiArray objectAtIndex:button.tag-100];
                [button setTitle:model.name forState:UIControlStateNormal];
            }
        }
    }
}
#pragma mark-根据标签查询群聊频道和主播频道--
- (IBAction)buttonClick:(UIButton *)sender
{
    _startPage = 1;
    _refreshType = 2;
    for (UIButton *button in self.viewTwo.subviews)
    {
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [sender setBackgroundColor:[UIColor blueColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (sender.tag-100!=_fenleiArray.count-1)
    {
        NewChannelModel * model = [_fenleiArray objectAtIndex:sender.tag-100];
        _catalogID = [NSString stringWithFormat:@"%@",model.number];
        if (model)
        {
            [self headerRefresh];
        }
    }
    else
    {
        MoreChannelViewController * vc = [[MoreChannelViewController alloc]init];
        vc.isQunLiao = [_titleStr isEqualToString:@"群聊频道"]?YES:NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark-设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
#pragma mark-设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
#pragma mark-设置tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *str = @"ChannelCell";
    //    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    //    if(cell==nil)
    //    {
    //        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChannelTableViewCell" owner:self options:nil]lastObject];
    //    }
    //    if(_dataArray.count>0)
    //    {
    //        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
    //        [cell filleDataWithModel:model ChannelType:self.title];
    //    }
    //    return cell;
    
    
    static NSString * indentifer = @"GroupChatThree";
    GroupChatViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatViewCell" owner:self options:nil]objectAtIndex:2];
    }
    if(_dataArray.count>0)
    {
        [cell setGroupChatThreeValue:[_dataArray objectAtIndex:indexPath.row] classArray:_settingArr];
        [cell.GCJoinButton addTarget:self action:@selector(startTalkButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.GCJoinButton.tag = 100+indexPath.row;
        NewChannelModel *model=[_dataArray objectAtIndex:indexPath.row];
        NSString *title=[self AssignValueToBtn:model arr:_settingArr];
        [cell.GCJoinButton setTitle:title forState:UIControlStateNormal];
    }
    return cell;
}


/**
 *得到GCJoinButton的title
 *
 *  @param model <#model description#>
 *  @param arr   _settingarr;
 *
 *  @return <#return value description#>
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
            //审核未通过
            if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
                return @"等待验证";
            }
            return @"关联+键中";
        }else if([model.actionType isEqualToString:@"5"]){
            //审核未通过
            if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
                return @"等待验证";
            }
            if([self.isThirdDevice isEqualToString:@"1"]){
                return @"主聊频道";
            }else{
                return @"关联++键中";
            }
        }
        
    };
    return @"开始聊天";
}

#pragma mark - 开始聊天
- (void)startTalkButton:(UIButton *)button
{
    _buttonTag = button.tag - 100;
    
    NewChannelModel * model = [_dataArray objectAtIndex:_buttonTag];
    _testNumber=model.number;
    [self getSecretChannelData];//获取验证消息数据model
    
    self.currentChatBtn=button;
    NSString *messageStr= @"主人,你如果重新设置了吐槽键,之前关联的服务频道将要被覆盖掉哦";
    
    if ([self.isThirdDevice isEqualToString:@"1"]) {
        _alert =[[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"主聊频道", nil];
        [_alert show];
    }else{
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联+键",@"关联++键", nil];
        [_alert show];
    }
}

#pragma mark - UIAlertView代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actionType = nil;
    if(alertView == _alert)
    {
         NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
        if ([isThirdModel isEqualToString:@"1"]) {
            if (buttonIndex == 0)
            {
                //取消
            }
            else
            {
                //++键设置
                actionType = @"5";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }
        }else{
            if (buttonIndex == 0)
            {
                //取消
            }
            else if (buttonIndex == 1)
            {
                //+键设置
                actionType = @"4";
                 [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }
            else
            {
                //++键设置
                actionType = @"5";
                 [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }
        }
        if([actionType isEqualToString:@"4"]||[actionType isEqualToString:@"5"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showModelView" object:nil userInfo:nil];
            NewChannelModel * model = [_dataArray objectAtIndex:_buttonTag];
        
            [RequestEngine setOnlyOneUserkeyInfocustomType:@"" actionType:actionType customParameter:model.InviteUniqueCode completed:^(NSString *errorCode, NSDictionary *resultDic) {
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                
                if([errorCode isEqualToString:@"0"])
                {
                    BOOL isVertify=[resultDic[@"isVerify"]boolValue];
                    if (isVertify) {
                        TestViewController *test=[[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
                        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:test];
                        test.applyIdx=resultDic[@"applyIdx"];
                        
                        test.model=_testModel;
                        if (_testModel.adminName!=nil) {
                             [self presentViewController:nav animated:YES completion:nil];
                        }else
                        {
                            Alert(@"主人，获取失败了，再试一次吧");
                        }
                       
                    }else{
                        [MBProgressHUD showSuccess:@"主人设置成功了噢"];
                        //移除
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
                        //-----------------------关联键改变了，更改数据源的信息   开始
                        NSString * channelNumber = [resultDic objectForKey:@"channelNumber"];
                        for (int i=0; i<_settingArr.count; i++) {
                            SetModelZFJ *model=_settingArr[i];
                            if ([model.actionType isEqualToString:actionType]) {
                                model.customParameter=channelNumber;
                                [_settingArr removeObjectAtIndex:i];
                                [_settingArr addObject:model];
                            }
                            
                        }
                        //-----------------------关联键改变了，更改数据源的信息   结束
                        
                        //[self getUserkeyInfoCompleted];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil userInfo:nil];
                    }
                  
                }
                else
                {
                    [MBProgressHUD showError:@"主人,设置失败了，稍后再试试哟"];
                }
                [self.tableView reloadData];
            }];
        }
        
    }
}

#pragma mark-tableView选中事件--频道详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.titleStr isEqualToString:@"主播频道"])
    {
        DetailsOfChannelViewController *dvc = [[DetailsOfChannelViewController alloc] init];
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        dvc.channelNumber = model.number;
        //dvc.model = [_dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    //群聊频道
    else
    {
        DetailsOfAnchorViewController * vc = [[DetailsOfAnchorViewController alloc]init];
        
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        vc.getmodel = model;
        vc.channelNumber = model.number;
        vc.channelType = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark-键盘return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
#pragma mark-点击空白处收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 搜索根据频道名称,号码,管理员,所在地区查询主播频道/群聊频道
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _refreshType = 1;
    _searchMessage = searchBar.text;
    
    if ([_titleStr isEqualToString:@"主播频道"]) {
        
        [self anchorListWithType:_refreshType refreshType:@"1"];
    }
    else
    {
        [self prepareDataWithType:_refreshType refreshType:@"1"];
    }
    _isSearch = YES;
    [self.view endEditing:YES];
}
#pragma mark - 获取频道设置数据
- (void)getUserkeyInfoCompleted
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showModelView" object:nil userInfo:nil];
    [_settingArr removeAllObjects];
    [RequestEngine getUserkeyInfo:@"" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"0"])
        {
            NSArray *list = [resultDic objectForKey:@"list"];
            for (NSDictionary *dict in list)
            {
                SetModelZFJ *model = [[SetModelZFJ alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_settingArr addObject:model];
            }
            if(_settingArr.count>0)
            {
                [_tableView reloadData];
            }
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}

-(void)getSecretChannelData
{
    
    [RequestEngine getSecretChannelInfoWithChannelNumber:_testNumber completed:^(NSString *errorCode, NewChannelModel *model) {
//        NSLog(@"clfclfclf   %@",errorCode);
        if ([errorCode isEqualToString:@"0"]) {
           _testModel=model;
        }
    }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end