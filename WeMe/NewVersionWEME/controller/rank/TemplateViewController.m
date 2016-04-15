//
//  TemplateViewController.m
//  微密
//
//  Created by APP on 15/6/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TemplateViewController.h"
#import "MobClick.h"
#import "RankTableViewCell.h"
#import "TestViewController.h"
#import "TemHeadView.h"
#import "TemHeadViewx.h"
#import "TemHeadViewz.h"
#import "RequestEngine.h"
#import "TemHeadVieww.h"
@interface TemplateViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TemplateViewController
{
    RankModel *_model;
    NSString *_rankRuleText;
    NSArray *_rankArray;
    TemHeadView *_view;
    TemHeadViewx *_viewx;
    TemHeadViewz *_viewz;
    TemHeadVieww *_vieww;
    NSDictionary *_myRankInfoDic;
    NetworkErrorView *_errorView;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    //[_tableView headerBeginRefreshing];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleName;
    [self refreshData];
    _tableView.tableFooterView = [[UIView alloc] init];  
}

#pragma mark tableHeaderView
- (void)customTableHeaderView
{
    NSArray *DetailTitleArray = @[@[@"新增里程"],@[@"用时",@"已行驶公里数"],@[@"已捐献"],@[@"本月行驶天数"],@[@"本月驾驶评分"],@[@""],@[@"已完成",@"总任务"],@[@"环保行驶",@"总行驶"]];
    
    if (self.titleNum == 20 || self.titleNum == 21) {
        if (self.titleNum == 20) {
            _vieww = [[NSBundle mainBundle] loadNibNamed:@"TemHeadVieww" owner:self options:0][0];
            self.tableView.tableHeaderView = _vieww;
        }else{
            _viewz = [[NSBundle mainBundle] loadNibNamed:@"TemHeadViewz" owner:self options:0][0];
            self.tableView.tableHeaderView = _viewz;
        }
    }else{
        NSArray *titleArray = DetailTitleArray[self.titleNum-1];
        if (self.titleNum == 2||self.titleNum == 8 || self.titleNum == 7) {
            
            _view = [[NSBundle mainBundle] loadNibNamed:@"TemHeadView" owner:self options:0][0];
            _view.mileageSumTitleLabel.text = titleArray[1];
            _view.itemValueTitleLabel.text = titleArray[0];
            _view.ctlTitleText = self.titleName;
            UIView *view = _view;
            if ([self.titleName isEqualToString:@"环保指数"]) {
                view.frame=CGRectMake(0, 0, ScreenWidth, 233);
            }
            _tableView. tableHeaderView =view;
        }else{
            _viewx = [[NSBundle mainBundle] loadNibNamed:@"TemHeadViewx" owner:self options:0][0];
            _viewx.itemValueTitleLabel.text = titleArray[0];
            _viewx.ctlTitleText = self.titleName;
            UIView *view = _viewx;
            if ([self.titleName isEqualToString:@"驾驶评分"]) {
                view.frame=CGRectMake(0, 0, ScreenWidth, 232);
            }
            _tableView. tableHeaderView =view;
            
        }
        
    }
}
#pragma mark 数据请求
- (void)getRankInfo
{
    if (self.titleNum == 20|| self.titleNum == 21) {//请求全部排名  本月排名
        NSString *url = self.titleNum == 20?@"getRankListInfoByShellAll":@"getRankListInfoByShell";
        [RequestEngine getRankListInfoByShellWithUrl:url complete:^(NSString *errorcode, NSArray *rankArray, NSDictionary *myRankInfoDic) {
            if ([errorcode isEqualToString:@"0"]) {
                [self customTableHeaderView];
                if (!rankArray.count) {
                    [self showNetWorkView];
                }
                _rankArray = rankArray;
                _myRankInfoDic = myRankInfoDic;
                [self refreshUI];
            }else{
                Alert(@"主人,请检查您的网络");
            }
            [self endRefresh];
        }];
    }else{
        [RequestEngine getUserRankInfoWithRankType:[NSString stringWithFormat:@"%ld",self.titleNum] complete:^(NSString *errorCode, NSString *rankRuleText, RankModel *model, NSMutableArray *dataArray) {
            if ([errorCode isEqualToString:@"0"]) {
                [self customTableHeaderView];
                if (!dataArray.count) {
                    [self showNetWorkView];
                }
                //请求数据成功
                _model = model;
                _rankArray = dataArray;
                _rankRuleText = rankRuleText;
                [self refreshUI];
            }
            [self endRefresh];
        }];
    }
    
}


#pragma mark 刷新UI
- (void)refreshUI
{
    if (self.titleNum == 20 || self.titleNum == 21) {
        if (self.titleNum == 20) {
            [_vieww fileDataWithData:_myRankInfoDic];
        }else{
            _viewz.precentLabel.text = [NSString stringWithFormat:@"%@",_myRankInfoDic[@"present"]==nil?@"0":_myRankInfoDic[@"present"]];
            _viewz.rochelleLabel.text = [NSString stringWithFormat:@"%@",_myRankInfoDic[@"rochelle"]==nil?@"0":_myRankInfoDic[@"rochelle"]];
            [_viewz.headImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
            _viewz.nickNameLabel.text = [PersonInfo sharePersonInfo].nicknameString;
            _viewz.gredeAndTitleLabel.text = [NSString stringWithFormat:@"LV%@ %@",[PersonInfo sharePersonInfo].grade==nil?@"0":[PersonInfo sharePersonInfo].grade,[PersonInfo sharePersonInfo].gradeTitle.length==0?@"微密新手":[PersonInfo sharePersonInfo].gradeTitle];
        }
    }else{
        if (self.titleNum == 2||self.titleNum == 7 || self.titleNum == 8) {
            [_view fileDataWithData:_model];
            _view.rankRuleText = _rankRuleText;
        }else{
            [_viewx fileDataWithData:_model];
            _viewx.rankRuleText = _rankRuleText;
        }
    }
    [self.tableView reloadData];
}

#pragma mark --刷新控件--
- (void)refreshData
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRefreshData)];//头部刷新
    [_tableView headerBeginRefreshing];
}

#pragma mark --下拉刷新--
- (void)headerRefreshData
{
    //[_tableView  headerEndRefreshing];
    [self getRankInfo];
}

#pragma mark --上拉加载--
- (void)footerRefresh
{
    [_tableView  footerEndRefreshing];
}

///头部尾部停止刷新
- (void)endRefresh
{
    [_tableView  headerEndRefreshing];
    [_tableView footerEndRefreshing];
}
#pragma mark --表的设置--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rankArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifer = @"Cells";
    RankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RankTableViewCell" owner:self options:nil]objectAtIndex:1];
        
    }
    if (![[NSString stringWithFormat:@"%@",[_rankArray[indexPath.row] fType]] isEqualToString:@"1"]) {//不是来自好友
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(257, 3, 55, 30);
        btn.tag = 10086+indexPath.row;
        [btn setTitleColor:[UIColor colorWithRed:249/255.0 green:136/255.0 blue:11/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"Group_6.png"] forState:UIControlStateNormal];
        [btn setTitle:@"加好友" forState:UIControlStateNormal];
        [cell addSubview:btn];
        [btn addTarget:self action:@selector(addFriendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.rankNum = indexPath.row;
    [cell fileDataWithDatay:_rankArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.titleNum == 20 || self.titleNum == 21) {
        [cell.starView removeFromSuperview];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark --跳转到添加好友--
- (void)addFriendClick:(UIButton *)btn
{
    RankModel *model = _rankArray[btn.tag-10086];
    NSString *isAllowedOpinion = [NSString stringWithFormat:@"%@",model.isAllowedOpinion==nil?@"1":model.isAllowedOpinion];//1 shi  0  fou
    if ([isAllowedOpinion isEqualToString:@"0"]) {//不允许添加好友
        Alert(@"主人,对方不允许添加好友哦");
    }else{
        NSString * nickName = model.nickName==nil?@"":model.nickName;
        NSString * accountId = model.accountID==nil?@"":model.accountID;
        NSString * gender = model.gender==nil?@"1":model.gender;
        NSString * area = model.userArea.length==0?@" ":model.userArea;
        //需要验证
        //NSLog(@"验证  %@",[NSString stringWithFormat:@"%@",model.isVerifyOpinion]);
        if([[NSString stringWithFormat:@"%@",model.isVerifyOpinion] isEqualToString:@"1"])
        {
            //NSLog(@"需要验证 。。。");
            TestViewController *tvc = [[TestViewController alloc]init];
            tvc.model = (NewChannelModel *)model;
            tvc.isFriend = YES;
            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:tvc];
            [self presentViewController:nav animated:YES completion:nil];
        }
        //不需要验证
        else if([[NSString stringWithFormat:@"%@",model.isVerifyOpinion] isEqualToString:@"0"]||model.isVerifyOpinion==nil)
        {
            //NSLog(@"不需要验证");
            NSDictionary *dict = @{@"msgContent":@"",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"friendAccountID":accountId,@"friendNickName":nickName,@"gender":gender,@"userArea":area};
            //[self refreshWithStatus:YES];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RequestEngine addFriends:dict completed:^(NSString *errorCode, NSString *result) {
                //[self refreshWithStatus:NO];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if([errorCode isEqualToString:@"0"])
                {
                    model.fType = @"1";//来自好友
                    
                    model.fromChannel = @"";
                    NSMutableArray *ary = [NSMutableArray arrayWithArray:_rankArray];
                    [ary replaceObjectAtIndex:btn.tag-10086 withObject:model];
                    _rankArray = ary;
                    [_tableView reloadData];
                    Alert(@"主人,你已经添加好友成功了哟");
                }
                else if([errorCode isEqualToString:@"ME01001"]){
                    Alert(result);
                }
                else{
                    Alert(@"主人,添加好友失败了");
                }
            }];
        }
    }
}
#pragma 没有数据时候显示
- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    _errorView.promptLabel.text = @"主人，您还没有频道好友和微密好友哟，快去关联一些热闹的群聊频道或者添加一些通讯录好友吧~";
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, (self.view.bounds.size.height+self.tableView.tableHeaderView.frame.size.height) * 0.5-64);
    
    [self.tableView addSubview:_errorView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end