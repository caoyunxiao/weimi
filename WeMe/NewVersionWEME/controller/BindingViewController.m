//
//  BindingViewController.m
//  微密
//
//  Created by wemeDev on 15/6/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BindingViewController.h"
#import "HENLENSONG.h"
#import "NewRootViewController.h"
#import "AppDelegate.h"
#import "NewLoginViewController.h"
#import "DismissBindTelPhoneController.h"

@interface BindingViewController ()
@property(nonatomic,strong)UIAlertView *alertView;

/**
 *  倒计时的lbl背景色
 */
@property(nonatomic,strong)UIColor *timeLblColor;
@end

@implementation BindingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *naviChildControllers=self.navigationController.childViewControllers;
    if (naviChildControllers.count==1&&naviChildControllers[0]==self) {
        self.navigationItem.leftBarButtonItem=[self creatLeftbtn];
    }
    _isHavePassWord = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *psdString = [defaults objectForKey:kpassworldString];
    
    if(self.oldPhoneNumber.length>0)
    {
        self.title = @"修改手机号";
        self.topLabel.hidden = YES;
        self.passWord.hidden = YES;
        self.surePassWord.hidden = YES;
        self.bigButton.frame = CGRectMake(20, 194, 280, 40);
        [self.bigButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    else
    {
        if(self.isShowTiaoGuo == nil)
        {
            [self setRightTiaoGuoButton];
        }
        self.title = @"绑定手机号";
        [self.bigButton setTitle:@"绑定" forState:UIControlStateNormal];
    }
    
    if(self.passwordTextFeild.length>0||psdString.length>0)
    {
        _isHavePassWord = YES;
        self.passWord.hidden = YES;
        self.surePassWord.hidden = YES;
        self.bigButton.frame = CGRectMake(20, 194, 280, 40);
    }
    
}
/**
 *  生成返回按钮
 *
 *  @return <#return value description#>
 */
-(UIBarButtonItem*)creatLeftbtn{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(0, 0, 30, 44);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(returnLogin) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

/**
 *  返回到登录页面
 */
-(void)returnLogin{
    NewLoginViewController *loginController=[[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginController animated:YES];
}

#pragma mark - 绑定手机号跳过按钮
- (void)setRightTiaoGuoButton
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *uidString = [defaults objectForKey:kWXUID];
//    if(uidString == nil || uidString.length == 0)
//    {
    
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        button.titleLabel.textAlignment = NSTextAlignmentRight;
//        [button setTitle:@"跳过" forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem = buttonItem;
    
//    }
}

#pragma mark - 绑定手机号跳过事件
- (void)rightButtonClick
{
    [self setAlise];
    NewRootViewController *rvc = [[NewRootViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:NO];
}

#pragma mark - 获取验证码
- (IBAction)getVerificationCode:(UIButton *)sender
{
    if (![HENLENSONG isValidateMobile:self.phoneNumber.text])
    {
        Alert(@"主人,请输入正确的手机号码");
        
        return;
    }
    self.getVerificationCode.enabled = NO;
    self.timeLblColor=self.tiShiLabel.backgroundColor;
    self.tiShiLabel.backgroundColor=[UIColor grayColor];
    _oldNum = self.phoneNumber.text;
    [Request1617 checkMobileRegister:self.phoneNumber.text completed:^(NSString *errorCode, NSDictionary *resultDict) {
        if([errorCode isEqualToString:@"0"])
        {
            NSString *isbind = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"isbind"]];
            NSString *ismatch = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"ismatch"]];
            if([isbind isEqualToString:@"1"]||[ismatch isEqualToString:@"1"])
            {
                //Alert(@"主人,该手机号已经被绑定了哦");
                self.alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,该手机号已经被绑定了哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去解除绑定", nil];
                [self.alertView show];
                return;
            }
            //[isbind isEqualToString:@"0"]&&
            else if([ismatch isEqualToString:@"0"])
            {
                [Request1617 sendBindVerifyMessage:self.phoneNumber.text times:nil completed:^(NSString *errorCode, NSString *result) {
                    NSLog(@"resultresultresultresult：%@",result);
                    if([errorCode isEqualToString:@"0"])
                    {
                        [self startTimer];
                    }
                    else if([errorCode isEqualToString:@"ME01001"])
                    {
                        self.getVerificationCode.enabled = YES;
                        self.tiShiLabel.backgroundColor=self.timeLblColor;
                        Alert(@"主人,你验证码获取太频繁,请在一小时后重新获取吧");
                    }
                    else
                    {
                        self.getVerificationCode.enabled = YES;
                        self.tiShiLabel.backgroundColor=self.timeLblColor;
                        Alert(@"主人,网络不给力啊,请检查一下网络吧");
                    }
                    
                }];
            }
        }
        else
        {
            self.getVerificationCode.enabled = YES;
            self.tiShiLabel.backgroundColor=self.timeLblColor;
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
    
}






#pragma mark -- 定时器 
- (void)startTimer
{
    _iTimer = 59;
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer) userInfo:nil repeats:YES];
}
- (void)myTimer
{
    NSString *string = [NSString stringWithFormat:@"重新获取(%ds)",_iTimer--];
    self.tiShiLabel.text = string;
    if (_iTimer == 0)
    {
        self.tiShiLabel.text = @"重新获取";
        self.tiShiLabel.backgroundColor=self.timeLblColor;
        [_myTimer invalidate];
        _myTimer = nil;
        self.getVerificationCode.enabled = YES;
    }
}

#pragma mark - 绑定手机号
- (IBAction)BindingButton:(UIButton *)sender
{
    if(self.VerificationCode.text.length==0)
    {
        Alert(@"主人,验证码不能为空哦");
        return;
    }
    if (![HENLENSONG isValidateMobile:self.phoneNumber.text])
    {
        Alert(@"主人,请输入正确的手机号码");
        return;
    }
    if(self.oldPhoneNumber==nil||self.oldPhoneNumber.length==0)
    {
        self.oldPhoneNumber = @"";
    }
    if(self.oldPhoneNumber.length>0)
    {
        //修改手机号
        [self userBindMobile];
    }
    else
    {
        //绑定手机号设置密码
        [self verifyAndresetWithMobile];
    }
}
#pragma mark - 绑定手机号设置密码
- (void)verifyAndresetWithMobile
{
    NSString *passWord;
    if(_isHavePassWord)
    {
        passWord = self.passwordTextFeild;
    }
    else
    {
        passWord = self.passWord.text;
    }
    if(passWord.length<=0)
    {
        Alert(@"主人,密码不能为空哦");
        return;
    }
    if(![self.passWord.text isEqualToString:self.surePassWord.text])
    {
        Alert(@"主人,你两次输入的密码不一样哟");
        return;
    }
    
    [RequestEngine verifyAndresetWithMobile:self.phoneNumber.text verificationCode:self.VerificationCode.text newPassword:self.surePassWord.text completed:^(NSString *errorCode, NSString *resultStr) {
        if([errorCode isEqualToString:@"0"])
        {
            [PersonInfo sharePersonInfo].phoneString = self.phoneNumber.text;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:self.phoneNumber.text forKey:@"phone"];
            _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,你的手机号和密码设置成功了哦" delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
            [_alert show];
        }
        else
        {
            Alert(resultStr);
        }
        
    }];
}

#pragma mark - 修改手机号
- (void)userBindMobile
{
    [Request1617 userBindMobile:self.oldPhoneNumber newmobile:self.phoneNumber.text validateCode:self.VerificationCode.text completed:^(NSString *errorCode, NSString *result) {
        if([errorCode isEqualToString:@"0"])
        {
            [PersonInfo sharePersonInfo].phoneString = self.phoneNumber.text;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:self.phoneNumber.text forKey:@"phone"];
            _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,你的手机号已经绑定成功了哦" delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
            [_alert show];
        }
        else if ([errorCode isEqualToString:@"ME22007"])
        {
            Alert(@"主人,你输入的验证码有误哟");
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}
#pragma mark - 电话号码输入框发生变化
- (IBAction)phoneNumberTextFeild:(UITextField *)sender
{
    NSString *phoneNumberString = self.phoneNumber.text;
    if ([phoneNumberString length] == 11 && [HENLENSONG isValidateMobile:phoneNumberString])
    {
        if(_oldNum!=nil && [_oldNum length] == 11 && [HENLENSONG isValidateMobile:_oldNum])
        {
            if(![_oldNum isEqualToString:self.phoneNumber.text])
            {
                self.tiShiLabel.text = @"立即获取";
                [_myTimer invalidate];
                _myTimer = nil;
                self.getVerificationCode.enabled = YES;
            }
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == _alert)
    {
        [self setAlise];
        NewRootViewController *rvc = [[NewRootViewController alloc]init];
        [self.navigationController pushViewController:rvc animated:NO];
    }
    if (alertView==self.alertView&&buttonIndex==1) {
        DismissBindTelPhoneController *disMissController=[[DismissBindTelPhoneController alloc]initWithNibName:@"DismissBindTelPhoneController" bundle:nil];
        [disMissController setValue:self.phoneNumber.text forKey:@"phoneNum"];
        [self.navigationController pushViewController:disMissController animated:NO];
        self.getVerificationCode.enabled = YES;
        self.tiShiLabel.backgroundColor=self.timeLblColor;
    }else if(alertView==self.alertView&&buttonIndex==0){
        self.getVerificationCode.enabled = YES;
        self.tiShiLabel.backgroundColor=self.timeLblColor;

    }
}
- (void)setAlise
{
    AppDelegate * delegates = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegates congieurePushAction:[PersonInfo sharePersonInfo].accountIDString];
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
