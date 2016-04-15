//
//  WEMESettingViewController.m
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "WEMESettingViewController.h"
#import "WEMECustomTableViewCell.h"
#import "NewLoginViewController.h"
#import "ResetPasswordViewController.h"
#import "ModifictionViewController.h"
#import "AppDelegate.h"
#import "AboutWEMEController.h"
#import "FeedbackViewController.h"


@interface WEMESettingViewController ()

@end

@implementation WEMESettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
}
- (void)uiConfig
{
    //清除缓存
    self.title = @"我的设置";
    _cacheSetting = [[YJCache alloc]init];
    self.WEMESettingTableView.delegate = self;
    self.WEMESettingTableView.dataSource = self;
    _titleArray = @[@[@"清理缓存"],@[@"重置密码"],@[@"帮助与反馈",@"关于微密"],@[@"注销登录"]];
    _imageArray = @[@[@"weme_appfunctionset_clean"],@[@"shezhi"],@[@"wm_about_one_feedback",@"wm_one_about"],@[@""]];
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
    if(indexPath.section==0||indexPath.section==1||indexPath.section==2)
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
        if(indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                cell.accessoryType = UITableViewCellAccessoryNone; //不显示最右边的箭头
                //清除缓存
                cell.detailText.text = [NSString stringWithFormat:@"%.2f M",[_cacheSetting yjCacheSize]];
            }
        }
        return cell;
    }
    else
    {
        static NSString *str = @"WEMECustomTableViewCellDown";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *textLabel = [[UILabel alloc]initWithFrame:cell.frame];
        textLabel.text = [[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        textLabel.frame = CGRectMake(0, 0, ScreenWidth, 44);
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor redColor];
        [cell addSubview:textLabel];
        return cell;
    }
}
#pragma mark-选中tableView的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==2)
    {
        if(indexPath.row == 0)
        {
            //帮主与反馈
            FeedbackViewController *feedBackView = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedBackView animated:YES];
        }
        else if(indexPath.row == 1)
        {
            //关于微密
            self.tabBarController.tabBar.hidden = YES;
            AboutWEMEController *abount = [[AboutWEMEController alloc] init];
            [self.navigationController pushViewController:abount animated:YES];
        }
    }
    else if(indexPath.section==0)
    {
        //清除缓存
        NSString *chane = [NSString stringWithFormat:@"是否清除%.2fM缓存",[_cacheSetting yjCacheSize]];
        if ([chane isEqualToString:@"是否清除0.00M缓存"]) {
            Alert(@"主人,已经没有缓存可以清除了哦");
            return;
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:chane delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
    else if(indexPath.section==1)
    {
        //重置密码
        ModifictionViewController *rvc = [[ModifictionViewController alloc]init];
        [self.navigationController pushViewController:rvc animated:YES];
    }
    else if(indexPath.section==3)
    {
        //注销登录
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"主人,你确定要退出吗" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        [actionSheet showInView:self.view];
    }
}
#pragma mark - actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"isLogOut"];
        [defaults removeObjectForKey:kpassworldString];
        [defaults removeObjectForKey:@"imei"];
        [defaults removeObjectForKey:@"phone"];
        [defaults removeObjectForKey:@"gradeTitle"];
        [defaults removeObjectForKey:@"bind"];
        [defaults removeObjectForKey:@"nickname"];
        [defaults removeObjectForKey:@"accountID"];  
        [defaults removeObjectForKey:@"midian"];
        [defaults removeObjectForKey:@"name"];
        [defaults removeObjectForKey:@"wxUid"];
        [defaults removeObjectForKey:kWXUID];
        [defaults removeObjectForKey:kAppStation];
        [defaults removeObjectForKey:@"iconString"];
        [defaults removeObjectForKey:kArea];
        [defaults synchronize];
        //微信注销登录
//        if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat]) {
//            [ShareSDK cancelAuthorize:SSDKPlatformSubTypeWechatSession];
//        }
        
        
        AppDelegate * delegates = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegates congieurePushAction:nil];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
        [[PersonInfo sharePersonInfo] resetPersonInfo];
        NewLoginViewController *newLog = [[NewLoginViewController alloc] init];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:newLog];
        [self presentViewController:navigation animated:YES completion:nil];
    }
}
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if (_modelView == nil)
        {
            _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
        }
        [self.view addSubview:_modelView];
        
        [_cacheSetting yjRemoveCache:^{
            [_modelView removeFromSuperview];
            [self.WEMESettingTableView reloadData];
        }];
    }
    else
    {
        return;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
