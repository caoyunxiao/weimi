//
//  MyViewController.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "MyViewController.h"
#import "QRCodeGenerator.h"
#import "Encryption.h"
#import "RequestEngine.h"
#import "BindWM.h"
#import "MobClick.h"
#import "ScanQRViewController.h"
#import "CASHPSDViewController.h"
#import "NewWEMEController.h"



@interface MyViewController ()
{
    ZBarReaderViewController *_reader;
    BOOL    _isSettingCashPwd;
    
    
    ModelView *_modelView;
    
}
@property (weak, nonatomic) IBOutlet UILabel *topAlertLbl;//提示消息

@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"我的IMEI";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
    //刷新绑定设备
    [RequestEngine getIMEIAndPhone:^(NSString *imeiStr, NSString *phoneStr, NSString *errorCode) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([errorCode isEqualToString:@"0"]) {
            [self refreshMyDevice];
            
        }
    }];
}
#pragma mark --
#pragma mark --页面加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tiaoxinma:) name:@"tiaoxinma" object:nil];
//    [_boundButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"] forState:UIControlStateHighlighted];
    //绑定成功后刷新界面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUi) name:refreshMyViewUIKey object:nil];
   _meTitleLabel.frame = CGRectMake(10,ScreenHeight-50, 300, 44);
    if ([_IMEIString isEqualToString:@"0"])
    {
        _IMEIString = @"";
        [PersonInfo sharePersonInfo].IMEIString = @"";
    }
    self.imeiTexeFeild.text = [NSString stringWithFormat:@"IMEI : %@",_IMEIString];
    self.imeiTexeFeild.delegate = self;
    [self.twoDimensionBtn setBackgroundImage:[UIImage imageNamed:@"double_btn_down.png"] forState:UIControlStateDisabled];
    [self.twoDimensionBtn setBackgroundImage:[UIImage imageNamed:@"double_btn.png"] forState:UIControlStateNormal];
    if (_isBound) // 是否绑定  
    {
        static NSString *alertTopMsg=@"你已成功绑定IMEI号,你在微密APP上的任何相关设置都对该IMEI对应的设备有效";
        self.topAlertLbl.text=alertTopMsg;
        self.topAlertLbl.frame=CGRectMake(self.topAlertLbl.frame.origin.x, self.topAlertLbl.frame.origin.y-10, self.topAlertLbl.frame.size.width, self.topAlertLbl.frame.size.height+10);
        //加密方法 ---》》》
        Encryption *des = [[Encryption alloc]init];
        NSString *desImei = [des encryptUseDES:_IMEIString key:IMEIKey];
        UIImage *codeImage = [QRCodeGenerator qrImageForString:desImei imageSize:self.codeImageView.bounds.size.width];
        self.codeImageView.image = codeImage;
        self.meTitleLabel.hidden = YES;/////////
        self.codeImageView.hidden = YES;
        [self.boundButton.titleLabel setTextColor:[UIColor whiteColor]];
        self.boundButton.backgroundColor=getRGB(232, 78, 64);
        [self.boundButton setTitle:@"解绑IMEI" forState:UIControlStateNormal];
        self.twoDimensionBtn.hidden = YES;
        self.imeiTexeFeild.enabled = NO;
        
        self.topAlertLbl.text=[self checkBrandType];
        [self addAlertLblToCurrentView];
//        self.boundButton.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:0 blue:7.0/255.0 alpha:1];
    }
    else
    {
        //self.boundButton.enabled = NO;
        static NSString *topAlertMsg=@"你还没有绑定IMEI,请在下面输入框中输入15位IMEI号";
        self.topAlertLbl.text=topAlertMsg;
//        self.boundButton.backgroundColor = self.boundButton.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:135.0/255.0 blue:9.0/255.0 alpha:1];
        self.boundButton.backgroundColor=getRGB(248, 240, 6);
        self.meTitleLabel.hidden = YES;
        [self.boundButton setTitle:@"绑定IMEI" forState:UIControlStateNormal];
        [self.boundButton.titleLabel setTextColor:[UIColor blackColor]];
        self.imeiTexeFeild.placeholder = @"输入15位IMEI号";
        self.imeiTexeFeild.text = @"";
        self.twoDimensionBtn.hidden = NO;
        self.imeiTexeFeild.enabled = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PledgePwd:) name:PledgePwdObserver object:nil];//押金密码
}
- (void)tiaoxinma:(NSNotification*)notify
{
    NSDictionary * dic = [notify userInfo];
    self.imeiTexeFeild.text = [dic objectForKey:@"tiaoxinma"];
}
- (void)PledgePwd:(NSNotification *)notification
{
    NSString *cashString = [notification.userInfo objectForKey:kCash];
    switch ([cashString intValue])
    {
        case 0:
        {
            //是否前往设置押金密码
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,你当前未设这押金密码,快去设置押金密码吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            alertView.tag = 1001;
            [alertView show];
        }
            break;
        case 1:
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
        case 2:
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
        case 3:
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
            break;
        default:
            break;
    }
}
//////////
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.imeiTexeFeild resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark --
#pragma mark -- 绑定按钮触发事件
- (IBAction)boundButtonClick:(id)sender
{

    [self.view endEditing:YES];
    if (_isBound)
    {
//        [_boundButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"] forState:UIControlStateHighlighted];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你确定要解绑IMEI吗?解绑后你使用该设备产生的任何数据都不会显示在你的帐号上,并且你在APP上做的任何设置也不会对该设备生效噢" delegate:self cancelButtonTitle:@"手抖点错了" otherButtonTitles:@"确定解绑", nil];
        alertView.tag = 1000;
        [alertView show];
    }
    else
    {
        if (_imeiTexeFeild.text.length==0)
        {
            Alert(@"主人,你还没有输入IMEI号呢")
            return;
        }
        if (_imeiTexeFeild.text.length!=15)
        {
            Alert(@"主人,你输入的IMEI账号有误哦")
            return;
        }
        [self bound:sender];//绑定微密一系列方法
    }
}

-(void)refreshUi{
    __weak typeof(self) selfVc=self;
    [self refreshMyDevice];
    //更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        selfVc.topAlertLbl.text=[self checkBrandType];
        [selfVc addAlertLblToCurrentView];
    });

}

- (void)bound:(id)sender
{
    
    BindWM * bind = [[BindWM alloc]init];
    
    [bind bindWMWithStr:self.imeiTexeFeild.text boudBtn:(UIButton*)sender];
    //刷新绑定设备
    [RequestEngine getIMEIAndPhone:^(NSString *imeiStr, NSString *phoneStr, NSString *errorCode) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([errorCode isEqualToString:@"0"]) {
            
        }
    }];
    
}
#pragma mark 添加提示的lable
/**
 *  添加提示的lable
 */
-(void)addAlertLblToCurrentView{
    static NSString *alertTopMsg=@"你已成功绑定IMEI号,你在微密APP上的任何相关设置都对该IMEI对应的设备有效";
    UILabel *alertlbl=[[UILabel alloc]init];
    alertlbl.backgroundColor=[UIColor whiteColor];
    alertlbl.textColor=[UIColor grayColor];
    alertlbl.text=alertTopMsg;
    alertlbl.numberOfLines=0;
    alertlbl.frame=CGRectMake(self.topAlertLbl.frame.origin.x,CGRectGetMaxY(self.boundButton.frame)+30, self.boundButton.frame.size.width,46);
    alertlbl.textAlignment=NSTextAlignmentCenter;
    alertlbl.font=self.topAlertLbl.font;
    [self.view addSubview:alertlbl];
    
}
#pragma mark 检查当前登录用户在什么设备上使用
/**
 *  检查当前登录用户在什么设备上使用
 */
-(NSString*)checkBrandType{
    NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
    NSString *brandType=[UserDefaults objectForKey:@"brandType"];
    NSString *resultStr=@"";
    if ([isThirdModel isEqualToString:@"1"]) {
        if (brandType==nil||[brandType isEqualToString:@""]||[brandType isEqualToString:@"NULL"]||[brandType isEqualToString:@"null"]) {
            resultStr=@"你正在 未知设备 上使用频道功能";
        }else{
            resultStr=[NSString stringWithFormat:@"你正在 %@ 上使用频道功能",brandType];
        }
        
    }else{
        resultStr=@"你正在 weme终端 上使用频道功能";
    }
    return resultStr;
}
#pragma mark 刷新
/**
 *  刷新我的设备
 */
-(void)refreshMyDevice{
    //刷新群聊
    NSNotification *noti=[[NSNotification alloc]initWithName:refreshDeviceNotificationName object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:noti];
    //刷新我的设备
    [[NSNotificationCenter defaultCenter]postNotificationName:refreshMyDeviceKey object:nil];
}
#pragma mark -- 解除绑定
- (void)removeIMEIBound
{
    [MBProgressHUD showMessage:@"主人解绑中..." view:self.view isShow:NO];
    [RequestEngine disconnestWithWeMe:^(NSString *errorCode) {
        if([errorCode isEqualToString:@"0"])
        {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"解绑成功!"];
            //刷新绑定设备
            [RequestEngine getIMEIAndPhone:^(NSString *imeiStr, NSString *phoneStr, NSString *errorCode) {
                if ([errorCode isEqualToString:@"0"]) {

                    [self refreshMyDevice];
                }
            }];
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil userInfo:nil];

            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:@"" forKey:BIND];
            BOOL flag = [[[NSUserDefaults standardUserDefaults] valueForKey:kAutoDraw] boolValue];
            if (flag)
            {
                [defaults setObject:@"0" forKey:kAutoDraw];
                NSString *psdString = [defaults valueForKey:@"daokePassword"];
                [RequestEngine applyWithdrawDepositApplyWithdrawAmount:@"0" depositPassword:psdString completed:^(NSString *errorCode) {
                    [defaults synchronize];
                }];
            }
            
            [PersonInfo sharePersonInfo].IMEIString = @"";
            self.imeiTexeFeild.text = @"";
            self.twoDimensionBtn.enabled = YES;
            self.imeiTexeFeild.enabled = YES;
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
            //[self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,解绑失败,请稍后再试吧" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000)
    {
        if (buttonIndex == 1)
        {
            [self removeIMEIBound];
        }
    }else if (alertView.tag == 1001)
    {
        if (!_isSettingCashPwd)
        {
            return;
        }
        if (buttonIndex == 1)
        {
            CASHPSDViewController *pwd = [[CASHPSDViewController alloc]initWithNibName:@"CASHPSDViewController" bundle:nil];
            [self.navigationController pushViewController:pwd animated:YES];
            
            pwd.isCashPwd = YES;
            pwd.preBlock = ^()
            {
                [self.navigationController popViewControllerAnimated:NO];

            };
            
        }else
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    
}
- (IBAction)imeiTextFeild:(id)sender
{
    //
}
#pragma mark -- 二维码扫描按钮触发
- (IBAction)twoDimensionBtnClick:(id)sender
{
    ScanQRViewController *scanVC = [[ScanQRViewController alloc]init];
    scanVC.isErWeiMa = NO;
    UINavigationController *scanNav = [[UINavigationController alloc]initWithRootViewController:scanVC];
    [self presentViewController:scanNav animated:YES completion:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end