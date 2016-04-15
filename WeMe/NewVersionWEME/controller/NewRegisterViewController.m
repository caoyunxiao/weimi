//
//  NewRegisterViewController.m
//  微密
//
//  Created by APP on 15/5/12.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewRegisterViewController.h"
#import "MobClick.h"
#import "DefindTextViewController.h"
#import "ModelView.h"
#import "RequestEngine.h"
#import "RegisterInfo.h"
#import "HENLENSONG.h"
#import "LoginModel.h"
#import "SetUserInfoViewController.h"

@interface NewRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *conPwdTextFeild;
@property (weak, nonatomic) IBOutlet UIButton    *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton    *codeButton;//验证码
@property (weak, nonatomic) IBOutlet UIButton    *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 *  倒计时lbl背景色
 */
@property(nonatomic,strong)UIColor *timeLblColor;
@end

@implementation NewRegisterViewController
{
    BOOL _isAgree;//是否同意条款
    NSTimer *_myTimer;
    int _iTimer;
    ModelView *_modelView;
    LoginModel *_model;
    NSString *verificationCodeString;
    float _keyboardHeight;
    float _currentTextFieldHeight;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _isAgree = YES;
    _agreeButton.selected = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:UIKeyboardWillHideNotification object:nil];
    //微信绑定
    [self weiXinBangDing:self.typeStr];
}
#pragma mark - 微信绑定
- (void)weiXinBangDing:(NSString *)stringType
{
    if([stringType isEqualToString:@"微信绑定"])
    {
        self.title = @"绑定手机号";
        [self.registerButton setTitle:@"绑定手机号" forState:UIControlStateNormal];
    }
    else
    {
        self.title = @"注册";
    }
}
#pragma mark - 注册
- (IBAction)registerButtonClick:(id)sender
{
    if (![HENLENSONG isValidateMobile:self.phoneNumberTextFeild.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,请输入正确的手机号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"已阅", nil];
        [alertView show];
        return;
    }
    if (!self.codeTextFeild.text.length) {
        Alert(@"主人,验证码不能为空哦")
        return;
    }
    if (![self.pwdTextFeild.text isEqualToString:self.conPwdTextFeild.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,你输入的密码不一致哦" message:nil delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    NSString *phoneNumber = self.phoneNumberTextFeild.text;
    NSString *codeString = self.codeTextFeild.text;
    NSString *string = self.pwdTextFeild.text;
    string  = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([string length] < 6) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,密码长度不能小于6位哦" message:nil delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    if (!_isAgree)
    {
        Alert(@"主人,您必须同意服务条款才可以注册哦")
        return;
    }
    //self.registerButton.enabled = YES;
    NSDictionary * dataDic = @{@"nickname":@"",@"mobile":phoneNumber ,@"appKey":@"iOS",@"daokePassword":self.pwdTextFeild.text,@"verificationCode":codeString,@"accountType":@"2"};
    ///填写信息完成个人信息注册
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine finishedRegisterWithDic:dataDic complete:^(NSString *errorCode, NSString *strFinsed) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([strFinsed isEqualToString:@"注册成功"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:phoneNumber forKey:kNameString];
            [defaults setObject:self.pwdTextFeild.text forKey:kpassworldString];
            [defaults setObject:nil forKey:kFamilyPhoneOrIMEI];
            [defaults setObject:nil forKey:kAppStation];
            [defaults synchronize];
            [PersonInfo sharePersonInfo].phoneString = phoneNumber;
            //[self login:self.phoneNumberTextFeild.text daokePassword:self.pwdTextFeild.text];
            //跳转设置个人信息页面
            SetUserInfoViewController *vc = [[SetUserInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            Alert(strFinsed);
        }
    }];
    
}
#pragma mark - 验证码
- (IBAction)codeButtonClick:(id)sender {
    NSString *phoneNumberString = self.phoneNumberTextFeild.text;
    self.timeLblColor=self.timeLabel.backgroundColor;
    self.timeLabel.backgroundColor=[UIColor grayColor];
    if ([phoneNumberString length] == 11 && [HENLENSONG isValidateMobile:self.phoneNumberTextFeild.text])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        /////注册重新发送验证码
        self.codeButton.enabled = NO;
        _oldNum = phoneNumberString;
        [RequestEngine registerWithPhoneNumber:phoneNumberString times:nil complete:^(NSString *errorCode, NSString *regCode) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if([errorCode isEqualToString:@"0"])
            {
                [self startTimer];
            }
            else
            {
                self.codeButton.enabled = YES;
                self.timeLabel.backgroundColor=self.timeLblColor;
                Alert(regCode);
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,请输入正确的手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"已阅", nil];
        [alertView show];
    }
}
#pragma mark -- 定时器 --
- (void)startTimer
{
    _iTimer = 59;
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer) userInfo:nil repeats:YES];
}
#pragma mark - 定时器事件
- (void)myTimer
{
    NSString *string = [NSString stringWithFormat:@"重新获取(%ds)",_iTimer];
    self.timeLabel.text = string;
    if (_iTimer == 0)
    {
        self.timeLabel.text = @"重新获取";
        self.timeLabel.backgroundColor=self.timeLblColor;
        [_myTimer invalidate];
        _myTimer = nil;
        self.codeButton.enabled = YES;
    }
    _iTimer--;
}
#pragma mark - 合约
- (IBAction)serveButtonClick:(id)sender
{
    DefindTextViewController *dtvc = [[DefindTextViewController alloc]init];
    [self.navigationController pushViewController:dtvc animated:YES];
    
}
#pragma mark - 同意合约
- (IBAction)agreeButtonClick:(id)sender
{
    _isAgree = !_isAgree;
    _agreeButton.selected = !_agreeButton.selected;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _isAgree = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:self.title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
    
}
- (void)show:(NSNotification *)note
{
    CGRect rect = [[note userInfo][@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    _keyboardHeight = rect.origin.y;
    if(_currentTextFieldHeight>_keyboardHeight-140){
        self.view.frame = CGRectMake(0, _keyboardHeight-140-_currentTextFieldHeight, ScreenWidth, ScreenHeight);
   }
}

- (void)hidden
{
    self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextFieldHeight = textField.frame.origin.y;
    if (_keyboardHeight) {
        if(textField.frame.origin.y>_keyboardHeight-140){
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame = CGRectMake(0, _keyboardHeight-140-textField.frame.origin.y, ScreenWidth, ScreenHeight);
            }];
        }
    }
}

#pragma mark -- 登录网络请求
- (void)login:(NSString *)username daokePassword:(NSString *)daokePassword
{
    [RequestEngine LoginWithName:username psw:daokePassword complete:^(NSInteger fSucceed) {
        //0、登录成功  1、账号密码错误  2、用户名不存在    3、服务器错误 4、网络错误
        [self disposeValue:fSucceed];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"isLogOut"];
        [defaults synchronize];
    }];
}
#pragma mark -- 提示信息
- (void)disposeValue:(NSInteger)value
{
    switch (value)
    {
        case 0:
        {
            SetUserInfoViewController *vc = [[SetUserInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            Alert(@"主人,你输入的账号或者密码有错误,请再检查一遍吧");
        }
            break;
        case 2:
        {
            Alert(@"主人,该用户不存在哦");
        }
            break;
            
        case 3:
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
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
#pragma mark - 手机号发生改变
- (IBAction)phoneNumberTextFeild:(UITextField *)sender
{
    NSString *phoneNumberString = self.phoneNumberTextFeild.text;
    if ([phoneNumberString length] == 11 && [HENLENSONG isValidateMobile:self.phoneNumberTextFeild.text])
    {
        if(_oldNum!=nil && [_oldNum length] == 11 && [HENLENSONG isValidateMobile:_oldNum])
        {
            if(![_oldNum isEqualToString:self.phoneNumberTextFeild.text])
            {
                self.timeLabel.text = @"立即获取";
                [_myTimer invalidate];
                _myTimer = nil;
                self.codeButton.enabled = YES;
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumberTextFeild resignFirstResponder];
    [self.codeTextFeild resignFirstResponder];
    [self.pwdTextFeild resignFirstResponder];
    [self.conPwdTextFeild resignFirstResponder];
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
