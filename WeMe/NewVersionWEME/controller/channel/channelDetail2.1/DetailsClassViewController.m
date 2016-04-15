//
//  DetailsClassViewController.m
//  微密
//
//  Created by ZFJ on 15/8/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailsClassViewController.h"
#import "ChannelTableViewCell.h"
#import "DetailsOfAnchorViewController.h"
#import "GroupChatViewCell.h"
#import "SetModelZFJ.h"
#import "TestViewController.h"

#define VALIDATEDEFAULTMSG @"你好,申请加入频道"

@interface DetailsClassViewController ()
{
    NewChannelModel *_testModel;//发送验证数据源
    NSString *_testNumber;
}
@property(nonatomic,copy)NSString *isThirdModel;//判断是否是第三方设备
@property(nonatomic,strong)UIView *errorView;
@end

@implementation DetailsClassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getDataFromDataCache];//获取本地缓存的功能键设置信息
    [self getSettingData];
    [self refreshData];//获取数据
    [self uiConfig];
//    [self getDataFromDataCache];//获取本地缓存的功能键设置信息
    
    [self prepareDataWithDic];
    self.view.backgroundColor=[UIColor whiteColor];
    
}

#pragma mark - 获取人们推荐数据
- (void)prepareDataWithDic
{
    __weak typeof(self) selfVc=self;
    [self refreshWithStatus:YES];
    NSString *startPageStr = [NSString stringWithFormat:@"%d",_startPage];
    NSString *pageCountStr = [NSString stringWithFormat:@"%d",_pageCount];
    NSString *accountIDString = [PersonInfo sharePersonInfo].accountIDString;
    NSDictionary * dic = nil;
    if(self.isUISearchBar)
    {
        dic = @{@"appKey":@"iOS",@"accountID":accountIDString,@"infoType":@"1",@"startPage":startPageStr,@"pageCount":pageCountStr,@"channelName":_searchMessage};
    }
    else
    {
        dic = @{@"appKey":@"iOS",@"accountID":accountIDString,@"infoType":@"1",@"startPage":startPageStr,@"pageCount":pageCountStr,@"catalogID":_catalogID};
    }
    [RequestEngine fetchSecretChannelWithDic:dic completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict){
        [self refreshWithStatus:NO];
        [self endRefresh];
        if(dataArray.count<1){
            [selfVc showNodataView];
        }
        if([errorCode isEqualToString:@"0"])
        {
            [_dataArray addObjectsFromArray:dataArray];
        }
        else{
            
        }
       [self.detailsTableView reloadData]; 
    }];
    
}
-(void)showNodataView{
    if (self.errorView) {
        [self.errorView removeFromSuperview];
    }
    self.errorView = [[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:nil options:nil]lastObject];
    self.errorView.center = CGPointMake(self.view.bounds.size.width*0.5, self.view.bounds.size.height*0.5-64);
    [self.view addSubview:self.errorView];
}
#pragma mark - 设置UI界面
- (void)uiConfig
{
    if(self.isUISearchBar)
    {
        self.title = _searchMessage;
    }
    else
    {
        self.title = self.model.name;
    }
    
    //_settingArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    _startPage = 1;
    _pageCount = 20;
    _dataArray = [[NSMutableArray alloc]init];
    _catalogID = [NSString stringWithFormat:@"%@",_model.number];
    self.detailsTableView.delegate = self;
    self.detailsTableView.dataSource = self;
    [self setExtraCellLineHidden:self.detailsTableView];
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
        cell.GCJoinButton.tag = 10+indexPath.row;
        
        NewChannelModel * model = _dataArray[indexPath.row];
        NSLog(@"urlurl:%@",model.logoURL);
        NSString *title=[self AssignValueToBtn:model arr:_settingArr];
        [cell.GCJoinButton setTitle:title forState:UIControlStateNormal];
    }
    return cell;
}
/**
 *得到GCJoinButton的title
 */

-(void)getSettingData{
    _settingArr=[NSMutableArray array];
    [RequestEngine getUserkeyInfo:@"" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
 
        if([errorCode isEqualToString:@"0"])
        {
            [_settingArr removeAllObjects];
            NSArray *list = [resultDic objectForKey:@"list"];
            [list writeToFile:userKeyInfoDataPath atomically:YES];
            for (NSDictionary *dict in list)
            {
                SetModelZFJ *model = [[SetModelZFJ alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_settingArr addObject:model];
            }
            
        }
        else
        {
            //Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }

    }];
}

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


#pragma mark - 开始聊天
- (void)startTalkButton:(UIButton *)button
{
    _buttonTag = button.tag - 10;
    NewChannelModel * model = [_dataArray objectAtIndex:_buttonTag];
    _testNumber=model.number;
    [self getSecretChannelData];//获取验证消息数据model
    
    _isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
    NSString *messageStr= @"主人,关联新的频道后之前的频道会被覆盖掉,你将在新的频道里聊天噢";
    if ([_isThirdModel isEqualToString:@"1"]) {
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联主聊频道", nil];
    }else{
         _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联+键",@"关联++键", nil];
    }
    [_alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak typeof(self) selfvc=self;
    NSString *actionType = nil;
    
    if(alertView == _alert)
    {
        if ([_isThirdModel isEqualToString:@"1"]) {
            if (buttonIndex == 0)
            {
                //取消
            }else{
                //主聊频道
                actionType = @"5";
                [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
            }

        }else{
          if (buttonIndex == 0)
           {
            //取消
            }else if (buttonIndex == 1){
            //+键设置
            actionType = @"4";
            [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
           }else{
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
               

                //移除
                [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
//                NSLog(@"-----------%@",errorCode);
                if([errorCode isEqualToString:@"0"])
                {
                    //----------刷新开始
                    NSNotification *notification=[NSNotification notificationWithName:emptyNotificationName object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    //----------刷新结束
//                    NSLog(@"---%@",resultDic);
                    BOOL isVertify=[resultDic[@"isVerify"]boolValue];
                    if (isVertify) {
//                        TestViewController *test=[[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
//                        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:test];
//                        test.applyIdx=resultDic[@"applyIdx"];
//                        
//                        test.model=_testModel;
//                        if (_testModel.adminName!=nil) {
//                            [self presentViewController:nav animated:YES completion:nil];
//                        }else
//                        {
//                            Alert(@"主人，获取失败了，再试一次吧");
//                        }
                        [selfvc sendJoinChannelValidateMsg:_testModel applyIdx:resultDic[@"isVerify"]];
                       
                    }else{
                        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
                        [MBProgressHUD showSuccess:@"主人，设置成功了哦"];
                        NSString *channelNumber=[resultDic objectForKey:@"channelNumber"];
                        for (int i=0; i<_settingArr.count; i++) {
                            
                            SetModelZFJ *model=_settingArr[i];
                            if ([model.actionType isEqualToString:actionType]) {
                                model.customParameter=channelNumber;
                                [_settingArr removeObjectAtIndex:i];
                                [_settingArr addObject:model];
                                
                            }
                        }
                    }
                     [self getUserkeyInfoCompleted];
                }
                else
                {
                     [MBProgressHUD showError:@"主人,设置失败了，稍后再试试哟"];
                }
                [self.detailsTableView reloadData];
                
            }];
        }
        
    }
}

/**
 *  加入频道如果需要验证发送推送的验证消息
 *
 *  @param model    <#model description#>
 *  @param applyIdx <#applyIdx description#>
 */
-(void)sendJoinChannelValidateMsg:(NewChannelModel*)model applyIdx:(NSString*)applyIdx{
    NSString * channelName = model.name.length==0?@"":model.name;
    NSString * applyIndx = applyIdx;
    NSString * nickName = model.adminName.length==0?@"微密":model.adminName;
    NSString * gender = model.gender.length==0?@"1":model.gender;
    NSString * userAres = model.userArea.length==0?@"上海":model.userArea;
    NSString *accountId=model.accountID.length==0?@"":model.accountID;
    NSDictionary *dict = @{@"msgContent":VALIDATEDEFAULTMSG,@"channelName":channelName,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"adminAccountID":accountId,@"applyAccountID":[PersonInfo sharePersonInfo].accountIDString,@"applyIdx":applyIndx,@"adminAccountNickName":nickName,@"gender":gender,@"userArea":userAres};
    [RequestEngine pushJoinSecretChannelMessageWithDic:dict completed:^(NSString *errorCode) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
        if ([errorCode isEqualToString:@"0"])
        {
            NSLog(@"验证消息发送成功!");
            Alert(@"主人,设置成功啦");
        }
        else
        {
            Alert(@"主人,设置失败啦,稍后再试试哟");
            NSLog(@"验证消息发送失败!");
        }
    }];

}
#pragma mark - 获取频道设置数据
- (void)getUserkeyInfoCompleted
{
    [RequestEngine getUserkeyInfo:@"" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"0"])
        {
            [_settingArr removeAllObjects];
            //本地缓存
            [self putNSDictionary:resultDic withKey:@"getUserkeyInfoCompleted"];
            NSArray *list = [resultDic objectForKey:@"list"];
            for (NSDictionary *dict in list)
            {
                SetModelZFJ *model = [[SetModelZFJ alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_settingArr addObject:model];
            }
            if(_settingArr.count>0)
            {
                [self.detailsTableView reloadData];
            }

        }
        else
        {
            //Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}

#pragma mark - 从本地读取设置缓存信息
- (void)getDataFromDataCache
{
    [_settingArr removeAllObjects];
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"getUserkeyInfoCompleted"];
    if(resultDic != nil)
    {
        NSArray *list = [resultDic objectForKey:@"list"];
        for (NSDictionary *dict in list)
        {
            SetModelZFJ *model = [[SetModelZFJ alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_settingArr addObject:model];
        }
    }
}

#pragma mark - 把字典存在本地
- (void)putNSDictionary:(NSDictionary *)dict withKey:(NSString *)keyName
{
    NSString *pathStr = [self filePath:keyName];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:keyName];
    [archiver finishEncoding];
    [data writeToFile:pathStr atomically:YES];
}

#pragma mark - 从本地读取字典
- (NSDictionary *)getNSDictionaryWithName:(NSString *)keyName
{
    NSString *pathStr = [self filePath:keyName];
    NSData *data= [[NSMutableData alloc]initWithContentsOfFile:pathStr];
    NSKeyedUnarchiver *unarchiver= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dict = [unarchiver decodeObjectForKey:keyName];
    [unarchiver finishDecoding];
    return dict;
}

#pragma mark - 缓存路径
- (NSString *)filePath:(NSString *)fileName
{
    NSString *homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents/DataCache"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:homePath])
    {
        [fm createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(fileName && fileName.length !=0)
    {
        homePath = [homePath stringByAppendingPathComponent:fileName];
    }
    return homePath;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupChatViewCell * cell=[tableView cellForRowAtIndexPath:indexPath
     ];
    DetailsOfAnchorViewController * vc = [[DetailsOfAnchorViewController alloc]init];
    NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
    vc.getmodel = model;
    vc.channelNumber = model.number;
    vc.channelType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 刷新控件
- (void)refreshData
{
    [self.detailsTableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [self.detailsTableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
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
    [self.detailsTableView  headerEndRefreshing];
    [self.detailsTableView footerEndRefreshing];
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

//获取发送验证的数据源
-(void)getSecretChannelData
{
//    NSLog(@"---------------%@",_testNumber);
    [RequestEngine getSecretChannelInfoWithChannelNumber:_testNumber completed:^(NSString *errorCode, NewChannelModel *model) {
        if ([errorCode isEqualToString:@"0"]) {
           _testModel=model;
        }
    }];
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
