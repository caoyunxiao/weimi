//
//  WeMeFriendsViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "WeMeFriendsViewController.h"
#import "WeMeTableViewCell.h"
#import "MailListViewController.h"
#import "ChatViewController.h"
#import "SWTableViewCell.h"
#import "ComplaintFriendViewController.h"
#import "ChatInfoViewController.h"
#import "FriendsSetUpViewController.h"

@interface WeMeFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    NSMutableArray * _dataArray;//数据源数组
}
@end

@implementation WeMeFriendsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    _startPage = 1;
    _pageCount = 20;
    self.title = @"微密好友";
    [self createTable];
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"oneCell"];
    //[self requestData:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount]];
    [self refreshData];
    [_table headerBeginRefreshing];
    ////加好友后刷新好友通讯录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshClick) name:@"addFriendSuccess" object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setActionButton)];}

#pragma mark - 好友设置
- (void)setActionButton
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"FriendsSetUpViewController" bundle:nil];
    FriendsSetUpViewController *friend = [story instantiateInitialViewController];
    [self.navigationController pushViewController:friend animated:YES];
}

- (void)refreshClick
{
    [_table headerBeginRefreshing];
}

- (void)createTable
{
    _table.delegate = self;
    _table.dataSource = self;
}
#pragma mark --刷新控件--
- (void)refreshData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_table addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [_table addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark --下拉刷新--
- (void)headerRefresh
{
    _startPage = 1;
    [_dataArray removeAllObjects];
    [self requestData:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount]];
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    _startPage ++;
    [self requestData:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount]];
}
#pragma mark - 头部尾部停止刷新
- (void)endRefresh
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_table  headerEndRefreshing];
    [_table footerEndRefreshing];
}
#pragma mark --请求数据--
- (void)requestData:(NSString *)startPage pageCount:(NSString *)pageCount
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine queryUserFriendWithstartPage:startPage pageCount:pageCount completed:^(NSString *errorCode, NSMutableArray *modelArr) {
        [self endRefresh];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([errorCode isEqualToString:@"0"]&&modelArr.count>0)
        {
            for (NewChannelModel *model in modelArr)
            {
                [_dataArray addObject:model];
            }
            [_table reloadData];
        }
    }];
}
#pragma  mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//       return 60;
//    }
    return 55;
}
#pragma mark - 控制组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }
        return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        static NSString *identifi = @"cell";
        WeMeTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifi];
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WeMeTableViewCell" owner:self options:nil] firstObject];
        }
        cell.chatButton.tag = indexPath.row;
        cell.chatButton.hidden = YES;
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        [cell.chatButton addTarget:self action:@selector(friendChat:) forControlEvents:UIControlEventTouchUpInside];
        if(_dataArray.count>0)
        {
            [cell filleDataWithModel:[_dataArray objectAtIndex:indexPath.row]];
        }
        return cell;
    }
    
    static NSString *identi = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi forIndexPath:indexPath];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"好友通讯录";
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            //好友通讯录
          UIStoryboard *story = [UIStoryboard storyboardWithName:@"MailListViewController" bundle:nil];
         MailListViewController *mailList = [story instantiateInitialViewController];
            [self.navigationController pushViewController:mailList animated:YES];
        }
    }
    [self performSelector:@selector(unselectCurrentRow)
               withObject:nil afterDelay:.1f];
    if (indexPath.section == 1)
    {
        ChatInfoViewController * chatVc = [[ChatInfoViewController alloc]init];
        [chatVc setValue:@"YES" forKey:@"isWeMeFriendRedirect"];
        NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
        chatDBModel * user = [[chatDBModel alloc]init];
        user.accountID = model.accountID;
        user.gender = model.gender;
        user.accountNickName = model.nickName;
        user.senderUserHeadName = model.userHeadName;
        chatVc.user = user;
        [self.navigationController pushViewController:chatVc animated:YES];
    }
}

#pragma mark - button Action
- (void) friendChat:(UIButton *)sender{

    ChatInfoViewController * chatVc = [[ChatInfoViewController alloc]init];
    //ChatViewController *chatVc = [[ChatViewController alloc] init];
    //chatVc.friendName = @"小明";
    NewChannelModel * model = [_dataArray objectAtIndex:sender.tag];
    chatDBModel * user = [[chatDBModel alloc]init];
    user.accountID = model.accountID;
    user.gender = model.gender;
    user.accountNickName = model.nickName;
    user.senderUserHeadName = model.userHeadName;
    //chatVc.isxiaoxi = NO;
    chatVc.user = user;
    //chatVc.user = [_dataArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:chatVc animated:YES];

}
- (void) unselectCurrentRow
{
    // Animate the deselection
    [_table deselectRowAtIndexPath:
     [_table indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma SWTableViewCell
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"删除好友"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"举报"];
    
    return rightUtilityButtons;
}
#pragma mark SWTableViewCell Delegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath * indexPath = [_table indexPathForCell:cell];
    switch (index) {
        case 0:
        {
            [self deleteFriends:indexPath];
            break;
        }
        case 1:
        {
            UIStoryboard *stord = [UIStoryboard storyboardWithName:@"ComplaintFriendViewController" bundle:nil];
            ComplaintFriendViewController *complain = [stord instantiateInitialViewController];
            complain.reportChannel = NO;
            NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
            complain.reportObject = model.accountID;
            [self.navigationController pushViewController:complain animated:YES];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
            
    }
}
#pragma mark --删除好友--

- (void)deleteFriends:(NSIndexPath *)path
{
    _indexRow = path.row;
    UIAlertView *alertShow = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,你确定要删除该好友吗" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
    alertShow.tag = 789;
    [alertShow show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 789)
    {
        if (buttonIndex == 0)
        {
            NewChannelModel * model = [_dataArray objectAtIndex:_indexRow];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RequestEngine removeUserFriendWithFriendAccountId:model.accountID completed:^(NSString *errorCode) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([errorCode isEqualToString:@"0"]) {
                    [_dataArray removeObjectAtIndex:_indexRow];
                    [_table reloadData];
                }
                else
                {
                    Alert(@"主人,删除好友失败,请稍后再试吧");
                }
            }];
        }
        else if (buttonIndex == 1)
        {
            //取消
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
