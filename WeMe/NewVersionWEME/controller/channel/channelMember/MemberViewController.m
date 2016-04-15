//
//  MemberViewController.m
//  微密
//
//  Created by Daoke Dev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberTableViewCell.h"
#import "MobClick.h"
#import "NetworkErrorView.h"
#import "ComplaintFriendViewController.h"
#import "TestViewController.h"
@interface MemberViewController ()<SWTableViewCellDelegate,UIAlertViewDelegate>
{
    NSInteger _startPage;
    NSInteger _dataCount;
    NetworkErrorView * _errorView;
    NSInteger _selectCount;//转移频道选择的
}
@end

@implementation MemberViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"频道成员";
    [self uiConfig];
    _dataArray = [[NSMutableArray alloc]init];
    [self refreshData];
    _MemberTableView.tableFooterView = [[UIView alloc]init];
    [_MemberTableView headerBeginRefreshing];
}
#pragma mark - 获取频道成员
- (void)getMemberData:(NSString *)type
{
    [RequestEngine getUserJoinListWithChannelNum:_channelNumber type:_infoType starPage:[NSString stringWithFormat:@"%ld",_startPage] completed:^(NSString *errorCode, NSMutableArray *dataArr) {
        [self refreshWithStatus:NO];
        _dataCount = dataArr.count;
        if ([errorCode isEqualToString:@"0"]&&dataArr.count>0) {
            if ([type isEqualToString:@"2"]) {
                [_dataArray addObjectsFromArray:dataArr];
            }
            else{
                _dataArray = dataArr;
            }
            [_MemberTableView reloadData];
            [_errorView removeFromSuperview];
        }
        else if ([errorCode isEqualToString:@"0"]&&dataArr == nil){
            if ([type isEqualToString:@"1"])
            {
                [_dataArray removeAllObjects];
                [_MemberTableView reloadData];
                [_errorView removeFromSuperview];
                [self showNetWorkView];
            }
        }
        else
        {
            if ([type isEqualToString:@"1"])
            {
                [_dataArray removeAllObjects];
                [_MemberTableView reloadData];
                [_errorView removeFromSuperview];
                [self showNetWorkView];
            }
            
        }
       [self endRefresh];
    }];

}
#pragma mark --刷新控件--
- (void)refreshData
{
    [self refreshWithStatus:YES];
    [_MemberTableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [_MemberTableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark --下拉刷新--
- (void)headerRefresh
{
    [self refreshWithStatus:YES];
    _startPage = 1;
    [self getMemberData:@"1"];
}
#pragma mark --上拉加载--
- (void)footerRefresh
{
    [self refreshWithStatus:YES];
    _startPage ++;
    if (_dataCount <8) {
        [self endRefresh];
        return;
    }
    [self getMemberData:@"2"];
}
///头部尾部停止刷新
- (void)endRefresh
{
    [self refreshWithStatus:NO];
    [_MemberTableView  headerEndRefreshing];
    [_MemberTableView footerEndRefreshing];
}
- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5-64);
    [self.MemberTableView addSubview:_errorView];
}

#pragma mark - 设置UI界面
- (void)uiConfig
{
    _dataArray = [[NSMutableArray alloc]init];
    self.MemberTableView.delegate = self;
    self.MemberTableView.dataSource = self;
}
#pragma mark-设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count>0)
    {
        return _dataArray.count;
    }
    else
    {
        return 0;
    }
}
#pragma mark-设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}
#pragma mark-设置tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     
    static NSString *str = @"MemberCell";
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MemberTableViewCell" owner:self options:nil]lastObject];
        cell.delegate = self;
        cell.cellDelegate = self;
        if(_isZhuanYi)
        {
            cell.isFriend.hidden = YES;
        }
    }
    if(_dataArray.count>0)
    {
        NewChannelModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.rightUtilityButtons = [self rightButtons:model.talkStatus];
        [cell filleDataWithModel:model];
    }
    
    return cell;
}
#pragma mark-tableView选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
    if (_isZhuanYi&&indexPath.row!=0)
    {
        _selectCount = indexPath.row;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"主人，您确定将该频道的管理权限转移给“%@”吗",model.nickname] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NewChannelModel * model = [_dataArray objectAtIndex:_selectCount];
        NSDictionary * dic = @{@"accountId":model.accountID,@"receiverAccountNickName":model.nickname};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"zhuanyi" object:self userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SWTableView Delgate
- (NSArray *)rightButtons:(NSString *)talkStatus
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]title:@"举报"];
    if(self.isAdministrator)
    {
        if([talkStatus isEqualToString:@"1"])
        {
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]title:@"禁言"];
        }
        else
        {
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]title:@"取消禁言"];
        }
    }
    return rightUtilityButtons;
}

#pragma mark SWTableViewCell Delegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath * indexPath = [_MemberTableView indexPathForCell:cell];
    NewChannelModel * model = [_dataArray objectAtIndex:indexPath.row];
    switch (index) {
        case 0:
        {
            //举报
            UIStoryboard *stord = [UIStoryboard storyboardWithName:@"ComplaintFriendViewController" bundle:nil];
            ComplaintFriendViewController *complain = [stord instantiateInitialViewController];
            complain.reportChannel = NO;
            complain.reportObject = model.accountID;
            [self.navigationController pushViewController:complain animated:YES];
            break;
        }
        case 1:
        {
            //禁言
            _atSection = indexPath.section;
            _cellAtIndexRow = indexPath.row;
            UIButton *button = [cell.rightUtilityButtons objectAtIndex:1];
            if([button.currentTitle isEqualToString:@"禁言"])
            {
                _curStatus = @"2";
            }
            else
            {
                _curStatus = @"1";
            }
            [self manageSecretChannelUsersWithSign:model.accountID];
            break;
        }
            
    }
}
#pragma mark - 禁言
- (void)manageSecretChannelUsersWithSign:(NSString *)userAccountID
{
    MemberTableViewCell *cell = [self cellAtIndexRow:_cellAtIndexRow andAtSection:_atSection];
    UIButton *button = [cell.rightUtilityButtons objectAtIndex:1];
    NSString *infoType = @"2";
    [Request1617 manageSecretChannelUsersWithSign:@"" infoType:infoType channelNumber:_channelNumber curStatus:_curStatus userAccountID:userAccountID completed:^(NSString *errorCode, NSString *result) {
        if([errorCode isEqualToString:@"0"])
        {
            if([_curStatus isEqualToString:@"1"])
            {
                Alert(@"主人,他又何以愉快的和小伙伴玩耍了");
                button.titleLabel.text = @"禁言";
            }
            else if([_curStatus isEqualToString:@"2"])
            {
                Alert(@"主人,禁言成功哦");
                button.titleLabel.text = @"取消禁言";
            }
            for (NewChannelModel *model in _dataArray)
            {
                if([model.accountID isEqualToString:userAccountID])
                {
                    if([_curStatus isEqualToString:@"1"])
                    {
                        model.talkStatus = @"1";
                    }
                    else if([_curStatus isEqualToString:@"2"])
                    {
                        model.talkStatus = @"2";
                    }
                }
            }
            [_MemberTableView reloadData];
        }
    }];
}
#pragma mark - 获取tableView的cell
- (MemberTableViewCell *)cellAtIndexRow:(NSInteger)row andAtSection:(NSInteger) section
{
    MemberTableViewCell * cell = (MemberTableViewCell *)[_MemberTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}

#pragma mark - 加好友
- (void)addFriends:(NSString *)accountID isAllowedOpinion:(NSString *)isAllowedOpinion isVerifyOpinion:(NSString *)isVerifyOpinion accountNickName:(NSString *)accountNickName gender:(NSString *)gender userArea:(NSString *)userArea
{
//    //需要验证
    if([isVerifyOpinion isEqualToString:@"0"])
    {
        NewChannelModel * model = [[NewChannelModel alloc]init];
        model.accountID = accountID;
        model.isAllowedOpinion = isAllowedOpinion;
        model.isVerifyOpinion = isVerifyOpinion;
        model.nickName = accountNickName;
        model.gender = gender;
        model.userArea = userArea;
        
        TestViewController *tvc = [[TestViewController alloc]init];
        tvc.model = model;
        tvc.isFriend = YES;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:tvc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    //不需要验证
    else if([isVerifyOpinion isEqualToString:@"1"])
    {
        NSDictionary *dict = @{@"msgContent":@"",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"friendAccountID":accountID,@"friendNickName":accountNickName,@"gender":gender,@"userArea":userArea};
        [self refreshWithStatus:YES];
        [RequestEngine addFriends:dict completed:^(NSString *errorCode, NSString *result) {
            if([errorCode isEqualToString:@"0"])
            {
                [self refreshWithStatus:NO];
                Alert(@"主人,添加好友成功哦");
                NSString *postNotificationName = [NSString stringWithFormat:@"%@%@",accountID,accountNickName];
                [[NSNotificationCenter defaultCenter] postNotificationName:postNotificationName object:nil userInfo:nil];
            }
            else
            {
                Alert(@"主人,添加好友失败了");
            }
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end