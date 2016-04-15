//
//  LoginViewController.m
//  微密
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "NewLoginViewController.h"
#import "LoginModel.h"
#import "ChatFamilyViewController.h"
#import "AppDelegate.h"
#import "NewRegisterViewController.h"
#import "NewRootViewController.h"
#import "NewForgetPwdViewController.h"
#import "MobClick.h"
#import "NewLoginViewController.h"
#import "BindingViewController.h"
#import "BindWMViewController.h"
#import "UMSocialDataService.h"




@interface NewLoginViewController ()<UIActionSheetDelegate,UMSocialUIDelegate,UMSocialDataDelegate>
{
    LoginModel *_loginModel;
    ModelView  *_modelView;
    NSString *_uidString;
}
@property (weak, nonatomic) IBOutlet UIView *thirdLoginLineView;
@property (weak, nonatomic) IBOutlet UIView *thirdLoginALertView;
@property (weak, nonatomic) IBOutlet UIButton *thirdLoginBtn;

@end

@implementation NewLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.navigationController.navigationBarHidden = NO;
    self.passwordTextFeild.text = @"";
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
#pragma mark -- 视图加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    //第三方登录 没安装微信隐藏
    BOOL isInstallWexin=[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    if (!isInstallWexin) {
        self.thirdLoginALertView.hidden=YES;
        self.thirdLoginBtn.hidden=YES;
        self.thirdLoginLineView.hidden=YES;
    };
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"]forState:UIControlStateHighlighted];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(wxBoundSuccess:) name:kWXBoundObserverName object:nil];
    
    self.nameTextFeild.delegate = self;
    self.passwordTextFeild.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *nameString = [defaults objectForKey:kNameString];
    
    NSString *psdString = [defaults objectForKey:kpassworldString];
    
    NSString *appStationStrig = [defaults objectForKey:kAppStation];
    
    NSString *wxUidString = [defaults objectForKey:kWXUID];
    
    if (nameString != nil)
    {
        if (![nameString isEqualToString:@""])
        {
            self.nameTextFeild.text = nameString;
            self.passwordTextFeild.text = psdString;
            [self synchronizationLogin];
        }
    }
    if (appStationStrig != nil)
    {
        if(self.isJiaRenLine==nil)
        {
            ChatFamilyViewController *chat = [[ChatFamilyViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chat];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    if (wxUidString != nil)
    {
        [self synchronizationWXLogin:wxUidString];
    }
}
#pragma mark -- 登录网络请求
- (void)login
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine LoginWithName:self.nameTextFeild.text psw:self.passwordTextFeild.text complete:^(NSInteger fSucceed) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //0、登录成功  1、账号密码错误  2、用户名不存在    3、服务器错误 4、网络错误
        [self disposeValue:fSucceed];
        [UserDefaults setObject:@"0" forKey:@"isLogOut"];
        [UserDefaults synchronize];
    }];
    
}
#pragma mark -- 同步登录
- (void)synchronizationLogin
{
    __block NSString *synch = @"22";
    [RequestEngine LoginWithName:self.nameTextFeild.text psw:self.passwordTextFeild.text complete:^(NSInteger fSucceed) {
        synch = [NSString stringWithFormat:@"%ld",fSucceed];
    }];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogOut = [defaults objectForKey:@"isLogOut"];
    if(![isLogOut isEqualToString:@"1"])
    {
        [self disposeValue:[synch integerValue]];
    }
}
#pragma mark -- 同步微信登录
- (void)synchronizationWXLogin:(NSString *)uid
{
    [RequestEngine wxLoginUidCreateAccountID:uid nickname:@"" completed:^(NSString *errorCode) {
        [self wxbound:[errorCode integerValue]];
    }];
}
#pragma mark -- 登录按钮点击事件
- (IBAction)loginButtonClick:(id)sender
{
    if ([self.nameTextFeild.text isEqualToString:@""])
    {
        Alert(@"主人,你忘记输入账号了哦");
        return;
    }
    if([self.passwordTextFeild.text isEqualToString:@""])
    {
        Alert(@"主人,你忘记输入密码了哦");
        return;
    }
    [self.nameTextFeild resignFirstResponder];
    [self.passwordTextFeild resignFirstResponder];
    [self login];
}

#pragma mark - 获取用户手机号和imei号
- (void)getImeiPhone
{
    [RequestEngine getIMEIAndPhone:^(NSString *imeiStr, NSString *phoneStr, NSString *errorCode) {
        if([errorCode isEqualToString:@"0"])
        {
            if(phoneStr.length>0)
            {
                //有手机号
                [self setAlise];
                NewRootViewController *root_Controller = [[NewRootViewController alloc] init];
                [self.navigationController pushViewController:root_Controller animated:NO];
            }
            else
            {
                //没有手机号
                BindingViewController *bvc = [[BindingViewController alloc]init];
                bvc.passwordTextFeild = self.passwordTextFeild.text;
                [self.navigationController pushViewController:bvc animated:YES];
            }
        }
        else
        {
            Alert(@"主人,登录失败,请再试试吧");
        }
    }];
}

#pragma mark -- 提示信息
- (void)disposeValue:(NSInteger)value
{
    switch (value)
    {
        case 0:
        {
            [self getImeiPhone];
        }
            break;
        case 1:
        {
            Alert(@"主人,你输入的账号或者密码有错误,请再检查一遍吧");
            self.passwordTextFeild.text = @"";
        }
            break;
        case 2:
        {
            Alert(@"主人,该用户不存在哦");
            self.passwordTextFeild.text = @"";
        }
            break;
            
        case 3:
        {
            Alert(@"主人,网络好像不给力啊,检查一下网络吧");
        }
            break;
            
        case 4:
        {
            Alert(@"主人,网络好像不给力啊,检查一下网络吧");
        }
            break;
            
        default:
            break;
    }
}
- (void)setAlise
{
    AppDelegate * delegates = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegates congieurePushAction:[PersonInfo sharePersonInfo].accountIDString];
}
#pragma mark -- 注册
- (IBAction)registerButtonClick:(id)sender
{
    NewRegisterViewController *judge = [[NewRegisterViewController alloc]init];
    [self.navigationController pushViewController:judge animated:YES];
//    BindWMViewController *擦 = [[BindWMViewController alloc]init];
//    [self.navigationController pushViewController:擦 animated:YES];
}
#pragma mark -- 忘记密码
- (IBAction)dismissPsdButtonClick:(id)sender
{
    NewForgetPwdViewController *vc = [[NewForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nameChanage:(id)sender
{
    // [self judgeIsEnable];
}

- (IBAction)pwdChanage:(id)sender
{
    // [self judgeIsEnable];
}

#pragma mark -- 影藏和显示密码 --
- (IBAction)HiddenKeyClick:(UIButton *)sender
{
    static NSInteger num;
    if (num%2 == 0)
    {
        _passwordTextFeild.secureTextEntry = NO;
        [_eyeBtn setImage:[UIImage imageNamed:@"blueEye"] forState:UIControlStateNormal];
    }
    else
    {
        _passwordTextFeild.secureTextEntry = YES;
        [_eyeBtn setImage:[UIImage imageNamed:@"eress"] forState:UIControlStateNormal];
    }
    num++;
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response{

}
#pragma mark - 微信登录
- (IBAction)weiXinLogIn:(UIButton *)sender
{
    
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
//             dispatch_queue_t q =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_sync(q, ^{
//                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
//                    [self preserveInforsAboutWeiXin:response.data];
//                }];
//            });
            
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                NSLog(@"response.data:%@",response.data);
                [self preserveInforsAboutWeiXin:response.data];
            }];
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            _uidString=snsAccount.usid;
            [self wxLogin:_uidString nickName:snsAccount.userName];
            [self wxSave];
            
        }
        
    });
//    [ShareSDK getUserInfo:SSDKPlatformSubTypeWechatSession onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state==SSDKResponseStateSuccess) {
//            [self preserveInforsAboutWeiXin:user];
//            _uidString=user.uid;
//            [self wxLogin:_uidString nickName:user.nickname];
//            [self wxSave];
//        }
//    }];
    
//    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
//     {
//         if (result)
//         {
//             NSDictionary *dict = [userInfo sourceData];
//             [self preserveInforsAboutWeiXin:dict];
//             _uidString = [dict objectForKey:@"unionid"];
//             NSString *nickname = [userInfo nickname];
//             [self wxLogin:_uidString nickName:nickname];
//             [self wxSave];
//         }
//     }];
    }



#pragma mark - 获取微信信息
- (void)preserveInforsAboutWeiXin:(NSDictionary *)user
{
    NSLog(@"login------dict:%@",user);
    NSDictionary *dict=[NSDictionary dictionaryWithDictionary:user];
    NSString *location=[user objectForKey:@"location"];
    NSArray *address=[Tool splitByStr:location splitStr:@","];
    
    _city = [address objectAtIndex:2];
    _country = [address objectAtIndex:0];
    _headimgurl = [user objectForKey:@"profile_image_url"];
    _nickname = [user objectForKey:@"screen_name"];
    _openid = [user objectForKey:@"openid"];
    _province = [address objectAtIndex:1];
    
    _sex = [[NSString stringWithFormat:@"%@",[user valueForKey:@"gender"]] isEqualToString:@"1"]?@"男":@"女";
    
    [PersonInfo sharePersonInfo].nicknameString = _nickname;
    [PersonInfo sharePersonInfo].iconString = _headimgurl;
    [PersonInfo sharePersonInfo].senderUserHeadName = _headimgurl;
    [PersonInfo sharePersonInfo].sexString = _sex;
    [PersonInfo sharePersonInfo].areaStr = _city;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_headimgurl forKey:@"iconString"];
    [defaults synchronize];
}


#pragma mark - 家人连线
- (IBAction)jiaRenLogIn:(UIButton *)sender
{
    ChatFamilyViewController *chat = [[ChatFamilyViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chat];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 微信登录成功
- (void)wxbound:(NSInteger)iWX
{
//    //1wx=1是绑定电话 现在直接跳过
//    NewRootViewController *root_Controller = [[NewRootViewController alloc]init];
//    [self.navigationController pushViewController:root_Controller animated:NO];

   
    switch (iWX)
    {
        case 0:
        {
            NewRootViewController *root_Controller = [[NewRootViewController alloc]init];
            [self.navigationController pushViewController:root_Controller animated:NO];
//            BindingViewController *bvc = [[BindingViewController alloc]init];
//            bvc.passwordTextFeild = self.passwordTextFeild.text;
//            [self.navigationController pushViewController:bvc animated:YES];
        }
            break;
        case 1:
        {
            BindingViewController *bvc = [[BindingViewController alloc]init];
            bvc.passwordTextFeild = self.passwordTextFeild.text;
//            bvc.isShowTiaoGuo=@"YES";
            [self.navigationController pushViewController:bvc animated:YES];
            
//            NewRootViewController *root_Controller = [[NewRootViewController alloc]init];
//            
//            [self.navigationController pushViewController:root_Controller animated:NO];
        }
            break;
            
        case 2:
            Alert(@"主人,网络好像不给力啊,检查一下网络吧");
            break;
        case 3:
            Alert(@"主人,网络好像不给力啊,检查一下网络吧");
            break;
            
        default:
            break;
    }
}
#pragma mark -- 微信登录调用函数
- (void)wxLogin:(NSString *)uid nickName:(NSString *)nickName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine wxLoginUidCreateAccountID:uid nickname:nickName completed:^(NSString *errorCode)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // 0、已绑定  1、未绑定  2、服务器错误  3、网络错误
        NSInteger iSuccess = [errorCode integerValue];
        if(iSuccess == 11)
        {
            NSDictionary *dict = [LoginModel getIMEIAndPhone];
            NSString *imeiStr= [dict objectForKey:@"imei"];
            NSString *phoneStr= [dict objectForKey:@"phone"];
            NSLog(@"phoneStr:%@",phoneStr);
            NSString *strSucceed = nil;
            if (dict != nil)
            {
                if ([imeiStr isEqualToString:@"0"])
                {
                    imeiStr = @"";
                }
                [PersonInfo sharePersonInfo].IMEIString = imeiStr;
                [PersonInfo sharePersonInfo].phoneString = phoneStr;
                if ([phoneStr length] < 11)
                {
                    strSucceed = @"1";
                }
                else
                {
                    strSucceed = @"0";
                }
            }
            else
            {
                strSucceed = @"2";
            }
            iSuccess = [strSucceed integerValue];
        }
        [self wxbound:iSuccess];
    }];
}

- (void)wxSave
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_uidString forKey:kWXUID];
    [defaults setObject:nil forKey:kNameString];
    [defaults setObject:nil forKey:kpassworldString];
    [defaults setObject:nil forKey:kFamilyPhoneOrIMEI];
    [defaults setObject:nil forKey:kAppStation];
    [defaults synchronize];
}

#pragma mark -- 微信绑定成功通知
- (void)wxBoundSuccess:(NSNotification *)notification
{
    [self wxSave];
    [self disposeValue:0];
}

- (void)judgeIsEnable
{
    NSString *nameString = self.nameTextFeild.text;
    NSString *pwdString = self.passwordTextFeild.text;
    if (![nameString isEqualToString:@""] &&![pwdString isEqualToString:@""])
    {
        self.loginButton.enabled = YES;
    }
    else
    {
        self.loginButton.enabled = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextFeild resignFirstResponder];
    [self.passwordTextFeild resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.nameTextFeild == textField)
    {
        [self.nameTextFeild resignFirstResponder];
        [self.passwordTextFeild becomeFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
