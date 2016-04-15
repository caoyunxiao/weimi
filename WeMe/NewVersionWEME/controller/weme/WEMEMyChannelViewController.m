//
//  WEMEMyChannelViewController.m
//  微密
//
//  Created by ZFJ on 15/8/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "WEMEMyChannelViewController.h"
#import "WEMECustomTableViewCell.h"
#import "MyChannelViewController.h"
#import "CreateChannelViewController.h"

@interface WEMEMyChannelViewController ()

@end

@implementation WEMEMyChannelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uiConfig];
}

#pragma mark - 数据配置
- (void)uiConfig
{
    self.title = @"我的频道";
    if (iOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;          //视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;            //不透明的操作栏
    }
    self.WEMEMyChannelTableView.dataSource = self;
    self.WEMEMyChannelTableView.delegate = self;
    _titleArray = @[@[@"我创建的群聊频道",@"我加入的群聊频道",@"我关注的主播频道"]];
    _imageArray = @[@[@"channel33",@"channel44",@"channel55"]];

//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"channel11New"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(createActionButton) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = buttonItem;
}

#pragma mark - 创建频道
- (void)createActionButton
{
    //创建频道
    CreateChannelViewController * vc = [[CreateChannelViewController alloc]init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark- 创建每个tableview的分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = ((NSArray*)[_titleArray objectAtIndex:section]).count ;
    
    return count;
}
#pragma mark-创建tableView的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark-创建tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"WEMECustomTableViewCell";
    WEMECustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WEMECustomTableViewCell" owner:self options:nil] firstObject];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.textLableContent.text = [[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLableContent.font = kLevelTwoFont;
    cell.textLableContent.textColor = kLevelTwoColor;
    cell.headImageView.image = [UIImage imageNamed:[[_imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    return cell;
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

#pragma mark-选中tableView的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        //我创建的 我加入的 我关注的
        MyChannelViewController * myChannelView = [[MyChannelViewController alloc]init];
        myChannelView.firstRefresh = YES;
        //myChannelView.titleName = [[_titleArray objectAtIndex:0] objectAtIndex:indexPath.row];
        //myChannelView.requestType = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [self.navigationController pushViewController:myChannelView animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:self.title];
    //self.panoramaView.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
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
