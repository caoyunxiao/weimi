//
//  SettingWEMEViewController.m
//  微密
//
//  Created by MacMini on 15/3/11.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "SettingWEMEViewController.h"
#import "ChangeWEMEController.h"
#import "YJCache.h"
#import <ShareSDK/ShareSDK.h>
#import "NewRootViewController.h"
#import "ExitView.h"
#import "NewLoginViewController.h"
#import "AboutWEMEController.h"
#import "ModifictionViewController.h"
#import "SerViceViewController.h"
#import "MobClick.h"
@interface SettingWEMEViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,ExitViewDelegate>
- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *existButton;

@end

@implementation SettingWEMEViewController
{
    UITableView* _tableView;
    NSArray* array;
    ModelView *_modelView;
    YJCache  *_cacheSetting;
    NSString* detail;
    NSArray * _picArr;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"设置首页"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick endLogPageView:@"设置首页"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [_existButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"] forState:UIControlStateHighlighted];
    _cacheSetting = [[YJCache alloc]init];
    array = @[@"修改道客密码",@"清理缓存",@"关于微密"];
    _picArr = @[@"needite",@"clear",@"guanyu"];
    self.navigationItem.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrows"] style:UIBarButtonItemStylePlain target:self action:@selector(goBacks)];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, 220) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=  self;
    [self.view addSubview:_tableView];
    _tableView.scrollEnabled = NO;
        // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [array count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString* identifier=@"Cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil)
     {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text=array[indexPath.section];
    cell.textLabel.font = kLevelTwoFont;
    cell.textLabel.textColor = kLevelTwoColor;
    cell.imageView.image=[UIImage imageNamed:_picArr[indexPath.section]];
    if (indexPath.section==1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M",[_cacheSetting yjCacheSize]];
        cell.detailTextLabel.font = kLevelThreeFont;
        cell.detailTextLabel.textColor = kLevelThreeColor;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)goBacks
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController * vc = nil;
    switch (indexPath.section)
    {
        case 0:
            vc = [[ModifictionViewController alloc]init];
            break;
        case 1:
        {
            if ([_cacheSetting yjCacheSize] == 0.00)
            {
                Alert(@"还没有缓存哟!");
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"清除将导致,有些数据重新加载!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 1000;
                [alertView show];
            }
        }
            break;
        case 2:
            vc = [[AboutWEMEController alloc]init];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000)
    {
        if (buttonIndex == 1)
        {
            if (_modelView == nil)
            {
                _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
            }
            [self.view addSubview:_modelView];
            
            [_cacheSetting yjRemoveCache:^{
                
                [_modelView removeFromSuperview];
                
                [_tableView reloadData];
            }];
        }
    }
    
}
- (IBAction)cancelAction:(id)sender {
    [self exitLogin];
}
- (void)exitLogin
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"你确定要退出吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:kNameString];
        [defaults setObject:nil forKey:kpassworldString];
        [defaults setObject:nil forKey:kWXUID];
        [defaults synchronize];
        
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
        
        [[PersonInfo sharePersonInfo] resetPersonInfo];
        [self.navigationController popViewControllerAnimated:YES];
        [[NewRootViewController
          shareRootViewController] popToRootView];
        [[DataBase sharedDataBase]deletePeople];//删除表中的信息
    }
}
@end