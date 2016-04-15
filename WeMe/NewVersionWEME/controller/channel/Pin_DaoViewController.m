//
//  Pin_DaoViewController.m
//  微密
//
//  Created by wemedev on 15/3/25.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "Pin_DaoViewController.h"
#import "PindaoTableViewCell.h"
#import "ChannelViewController.h"
#import "SerViceViewController.h"
#import "CreateChannelViewController.h"
#import "MobClick.h"
#import "Pin_Dao_SetViewController.h"
#import "MyChannelViewController.h"
#import "ScanQRViewController.h"
#import "WEMECustomTableViewCell.h"
#import "HomePageChannelViewController.h"

@implementation Pin_DaoViewController
{
    NSArray * _myChannelTitle;
    NSArray * _iconArr;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [MobClick beginLogPageView:self.title];//页面时长统计
//    NewRootViewController *rvc = [[NewRootViewController alloc]init];
//    [rvc GetEditionOfApp];//版本更新
}
- (void)viewWillDisappear:(BOOL)animated  
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uiConfig];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitle:@"扫一扫" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendActionButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
}
#pragma mark - 扫二维码
- (void) sendActionButton
{
    ScanQRViewController *scanVC = [[ScanQRViewController alloc]init];
    scanVC.isErWeiMa = YES;
    UINavigationController *scanNav = [[UINavigationController alloc]initWithRootViewController:scanVC];
    [self presentViewController:scanNav animated:YES completion:nil];
    
//    HomePageChannelViewController *cvc = [[HomePageChannelViewController alloc]init];
//    [self.navigationController pushViewController:cvc animated:YES];
}
#pragma mark - 设置UI界面
- (void)uiConfig
{
    self.title = @"频道";
    self.chang_view.frame = CGRectMake(0, -15, ScreenWidth, ScreenHeight+15);
    self.chang_view.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    self.chang_view.delegate = self;
    self.chang_view.dataSource = self;
    _anchorTitleArr = @[@[@"Top"],@[@"创建群聊频道",@"微密终端配置"],@[@"我创建的群聊频道",@"我加入的群聊频道",@"我关注的主播频道"],@[@"微密好友",@"好友设置"]];
    _myChannelTitle = @[@"我创建的群聊频道",@"我加入的群聊频道",@"我关注的主播频道"];
    _iconArr = @[@[@"channel11",@"channel22"],@[@"channel33",@"channel44",@"channel55"],@[@"channel66",@"channel_my_set"]];
}

#pragma mark-设置分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_anchorTitleArr count];
}
#pragma mark-设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [_anchorTitleArr objectAtIndex:section];
    return array.count;
}
#pragma mark-设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 100;
    }
    else
    {
        return 45;
    }
}
#pragma mark-设置tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *str = @"PindaoCell";
        PindaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PindaoTableViewCell" owner:self options:nil]lastObject];
            cell.delegate = self;
        }
        return cell;
    }
    else
    {
        static NSString *cellID = @"cellID";
        WEMECustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
           cell = [[[NSBundle mainBundle] loadNibNamed:@"WEMECustomTableViewCell" owner:self options:nil] firstObject];
        }
        cell.textLableContent.text = [[_anchorTitleArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLableContent.font = kLevelTwoFont;
        cell.textLableContent.textColor = kLevelTwoColor;
        cell.headImageView.image = [UIImage imageNamed:[[_iconArr objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row]];
        return cell;
    }
}
#pragma mark-tableView选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController * vc = nil;
    switch (indexPath.section)
    {
        case 1:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    //创建频道
                    CreateChannelViewController * vc = [[CreateChannelViewController alloc]init];
                    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                    break;
                case 1:
                    //微密终端配置
                    vc = [[Pin_Dao_SetViewController alloc]init];
                default:
                    break;
            }
        }
    }
    //微密好友
    if (indexPath.section == 3)
    {
        
//        if(indexPath.row == 0){//微密好友
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"WeMeFriendsViewController" bundle:nil];
//            WeMeFriendsViewController *weme = [story instantiateInitialViewController];
//            [self.navigationController pushViewController:weme animated:YES];
//        }
//        if (indexPath.row == 1) {//好友设置
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"FriendsSetUpViewController" bundle:nil];
//            FriendsSetUpViewController *friend = [story instantiateInitialViewController];
//            [self.navigationController pushViewController:friend animated:YES];
//        }
    }
    [self.navigationController pushViewController:vc animated:YES];
    if (indexPath.section == 2)
    {
        //我创建的 我加入的 我关注的
        MyChannelViewController * myChannelView = [[MyChannelViewController alloc]init];
        myChannelView.firstRefresh = YES;
        //myChannelView.titleName = [_myChannelTitle objectAtIndex:indexPath.row];
        //myChannelView.requestType = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [self.navigationController pushViewController:myChannelView animated:YES];
    }
}
#pragma mark- Cell 代理事件
- (void)pindaoButton:(NSString *)buttonTag
{
    if([buttonTag isEqualToString:@"100"])
    {
        //群聊频道
        ChannelViewController *cvc = [[ChannelViewController alloc]init];
        cvc.titleStr = @"群聊频道";
        cvc.firstRefresh = YES;
        [self.navigationController pushViewController:cvc animated:YES];
    }
    else if([buttonTag isEqualToString:@"101"])
    {
        //主播频道
        ChannelViewController *cvc = [[ChannelViewController alloc]init];
        cvc.titleStr = @"主播频道";
        cvc.firstRefresh = YES;
        [self.navigationController pushViewController:cvc animated:YES];
    }
    else if([buttonTag isEqualToString:@"102"])
    {
        //服务频道
        SerViceViewController *svc = [[SerViceViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end