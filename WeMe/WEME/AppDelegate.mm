//
//  AppDelegate.m
//  微密
//
//  Created by longlz on 14-7-14.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginModel.h"
#import "APService.h"
#import "HKDeviceID.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "iLink.h"
#import "NewRootViewController.h"
#import "NewLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HeaderModel.h"
#import "DataNetwork.h"
#import "MessageCenterViewController.h"
#import "ChatFamilyViewController.h"
#import "BindingViewController.h"
#import "SetUserInfoViewController.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>
#import <Bugly/CrashReporter.h>

@interface AppDelegate()<WXApiDelegate>

@end
@implementation AppDelegate


void uncaughtExceptionHandler(NSException *exception)
{
    ////NSLog(@"CRASH: %@", exception);
    ////NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

#pragma mark - 友盟提示更新
+ (void)initialize
{
//    [iLink sharedInstance].applicationBundleID = @"com.daoke.wemei"; //
//    [iLink sharedInstance].onlyPromptIfLatestVersion = NO;           //
//    [iLink sharedInstance].cancelButtonLabel=@"";             // 更新按钮 位@""时不显示
//    [iLink sharedInstance].remindButtonLabel=@"稍后提醒";      // 稍后提醒 位@""时不显示
//    [iLink sharedInstance].updateButtonLabel=@"立即前往";
//    [iLink sharedInstance].message=@"主人,新版本体验更好哦,快去更新吧";
//    [iLink sharedInstance].applicationVersion = @"2.1.4";     // 本应用的版本
}

/**
 *  监听网络
 */
-(void)monitorNetWork{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
               [MBProgressHUD showError:@"未知网络"];
                [self normalNetWork];
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [self noNetWOrk];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                [self normalNetWork];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                [self normalNetWork];
                break;
        }
    }];
    [mgr startMonitoring];
}
/**
 *  没网
 */
-(void)noNetWOrk{
    [UserDefaults setObject:@"0" forKey:@"netWork"];
    [UserDefaults synchronize];
    [MBProgressHUD showError:@"主人,网络异常" toView:nil];
    //[MBProgressHUD showMessage:@"没有网络连接" view:nil isShow:NO];
}
/**
 *  正常的网络
 */
-(void)normalNetWork{
    [UserDefaults setObject:@"1" forKey:@"netWork"];
    [UserDefaults synchronize];
//    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    [UMSocialSnsService applicationDidBecomeActive];
}

-(void)afterLayInit{
    [[CrashReporter sharedInstance] enableLog:YES];

    [[CrashReporter sharedInstance] installWithAppId:@"900010727"];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[CrashReporter sharedInstance] enableLog:YES];
    [MobClick setCrashReportEnabled:NO];
    [MobClick startWithAppkey:UMAPPKey];
    [[CrashReporter sharedInstance] installWithAppId:@"900010727"];

    [self monitorNetWork];
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:kBaiDuMapKey  generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    [self BMKLocationServiceStartUserLocationService];

    [self getHeaderMessage];//获取请求头
    
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //用于异常处理
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:91.0 / 255.0 green:195.0 / 255.0 blue:88.0 / 255.0 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:28/255.0 green:27/255.0 blue:33/255.0 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [UINavigationBar appearance].frame=CGRectMake(0, 20, ScreenWidth, 35);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self addShareComponet];//sharesdk分享组件
    //加入友盟
    [self umeng];
    [UMSocialData setAppKey:UMAPPKey];
    
    
    //微信三方登录

    //https://itunes.apple.com/cn/app/weme-wei-mi-lu-shang-tu-cao/id914926728?l=en&mt=8
    //https://appsto.re/cn/iYkI2.i
    
    [UMSocialWechatHandler setWXAppId:wxAppID appSecret:wxAppSecret url:@"https://itunes.apple.com/cn/app/weme-wei-mi-lu-shang-tu-cao/id914926728?l=en&mt=8"];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];


    NSString *alias = [HKDeviceID getHKDeviceID];
    [FamilyInfo shareFamilyInfo].uuidString = alias;
    
    //[self start];
    [self automaticLogin];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkError:) name:kJPFServiceErrorNotification object:nil];
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0)
    {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
    }
    else
    {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
    #else
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    #endif
    
    [APService setupWithOption:launchOptions];

    //注册别名; ----刚进界面就注册别名,如果用户没有登录,就注册为空.
    
    NSString * accountID = [PersonInfo sharePersonInfo].accountIDString;
    [self congieurePushAction:accountID];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

/**
 *  添加一些分享的组件
 */
-(void)addShareComponet{
    [ShareSDK registerApp:shareAppKey];
    //    //分享
    //    //[ShareSDK registerApp:shareAppKey];
    //    [ShareSDK registerApp:shareAppKey activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType){
    //        switch (platformType) {
    //            case SSDKPlatformTypeWechat:
    //                [ShareSDKConnector connectWeChat:[WXApi class]];
    //                break;
    //
    //            default:
    //                break;
    //        }
    //
    //    }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
    //        switch (platformType) {
    //            case SSDKPlatformTypeSinaWeibo:
    //                [appInfo SSDKSetupSinaWeiboByAppKey:sinaAppKey appSecret:sinaAppSecret redirectUri:sinaRedirectUri authType:SSDKAuthTypeBoth];
    //                break;
    //            case SSDKPlatformTypeWechat:
    //                [appInfo SSDKSetupWeChatByAppId:wxAppID appSecret:wxAppSecret];
    //                break;
    //            default:
    //                break;
    //        }
    //    }];
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:sinaAppKey
                               appSecret:sinaAppSecret
                             redirectUri:sinaRedirectUri];

//
//    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
//    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
//                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
//                                redirectUri:@"http://www.sharesdk.cn"];
//    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
//    [ShareSDK connectQZoneWithAppKey:qq
//                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//

    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:wxAppID
                           appSecret:wxAppSecret
                           wechatCls:[WXApi class]];
    
}
-(void)BMKLocationServiceStartUserLocationService
{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    [HeaderModel sharedHeaderModel].latitude = _latitude;
    [HeaderModel sharedHeaderModel].longitude = _longitude;
}

#pragma mark --获得请求头要传得参数信息--
- (void)getHeaderMessage
{
    [HeaderModel sharedHeaderModel].sys = @"iOS";//系统类型
    [HeaderModel sharedHeaderModel].sysversion = [DataNetwork getSysversion];
    [HeaderModel sharedHeaderModel].app = [DataNetwork getAppWithType:2];//产品类型
    [HeaderModel sharedHeaderModel].appversion = [DataNetwork getAppversion];//产品版本
    [HeaderModel sharedHeaderModel].devicetype =  [DataNetwork getDevicetype];//手机型号
    [HeaderModel sharedHeaderModel].nettype = [DataNetwork getNetType];//网络类型
    
    [HeaderModel sharedHeaderModel].primarykey = [DataNetwork uuid] ;//设备号
}

#pragma mark - 友盟统计
- (void)umeng
{
    [MobClick startWithAppkey:@"54045bacfd98c5ea86018a47" reportPolicy:BATCH channelId:nil];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick updateOnlineConfig];
    [MobClick checkUpdate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note
{
}

#pragma mark - 设置根视图控制器NewLoginViewController
- (void)start
{
    NewLoginViewController *login = [[NewLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController = nav;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//    return [WXApi handleOpenURL:url delegate:self];
    return  [WXApi handleOpenURL:url delegate:self];
//    return YES;

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *param=[url query];
    NSLog(@"param:%@",param);
//    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
     return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:self];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    NSLog(@"-------%@",deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    NSLog(@"接受通知失败%@",error);
}
#pragma mark-- 推送
- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"1 --- networkDidSetup = %@",notification.userInfo);
}

- (void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"2 --- networkDidClose = %@",notification.userInfo);
}

- (void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"3 --- networkDidRegister = %@",notification.userInfo);
}

- (void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"4 --- networkDidLogin = %@",notification.userInfo);
}


- (void)networkError:(NSNotification *)notification
{
    NSLog(@"networkError = %@",notification.userInfo);
}

#pragma mark - 自定义消息推送
- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary   * userInfo = [notification userInfo];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSNotificationCenter *ncCenter =  [NSNotificationCenter defaultCenter];
    [ncCenter postNotificationName:PushMassageObserver object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
}
#pragma mark - 注册推送别名
- (void)congieurePushAction:(NSString*)accountID
{
    [APService setAlias:accountID callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    //NSLog(@"推送推送rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
//////如果 App状态为正在前台或者后台运行，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。此种情况在此函数中处理
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
    NSNotificationCenter *ncCenter =  [NSNotificationCenter defaultCenter];
    [ncCenter postNotificationName:PushMassageObserver object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
}

/////如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
#pragma mark --- 推送通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    //收到消息 ---  推送消息
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSNotificationCenter *ncCenter =  [NSNotificationCenter defaultCenter];
    [ncCenter postNotificationName:PushMassageObserver object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //[application setApplicationIconBadgeNumber:0];
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 自动登录
- (void)automaticLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _nameString = [defaults objectForKey:kNameString];//用户名
    _psdString = [defaults objectForKey:kpassworldString];//密码
    NSString *appStationStrig = [defaults objectForKey:kAppStation];
    _uidString = [defaults objectForKey:kWXUID];
    
    //用户名
    if (_nameString != nil && _nameString.length>0&&_psdString.length>0)
    {
        [self synchronizationLogin];
        return;
    }
    //家人连线
    if (appStationStrig != nil)
    {
        ChatFamilyViewController *chat = [[ChatFamilyViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chat];
        self.window.rootViewController = nav;
        return;
    }
    //微信登录
    if (_uidString != nil)
    {
        [self synchronizationWXLogin:_uidString];
        return;
    }
    [self start];
}
#pragma mark - 同步登录
- (void)synchronizationLogin
{
    LoginModel *loginModel = [[LoginModel alloc]init];
    int synch =[loginModel loginSynchronousWithName:_nameString pwd:_psdString];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogOut = [defaults objectForKey:@"isLogOut"];
    if(![isLogOut isEqualToString:@"1"])
    {
        if(synch==0)
        {
            [self congieurePushAction:[PersonInfo sharePersonInfo].accountIDString];
            NewRootViewController *root_Controller = [[NewRootViewController alloc] init];
            self.window.rootViewController = root_Controller;
        }
        else
        {
            [self start];
        }
    }else{
        [self start];
    }
}
#pragma mark - 同步微信登录
- (void)synchronizationWXLogin:(NSString *)uid
{
    NSInteger value = [LoginModel wxLoginSynchronousWith:uid];
    [self wxbound:value];
}
#pragma mark - 微信登录成功
- (void)wxbound:(NSInteger)iWX
{
    if(iWX==0||iWX==11)
    {
        NewRootViewController *root_Controller = [[NewRootViewController alloc]init];
        self.window.rootViewController = root_Controller;
    }
    else if (iWX==1)
    {
        BindingViewController *bvc = [[BindingViewController alloc]init];
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:bvc];
        self.window.rootViewController = nvc;
    }
    else
    {
        [self start];
    }
}



@end
