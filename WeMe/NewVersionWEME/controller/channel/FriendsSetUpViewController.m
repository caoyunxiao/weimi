//
//  FriendsSetUpViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FriendsSetUpViewController.h"
#import "RequestEngine.h"
#import "MobClick.h"
@interface FriendsSetUpViewController ()
{
    NSString * _canAddFriend;//允许添加好友
    NSString * _needCertify;//需要验证
}
@end

@implementation FriendsSetUpViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
    //[self setState];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryFriendSettingcompleted];
    //读取设置信息
    //[self getSWitchStatus];
    self.title = @"好友设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
}

- (void)queryFriendSettingcompleted
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine queryFriendSettingcompleted:^(NSString *errorCode, NSDictionary *resultDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([errorCode isEqualToString:@"0"])
        {
            _accountID = [resultDic objectForKey:@"accountID"];
            _isAllowedOpinion = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"isAllowedOpinion"]];
            _isReceiveNotifyOpinion = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"isReceiveNotifyOpinion"]];
            _isVerifyOpinion = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"isVerifyOpinion"]];
            if([_isAllowedOpinion isEqualToString:@"1"])
            {
                self.switchAddFriend.on = YES;
                _canAddFriend = @"1";
            }
            else
            {
                self.switchAddFriend.on = NO;
                _canAddFriend = @"0";
            }
            if([_isVerifyOpinion isEqualToString:@"1"])
            {
                self.switchNeedFriend.on = YES;
                _needCertify = @"1";
            }
            else
            {
                self.switchNeedFriend.on = NO;
                _needCertify = @"0";
            }
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
        
    }];
}
//
//#pragma mark --得到初始开关状态--
//- (void)getSWitchStatus
//{
//    _canAddFriend = [[NSUserDefaults standardUserDefaults]valueForKey:KNeedFriend]?[[NSUserDefaults standardUserDefaults]valueForKey:KNeedFriend]:@"1";
//    _needCertify = [[NSUserDefaults standardUserDefaults]valueForKey:KNeedCertify]?[[NSUserDefaults standardUserDefaults]valueForKey:KNeedCertify]:@"1";
//    self.switchAddFriend.on = [_canAddFriend integerValue];
//    self.switchNeedFriend.on = [_needCertify integerValue];
//}
#pragma mark --开关事件--
- (IBAction)switchValueChanged:(UISwitch *)sender
{
    if (sender.tag == 10)
    {
        _canAddFriend = [NSString stringWithFormat:@"%d",sender.on];
    }
    else
    {
        _needCertify = [NSString stringWithFormat:@"%d",sender.on];
    }
}
#pragma mark --保存按钮 保存数据--
- (void)saveClick
{
    NSDictionary * dic = @{ @"accountID":[PersonInfo sharePersonInfo].accountIDString,@"isAllowedOpinion":_canAddFriend,@"isVerifyOpinion":_needCertify,@"isReceiveNotifyOpinion":@""};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine friendsSetting:dic completed:^(NSString *errorCode) {
        if ([errorCode isEqualToString:@"0"])
        {
//            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setValue:_canAddFriend forKey:KNeedFriend];
//            [defaults setValue:_needCertify forKey:KNeedCertify];
//            [defaults synchronize];
            Alert(@"主人,保存成功了哦");
        }
        else
        {
            Alert(@"主人,保存失败了,请稍后再试吧");
        }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
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















@end
