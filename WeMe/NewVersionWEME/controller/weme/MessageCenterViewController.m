//
//  MessageCenterViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterTableViewCell.h"
#import "RequestEngine.h"
#import "PersonInfo.h"
#import "UIImageView+WebCache.h"
#import "MessagePushModel.h"
#import "AddFriendViewController.h"
#import "ChatInfoViewController.h"
#import "chatDBModel.h"
#import "TaskSystemViewController.h"
#import "DayViewController.h"
#import "WeekViewController.h"
#import "MonthViewController.h"
#import "AchieveViewController.h"
#import "NetworkErrorView.h"
#import "DetailsOfAnchorViewController.h"
#define kSelectCell @"selectCell"
#define kGrayColor [UIColor grayColor]
#define kBlackColor [UIColor blackColor]

@interface MessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_pushArray;
    NSInteger _startPage;//起始页
    NSInteger _dataCount;//请求的数据条数
    NSDictionary *dict;
    NSMutableArray *_addArray;
    
    NetworkErrorView * _errorView;
}

@end

@implementation MessageCenterViewController


- (void) viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [_table headerBeginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息中心";
    [self _addClearAll];         //导航栏添加按钮
    [self createTableView];      //创建UITableView
    _startPage = 1;
    _dataCount = 10;
    self.arrayData = [[NSUserDefaults standardUserDefaults] objectForKey:getPushMessageArray];
    _addArray = [NSMutableArray array];
    [self setExtraCellLineHidden:self.table];
    [self refreshData];          //上拉下拉刷新
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}


#pragma mark - 设置导航栏清除所有的图标
- (void) _addClearAll{

    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll)];

    [self.navigationItem setRightBarButtonItem:backBtn animated:YES];


}
- (void) clearAll{
 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清空全部消息" message:@"主人,你确定要清空消息记录吗?清空后不能恢复哟!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 0)
    {
        //取消
    }else if (buttonIndex == 1)
    {
        [RequestEngine clearMessageCenter:@{@"accountID":[PersonInfo sharePersonInfo].accountIDString} completed:^(NSString *errorCode)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:clearMessageCenterNotifigation object:nil];
            Alert(@"主人,消息已清空完毕了哦");
            [self.table setSeparatorColor:[UIColor clearColor]];
            [_pushArray removeAllObjects];
            [self.table reloadData];
            [self endRefresh];
            [self refreshWithStatus:NO];
            [self showNetWorkView];
        }];
    }
}

#pragma mark - Create UITbaleView
- (void) createTableView
{
    self.table.delegate = self;
    self.table.dataSource = self;
}

#pragma mark --刷新控件--
- (void)refreshData
{
    [_table addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [_table addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}

#pragma mark --下拉刷新--
- (void)headerRefresh
{
    _startPage = 1;
    _dataCount = 20;
    [self _requestData:nil];
}

#pragma mark --上拉加载--
- (void)footerRefresh
{
    _startPage ++;
    if (_dataCount <8) {
        [self endRefresh];
        return;
    }
    [self _requestData:@"1"];

}
#pragma mark - 头部尾部停止刷新
- (void)endRefresh
{
    [_table  headerEndRefreshing];
    [_table footerEndRefreshing];
}
#pragma mark -requestData
- (void)_requestData:(NSString *)types
{
    PersonInfo *person = [PersonInfo sharePersonInfo];
    NSString *accountID = person.accountIDString;
    _pushArray = [NSMutableArray array];
    [self refreshWithStatus:YES];

    [RequestEngine getPushMessage:@{@"accountID":accountID,@"pageNo":@(_startPage),@"pageCount":@(_dataCount)}completed:^(NSString *errorCode, NSMutableArray *modelArr) {
        if([modelArr count] == 0)
        {
            [self.table setSeparatorColor:[UIColor clearColor]];
            [self endRefresh];
            [self refreshWithStatus:NO];
            [self showNetWorkView];
            return;
        }
        _dataCount = modelArr.count;
        if ([errorCode isEqualToString:@"0"] && modelArr.count > 0)
        {
            [_errorView removeFromSuperview];
            [self refreshWithStatus:NO];
            [_table headerEndRefreshing];
            for (int i = 0; i < modelArr.count; i++)
            {
                MessagePushModel *model = [[MessagePushModel alloc] init];
                model.msgTitle = modelArr[i][@"msgTitle"];
                model.senderUserHeadName = modelArr[i][@"senderUserHeadName"];
                model.createTime = [modelArr[i][@"createTime"] integerValue];
                model.content = modelArr[i][@"content"];
                model.messageType = modelArr[i][@"messageType"];
                model.senderAccountID = modelArr[i][@"senderAccountID"];
                model.messageID = modelArr[i][@"id"];
                model.isRead = [modelArr[i][@"isRead"] integerValue];
                model.param = modelArr[i][@"param"];
                model.isAgree = modelArr[i][@"isAgree"];
                NSData *jsonData = [modelArr[i][@"param"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:    jsonData options:NSJSONReadingMutableContainers error:&err];
                model.param = dic;
                [_pushArray addObject:model];
            }
            if ([types isEqualToString:@"1"])
            {
                [_pushArray addObjectsFromArray:_addArray];
            }else{
                [_addArray addObjectsFromArray:_pushArray];
            }
        }
        [self endRefresh];
        [self.table reloadData];
    }];
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _pushArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identif = @"messageCell";
    MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCenterTableViewCell" owner:self options:nil] firstObject];
    }
    if ([_pushArray count] != 0) {
        
        MessagePushModel *model = _pushArray[indexPath.row];
        if(model.isRead == 0){//处理未读消息
        
        
            cell.contentLable.textColor = kBlackColor;
            cell.typeLable.textColor = kBlackColor;
            cell.timeLable.textColor = kBlackColor;
            cell.titleLable.textColor = kBlackColor;
        }else{
        
            cell.contentLable.textColor = kGrayColor;
            cell.typeLable.textColor = kGrayColor;
            cell.timeLable.textColor = kGrayColor;
            cell.titleLable.textColor = kGrayColor;
        }
        cell.contentLable.text = model.content;
        cell.typeLable.text = model.messageType;
        
        NSDateFormatter *formatter  = [[NSDateFormatter alloc] init] ;
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:model.createTime];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.timeLable.text = confromTimespStr;
        cell.titleLable.text = model.msgTitle;
        cell.headImage.layer.cornerRadius = 5;
        cell.headImage.layer.cornerRadius = 5;
        cell.headImage.clipsToBounds = YES;
        cell.headImage.layer.masksToBounds = YES;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagePushModel *model = [_pushArray objectAtIndex:indexPath.row];
    model.isRead = 1;
    MessageCenterTableViewCell *cell =(MessageCenterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *type = cell.typeLable.text;
    
    if([type isEqualToString:@"addFriend"]){//申请加好友
    
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddFriendViewController" bundle:nil];
        AddFriendViewController *addVc = [story instantiateInitialViewController];
        addVc.title = @"添加好友";
        addVc.pushModel = _pushArray[indexPath.row];
        NSString *mid = addVc.pushModel.messageID;
        [self markReadingMessage:mid];
        
        [self.navigationController pushViewController:addVc animated:YES];
    }
    if([type isEqualToString:@"agreeAddFriend"]){//同意添加好友
        MessagePushModel *model = _pushArray[indexPath.row];
        [self markReadingMessage:model.messageID];
        // 刷新指定行
        [self _reloadTableViewCell:indexPath tableView:tableView];

    }if ([type isEqualToString:@"disAgreeAddFriend"]) {//拒绝添加好友
        MessagePushModel *model = _pushArray[indexPath.row];
        [self markReadingMessage:model.messageID];
        // 刷新指定行
        [self _reloadTableViewCell:indexPath tableView:tableView];
        
    }if ([type isEqualToString:@"talk"]) {//聊天
        
        ChatInfoViewController *chatInfo = [[ChatInfoViewController alloc] init];
        
        MessagePushModel *model = _pushArray[indexPath.row];

        [self markReadingMessage:model.messageID];
        chatDBModel * chatModel = [[chatDBModel alloc]init];
         chatModel=[chatDBModel objectWithKeyValues:model.param];
//        chatModel.accountID = model.senderAccountID;
        NSDateFormatter *formatter  = [[NSDateFormatter alloc] init] ;
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[chatModel.pushTime longLongValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        chatModel.pushTime = confromTimespStr;
        if (model.isRead == 0) {
            
            
            chatModel.talkContent = model.param[@"talkContent"];
        }
        chatModel.remarks = @"2";
//        chatModel.friendNickName = model.param[@"friendNickName"];
        
        chatInfo.user = chatModel;
        if (model.isRead == 0) {
            [self saveInDBWithModel:chatModel];
        }
        [self.navigationController pushViewController:chatInfo animated:YES];
        
    }if([type isEqualToString:@"joinSecretChannel"]){//申请加入频道
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddFriendViewController" bundle:nil];
        AddFriendViewController *addVc = [story instantiateInitialViewController];
        addVc.title = @"频道申请";
        addVc.pushModel = _pushArray[indexPath.row];
        NSString *mid = addVc.pushModel.messageID;
        [self markReadingMessage:mid];
        
        [self.navigationController pushViewController:addVc animated:YES];

    }if([type isEqualToString:@"agreeSecretChannelMessage"]){//同意加入频道
        MessagePushModel *model = _pushArray[indexPath.row];
        [self markReadingMessage:model.messageID];
        // 刷新指定行
        [self _reloadTableViewCell:indexPath tableView:tableView];
        //NSLog(@"同意加入了");
    
    }if([type isEqualToString:@"disAgreeSecretChannelMessage"]){//拒绝加入频道
    
        MessagePushModel *model = _pushArray[indexPath.row];
        [self markReadingMessage:model.messageID];
        // 刷新指定行
        [self _reloadTableViewCell:indexPath tableView:tableView];

//        NSLog(@"拒绝加入了");
    
    }if([type isEqualToString:@"quitSecretChannel"]){//退出频道
    
        MessagePushModel *model = _pushArray[indexPath.row];
        [self markReadingMessage:model.messageID];
//        NSLog(@"退出频道");
        // 刷新指定行
        [self _reloadTableViewCell:indexPath tableView:tableView];

    
    }if ([type isEqualToString:@"rochelleReward"]) {//任务系统
        
        MessagePushModel *model = _pushArray[indexPath.row];
        NSString *ruleType = model.param[@"ruleType"];
        if ([ruleType isKindOfClass:[NSNull class]]) {
            ruleType = @"0";
        }

        DayViewController *dayVc = [[DayViewController alloc] init];
        dayVc.taskInfoType = @"1";
        WeekViewController *weekVc = [[WeekViewController alloc] init];
        MonthViewController *monthVc = [[MonthViewController alloc] init];
        AchieveViewController *achieveVc = [[AchieveViewController alloc] init];
        weekVc.taskInfoType = @"2";
        monthVc.taskInfoType = @"3";
        achieveVc.taskInfoType = @"4";
        TaskSystemViewController *taskVc = [[TaskSystemViewController alloc] init];
        taskVc.viewControllers = @[dayVc,weekVc,monthVc,achieveVc];


        if ([ruleType integerValue] > 0) {
            
            taskVc.currentPage = [ruleType integerValue] - 1;
        }
        
        [self markReadingMessage:model.messageID];
        [self.navigationController pushViewController:taskVc animated:YES];
        
        
        
    }if ([type isEqualToString:@"dissolveSecretChannel2Member"]){//解散群消息
    
        MessagePushModel *model = _pushArray[indexPath.row];
        [self markReadingMessage:model.messageID];
        // 刷新指定行
        [self _reloadTableViewCell:indexPath tableView:tableView];

    
    
    }if ([type isEqualToString:@"transferSecretChannel2Admin"]){//转移频道的消息
    
        MessagePushModel *model = _pushArray[indexPath.row];
        DetailsOfAnchorViewController *details = [[DetailsOfAnchorViewController alloc] init];
        details.channelNumber = model.param[@"channelNumber"];
        [self.navigationController pushViewController:details animated:YES];
        [self markReadingMessage:model.messageID];

        [self _reloadTableViewCell:indexPath tableView:tableView];
    }
    if ([type isEqualToString:@"transferSecretChannel2Member"]){//群聊管理员更换
    
        MessagePushModel *model = _pushArray[indexPath.row];
        [self markReadingMessage:model.messageID];
        
        DetailsOfAnchorViewController *details = [[DetailsOfAnchorViewController alloc] init];
        details.channelNumber = model.param[@"channelNumber"];
        [self.navigationController pushViewController:details animated:YES];
        [self _reloadTableViewCell:indexPath tableView:tableView];
    }
}

#pragma mark --存入数据库--
- (void)saveInDBWithModel:(chatDBModel *)dbModel
{
    DBOperation * db = [[DBOperation alloc]init];
    BOOL ret = [db createChatStrTable:dbModel.accountID];
    if (ret)
    {
      NSString *data = [ NSString stringWithFormat:@"A%@",dbModel.accountID];
        if([db addOneDataBaseWithModel:dbModel withTableName:data])//插入数据
        {
            NSLog(@"插入数据成功!");
        }
    }
}

#pragma mark - 标记已读消息
- (void) markReadingMessage:(NSString *)messageID{

    [RequestEngine markReadMessage:@{@"messageID":messageID} completed:^(NSString *errorCode, NSDictionary *resultDic) {
        //NSLog(@"标记消息请求%@",errorCode);
    }];
}
#pragma mark - 没有数据时显示的界面
- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5-64);
    
    [self.table addSubview:_errorView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 刷新指定的行数
- (void)_reloadTableViewCell:(NSIndexPath *) indexPath tableView:(UITableView *)table{
    // 刷新指定行
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [self.table reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
   MessageCenterTableViewCell *cell = (MessageCenterTableViewCell *)[table cellForRowAtIndexPath:indexPath];
    cell.contentLable.textColor = kGrayColor;
    cell.typeLable.textColor = kGrayColor;
    cell.timeLable.textColor = kGrayColor;
    cell.titleLable.textColor = kGrayColor;

}


@end
