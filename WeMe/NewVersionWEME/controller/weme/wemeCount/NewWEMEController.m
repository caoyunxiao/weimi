//
//  NewWEMEController.m
//  微密
//
//  Created by wemeDev on 15/3/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewWEMEController.h"
#import "PersonInfoCell.h"
#import "MyViewController.h"
#import "PersonInfo.h"
#import "ContractViewController.h"
#import "PathTableViewController.h"
#import "PushMessageViewController.h"
#import "DetailInfoViewController.h"
#import "NewRootViewController.h"
#import "MobClick.h"
#import "YJCache.h"
#import "ModelView.h"
#import "MessageCenterViewController.h"
#import "WEMECustomTableViewCell.h"
#import "WEMESettingViewController.h"
#import "MyAccountyViewController.h"
#import "MyLocationViewController.h"
#import "WeMeFriendsViewController.h"
#import "WEMEMyChannelViewController.h"
#import "FunctionSettingViewController.h"

@interface NewWEMEController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSArray * _dataArr;            //数据源数组
    ModelView *_modelView;         //加载视图
    NSMutableArray *_pushArray;    //推送数组
    NSString *_clearString;        //消息个数
}

@end

@implementation NewWEMEController

#pragma mark -初始化
- (id) init
{
    self = [super init];
    if (self)
    {
        //接收推送消息
        [self _receivePushMessage];
        _pushArray = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - 接收推送消息
- (void) _receivePushMessage
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messagePush:) name:PushMassageObserver object:nil];
}
#pragma mark - 获取推送数据
- (void) messagePush:(NSNotification *)notification
{
    if (notification.userInfo==nil) {
        return;
    }
    [_pushArray addObject:notification.userInfo];
    //保存推送的内容到本地
    [[NSUserDefaults standardUserDefaults] setObject:_pushArray forKey:getPushMessageArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 试图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:self.title];
    _isFirstPush = 1;
    
    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBackViewClear" object:nil userInfo:nil];
    [super viewWillAppear:animated];
    //调用未读消息多少条
    [self _selectMessageCount];
//    NewRootViewController *rvc = [[NewRootViewController alloc]init];
//    [rvc GetEditionOfApp];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self getIMEIAndPhone];//获取电话和IMEI号
    [MobClick endLogPageView:self.title];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getIMEIAndPhone];//获取电话和IMEI号
    [self uiConfig];
    [self prepareData];
    
    //清空提示消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMsg) name:clearMessageCenterNotifigation object:nil];
    //刷新界面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshView" object:nil];
    //通知刷新头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGetUserImage) name:@"refreshGetUserImage" object:nil];
}


#pragma mark - 通知刷新界面
- (void)refreshView:(NSNotification *)notifi
{
    //[self refrshShowData];
    [self.tableView reloadData];
}

#pragma mark -- 重新刷新头像
- (void)refreshGetUserImage
{
    [self.tableView reloadData];
}
#pragma mark - 数据配置
- (void)uiConfig
{
    self.title = @"我";
//    _dataArr = @[@[@"我的信息"],@[@"消息中心",@"道客钱包"],@[@"我的设备",@"我的轨迹",@"我的位置",@"安驾提醒"],@[@"微密好友"],@[@"我的设置"]];
    _dataArr = @[@[@"我的信息"],@[@"消息中心",@"道客钱包"],@[@"我的设备",@"我的位置",@"安驾提醒"],@[@"微密好友"],@[@"我的设置"]];
//    _iconArr = @[@[@"wm_one_message",@"home_com_mall_select_click"],@[@"weme_appfunctionset",@"wm_one_traveling_track",@"myLocation",@"safetyDrivingRemindImage"],@[@"channel66"],@[@"channel_my_set"]];
    _iconArr = @[@[@"wm_one_message",@"home_com_mall_select_click"],@[@"weme_appfunctionset",@"myLocation",@"safetyDrivingRemindImage"],@[@"channel66"],@[@"channel_my_set"]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonInfoCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCellTwo" bundle:nil] forCellReuseIdentifier:@"infoCellTwo"];
    
    //UITableView
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}


#pragma mark - 准备数据
- (void)prepareData
{
    [RequestEngine getUserInfo:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"0"])
        {
            //获取用户信息成功
        }
        else
        {
            //获取用户信息失败
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = ((NSArray*)[_dataArr objectAtIndex:section]).count ;
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identif = @"CustomCell";
    if (indexPath.section == 0)
    {
        UITableViewCell * cell = nil;
        
        if (indexPath.row == 0)
        {
            cell = (PersonInfoCell*)[tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
            [self updateCellWith:((PersonInfoCell*)cell) andTag:1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        return cell;
    }
    WEMECustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WEMECustomTableViewCell" owner:self options:nil] firstObject];
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [RequestEngine selectMessageCount:@{@"accountID":[PersonInfo sharePersonInfo].accountIDString} completed:^(NSString *errorCode, NSDictionary *resultDic) {
                NSString *result = [resultDic[@"newsmsLimitCount"] stringValue];
                if ([result isEqualToString:@""] || result == nil)
                {
                    cell.pageValue.text = @"";
                }
                else
                {
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[result integerValue]];
                    if (_clearString == nil)
                    {
                        if ([result isEqualToString:@"0"])
                        {
                            cell.pageValue.text = @"";
                        }
                        else
                        {
                            cell.pageValue.text = result;
                        }
                    }
                    else
                    {
                        cell.pageValue.text = _clearString;
                    }
                }
            }];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.textLableContent.text = [[_dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLableContent.font = kLevelTwoFont;
    cell.textLableContent.textColor = kLevelTwoColor;
    cell.headImageView.image = [UIImage imageNamed:[[_iconArr objectAtIndex:indexPath.section -1] objectAtIndex:indexPath.row]];
    //[self setImageViewFrame:cell cellForRowAtIndexPath:indexPath];//设置图大小
    return cell;
}

//- (void)setImageViewFrame:(WEMECustomTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGRect oldFram = cell.headImageView.frame;
//    if(indexPath.section == 1)
//    {
//        if(indexPath.row == 1)
//        {
//            oldFram.size.width = 20;
//            oldFram.size.height = 20;
//        }
//    }
//    cell.headImageView.frame = oldFram;
//}

#pragma mark - 清理消息
- (void) clearMsg{
    
    _clearString = @"";
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 70;
        }
        else
        {
            return 44;
        }
    }
    else
        return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        //个人信息
        DetailInfoViewController * detail = [[DetailInfoViewController alloc] init];
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)//消息中心
        {
            self.tabBarController.tabBar.hidden = YES;
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"MessageCenterViewController" bundle:nil];
            MessageCenterViewController *messageVc = [story instantiateInitialViewController];
            [self.navigationController pushViewController:messageVc animated:YES];
            
        }else if (indexPath.row == 1)
        {
            //道客钱包
            MyAccountyViewController * vc = [[MyAccountyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
//        else if (indexPath.row == 2)
//        {
//            //轨迹页面
//            PathTableViewController * path = [[PathTableViewController alloc] init];
//            [self.navigationController pushViewController:path animated:YES];
//        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            if ([self userImeiIsBind])
            {
                //我的设备
                ContractViewController *contract = [[ContractViewController alloc] init];
                [self.navigationController pushViewController:contract animated:NO];
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"主人,你当前没有绑定IMEI,不能查看和访问相关数据,快去绑定吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
                alert.tag = 11;
                [alert show];
            }
        }
        else if (indexPath.row == 1111)
        {
//            if ([self userImeiIsBind])
//            {
            
//                self.tabBarController.tabBar.hidden = YES;
//                //轨迹页面
//                PathTableViewController * path = [[PathTableViewController alloc] init];
//                [self.navigationController pushViewController:path animated:YES];
            
//            }
//            else
//            {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"主人,你当前没有绑定IMEI,不能查看和访问相关数据,快去绑定吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
//                alert.tag = 11;
//                [alert show];
//            }
        }else if (indexPath.row == 1)
        {
            //我的位置页面
            if ([self userImeiIsBind])
            {
                MyLocationViewController *locationVC = [[MyLocationViewController alloc] init];
                [self.navigationController pushViewController:locationVC animated:YES];
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"主人,你当前没有绑定IMEI,不能查看和访问相关数据,快去绑定吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
                alert.tag = 11;
                [alert show];
            }
        }
        else if (indexPath.row==2)
        {
            //安驾提醒
            FunctionSettingViewController *function = [[FunctionSettingViewController alloc]init];
            [self.navigationController pushViewController:function animated:YES];
        }
    }
    else if (indexPath.section == 3)
    {
        //微密好友
        if(indexPath.row == 0)
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"WeMeFriendsViewController" bundle:nil];
            WeMeFriendsViewController *weme = [story instantiateInitialViewController];
            [self.navigationController pushViewController:weme animated:YES];
        }
    }
    else if (indexPath.section == 4)
    {
        if(indexPath.row == 0)
        {
            //我的设置
            WEMESettingViewController *set = [[WEMESettingViewController alloc]init];
            [self.navigationController pushViewController:set animated:YES];
        }
    }
    
}
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11)
    {
        if (buttonIndex == 1)
        {
            //跳到绑定IMEI的控制器...
            self.tabBarController.tabBar.hidden = YES;
            MyViewController *me = [[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
            [self.navigationController pushViewController:me animated:YES];
        }
    }
}
#pragma mark - 获取手机号和IMEI号
- (void)getIMEIAndPhone
{
    [RequestEngine getIMEIAndPhone:^(NSString *imeiStr, NSString *phoneStr, NSString *errorCode) {
        if([errorCode isEqualToString:@"0"])
        {
            _imeiString = [NSString stringWithFormat:@"%@",imeiStr];
            _phoneString = [NSString stringWithFormat:@"%@",phoneStr];
        }
        else
        {
            _imeiString = @"";
            _phoneString = @"";
        }
        
    }];
}

#pragma mark -- 判断IMEI 是否绑定
- (BOOL)userImeiIsBind
{
    _imeiString=[UserDefaults objectForKey:@"imeiString"];
    NSLog(@"_imeiString_imeiString_imeiString_imeiString:%@",_imeiString);
    if(_imeiString.length>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -- 第一个cell修改
- (void)updateCellWith:(id)cell andTag:(int)tag
{
    if (tag ==1)
    {
        ((PersonInfoCell*)cell).lineView.bounds = CGRectMake(0, 0, ScreenWidth, 0.5);
        ((PersonInfoCell*)cell).personIcon.layer.cornerRadius = 5;
        ((PersonInfoCell*)cell).ranBackImage.layer.cornerRadius = 5;
        ((PersonInfoCell*)cell).ranBackImage.clipsToBounds = YES;
        ((PersonInfoCell*)cell).personIcon.layer.masksToBounds = YES;
        [((PersonInfoCell*)cell).personIcon sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
        ((PersonInfoCell*)cell).personName.text = [PersonInfo sharePersonInfo].nicknameString;
        NSString *phoneString = [PersonInfo sharePersonInfo].phoneString;
        if([phoneString isEqualToString:@"0"]||phoneString==nil)
        {
            phoneString = @"";
        }
        ((PersonInfoCell*)cell).personPhone.text = phoneString;
        ((PersonInfoCell*)cell).rankLabel.text = [NSString stringWithFormat:@"LV%@%@",[PersonInfo sharePersonInfo].grade == nil?@"0":[PersonInfo sharePersonInfo].grade,[PersonInfo sharePersonInfo].gradeTitle.length==0?@"驾校学员":[PersonInfo sharePersonInfo].gradeTitle];
    }
    else
    {
        //
    }
   
}
#pragma mark - 密点手势事件
-(void)btnLongleft:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@"left" forKey:@"userInfoStr"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBackView" object:nil userInfo:dict];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBackViewClear" object:nil userInfo:nil];
        //跳转到道客账户页面
        if(_isFirstPush==1)
        {
//            AccountViewController *account = [[AccountViewController alloc]init];
//            [self.navigationController pushViewController:account animated:YES];
        }
        _isFirstPush ++;
    }
}

#pragma mark - 消息手势事件
-(void)btnLongright:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObject:@"right" forKey:@"userInfoStr"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBackView" object:nil userInfo:dict];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBackViewClear" object:nil userInfo:nil];
        //跳转到推送消息页面
        if(_isFirstPush==1)
        {
            PushMessageViewController * push = [[PushMessageViewController alloc] init];
            [self.navigationController pushViewController:push animated:YES];
        }
        _isFirstPush ++;
    }
}

#pragma mark - 获取沙河中的头像图片
- (UIImage *)getIconImageInDocuments:(NSString *)iconName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@.png",[paths objectAtIndex:0],iconName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 查询未读消息
- (void) _selectMessageCount
{
    [self.tableView reloadData];
}



@end
