//
//  NewRootViewController.m
//  微密
//
//  Created by wemeDev on 15/3/4.
//  Copyright (c) 2015年 longlz. All rights reserved.


#import "NewRootViewController.h"
#import "NewMoreViewController.h"
#import "NewWEMEController.h"
#import "RequestEngine.h"
#import "Bang_danViewController.h"
#import "Pin_DaoViewController.h"
#import "NSFileManager+PathSize.h"
#import "MessageCenterViewController.h"
#import "MyViewController.h"
#import "SetUserInfoViewController.h"
#import "HomePageChannelViewController.h"
#import "LoginModel.h"
#import "NSString+MD5Addition.h"
#import "CustNavController.h"
#import "Tool.h"

@interface NewRootViewController ()<UIAlertViewDelegate>
{
    NewMoreViewController *_moreVC;
    
    NewWEMEController * _wemeVC;
    Pin_DaoViewController*_pindaoVC;
    Bang_danViewController*_bangdanVC;
    HomePageChannelViewController *_HomePageVC;
    UITabBarController *_tabBarController;
}

@end

@implementation NewRootViewController



static NewRootViewController * g_NewRootViewController = nil;

+(id)shareRootViewController
{
    if (g_NewRootViewController==nil) {
        g_NewRootViewController=[NewRootViewController alloc];
    }
    return g_NewRootViewController;
}

- (id)init
{
    self = [super init];
    if (self) {
        g_NewRootViewController = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getAdvertisementViewImageWithDic];//获取启动页大的广告图
    _addressBookTemp = [[NSMutableArray alloc]init];
    _personArray = [[NSMutableArray alloc]init];
    [self setTabBar];//设置TabBar
    [self delectChatStrTable];//删除缓存的临时数据 --- 存在数据库中
    
}

#pragma mark - 获取启动页大的广告图
- (void)getAdvertisementViewImageWithDic
{
    MoreModely *adCountDownModels = [LoginModel getAdvertisementViewImageWithDic];
    [PersonInfo sharePersonInfo].adCountDownModels = adCountDownModels;
    
    
    NSString *filename = [adCountDownModels.picUrl stringFromMD5];
    NSString *fullPath = [self filePath:filename];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:adCountDownModels.picUrl]];
    //存到本地
    [data writeToFile:fullPath atomically:YES];
}

#pragma mark - 把图片存在本地
- (NSString *)filePath:(NSString *)fileName
{
    NSString *homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents/DataCache"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:homePath])
    {
        [fm createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(fileName && fileName.length !=0)
    {
        homePath = [homePath stringByAppendingPathComponent:fileName];
    }
    return homePath;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:YES];
//    self.navigationController.navigationBar.frame=CGRectMake(0, 0, ScreenWidth, 35);
}

#pragma mark -- 设置TabBar
- (void)setTabBar
{
    _wemeVC = [[NewWEMEController alloc] init];
    //_pindaoVC=[[Pin_DaoViewController alloc]init];//频道
    _bangdanVC = [[Bang_danViewController alloc]init];//榜单
    _moreVC = [[NewMoreViewController alloc] init];//更多
    _HomePageVC = [[HomePageChannelViewController alloc]init];//频道 最新
    
     //UINavigationController*pindaoNav=[[UINavigationController alloc]initWithRootViewController:_pindaoVC];
//    UINavigationController *wemeNav = [[UINavigationController alloc] initWithRootViewController: _wemeVC];
//    UINavigationController *moreNav = [[UINavigationController alloc] initWithRootViewController: _moreVC];
//    UINavigationController *bangdanNav=[[UINavigationController alloc]initWithRootViewController:_bangdanVC];
//    UINavigationController *HomePageNav=[[UINavigationController alloc]initWithRootViewController:_HomePageVC];
    
        CustNavController *wemeNav = [[CustNavController alloc] initWithRootViewController: _wemeVC];
        CustNavController *moreNav = [[CustNavController alloc] initWithRootViewController: _moreVC];
        CustNavController *bangdanNav=[[CustNavController alloc]initWithRootViewController:_bangdanVC];
        CustNavController *HomePageNav=[[CustNavController alloc]initWithRootViewController:_HomePageVC];
    
    NSArray *vcArr = @[bangdanNav,HomePageNav,wemeNav,moreNav];
    NSArray *titleArr = @[@"榜单",@"频道",@"我",@"更多"];
    NSArray *imageArr = @[@"tabBar_one",@"tabBar_two",@"tabBar_three",@"tabBar_four"];
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = vcArr;
    
    // 改变tabBarController高度
    _tabBarController.tabBar.frame = CGRectMake(0, ScreenHeight-48, ScreenWidth, 48);
    
    #pragma mark - 修改的它的显示方式
    for (int i =0; i<titleArr.count; i++)
    {
        UIViewController * vc = (UIViewController *)[vcArr objectAtIndex:i];
        vc.title =[titleArr objectAtIndex:i];
        
        vc.tabBarItem.image = [UIImage imageNamed:imageArr[i]];
    }
    _tabBarController.tabBar.hidden=YES;
    [self.view addSubview:_tabBarController.view];
}

- (void)popToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 删除所有标签表
- (void)delectChatStrTable
{
    NSArray *arrayTable = @[@"AnchorChannel",@"AnchorChannelMore",@"GroupChatChannel",@"GroupChatChannelMore",@"MoreTable",@"moneyModelyTable"];
    DBOperation *db = [[DBOperation alloc]init];
    for (NSString *strName in arrayTable)
    {
        BOOL ret = [db createMarksTable:strName];
        if(ret)
        {
            BOOL retw = [db delectChatStrTable:strName];
            if(retw)
            {
                //NSLog(@"删除成功");
            }
        }
    }
}

#pragma mark - 获取版本信息
- (void)GetEditionOfApp
{
    [Request1617 queryUpToDateVersionCompleted:^(NSString *errorCode, NSDictionary *resultDict) {
        if([errorCode isEqualToString:@"0"])
        {
//            NSLog(@"resultDict==========namn %@",resultDict);
            if(resultDict!=nil)
            {
//                NSLog(@"isForceUpdate===========%@",resultDict[@"isForceUpdate"]);
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                [ud setObject:[resultDict objectForKey:@"isForceUpdate"] forKey:@"isForceUpdate"];
                [ud setObject:[resultDict objectForKey:@"number"] forKey:@"number"];
                [ud setObject:[resultDict objectForKey:@"iosUpdateUrl"] forKey:@"iosUpdateUrl"];
                //[self CheckEditionOfApp:resultDict];
            }
            else
            {
                //NSLog(@"获取版本信息失败!");  
            }
        }
    }];
}
#pragma mark - 让用户更新
- (void)CheckEditionOfApp:(NSDictionary *)dict
{
    NSString *version = [dict objectForKey:@"number"];
    NSString *updateUrl = [dict objectForKey:@"iosUpdateUrl"];
    _updateUrl = updateUrl;
    if(![version isEqualToString:@"2.0.0"])
    {
        BOOL isForceUpdate = [[dict objectForKey:@"isForceUpdate"] integerValue];
        NSString *titleStr = [NSString stringWithFormat:@"发现新版本%@",version];
        [self showAlertView:@"主人,新版本体验更好哦,快去更新吧" title:titleStr isForceUpdate:isForceUpdate myAppID:_updateUrl];
    }
}

#pragma mark -警告信息
- (void)showAlertView:(NSString *)massage title:(NSString *)title isForceUpdate:(BOOL)isForceUpdate myAppID:(NSString *)myAppID
{
    UIAlertView *alertView = nil;
    if(isForceUpdate)
    {
        alertView = [[UIAlertView alloc]initWithTitle:title message:massage delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即去更新", nil];
    }
    else
    {
        alertView = [[UIAlertView alloc]initWithTitle:title message:massage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"立即去更新", nil];
    }
    [alertView show];
}
#pragma mark - alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    //去更新
//    if (alertView==self.alertForNew&&buttonIndex==1) {
//        NSString *updateUrl=[UserDefaults objectForKey:appstoreUpdateUrlKey];
//        if (updateUrl.length>0) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
//        }else{
//            [MBProgressHUD showError:@"主人跳转到更新页面出错啦!"];
//        }
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self GetEditionOfApp];
    
    self.navigationController.navigationBarHidden = YES;
}


@end
