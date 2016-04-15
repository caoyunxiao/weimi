//
//  NewForgetPwdViewController.m
//  微密
//
//  Created by APP on 15/5/15.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewForgetPwdViewController.h"
#import "LoginModel.h"
#import "HENLENSONG.h"
#import "MobClick.h"

@interface NewForgetPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *conPwdTextFeild;
@property (weak, nonatomic) IBOutlet UIButton    *codeButton;
@property (weak, nonatomic) IBOutlet UIButton    *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)UIColor *timeLblColor;
@end

@implementation NewForgetPwdViewController
{
    NSTimer *_myTimer;
    int _iTimer;
    ModelView *_modelView;
    LoginModel *_model;
    NSString *verificationCodeString;
    float _keyboardHeight;
    float _currentTextFieldHeight;
}
#pragma mark - 重置密码
- (IBAction)resetButtonClick:(id)sender
{
    [self.view endEditing:YES];
    if (![HENLENSONG isValidateMobile:self.phoneNumberTextFeild.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,请输入正确的手机号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"已阅", nil];
        [alertView show];
        return;
    }
    if (!self.codeTextFeild.text.length)
    {
        Alert(@"主人,验证码不能为空哦")
        return;
    }
    if (![self.pwdTextFeild.text isEqualToString:self.conPwdTextFeild.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,你输入的密码不一致哦" message:nil delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *phoneNumber = self.phoneNumberTextFeild.text;//手机号
    NSString *codeString = self.codeTextFeild.text;//验证码
    NSString *newPassword = self.pwdTextFeild.text;//密码
    newPassword  = [newPassword stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([newPassword length] < 6)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,密码长度不能小于6位哦" message:nil delegate:self cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    ///填写信息完成个人信息注册
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine resetPasswordCheckVerifyCodeWithMobile:phoneNumber verifyCode:codeString newPassword:newPassword completed:^(NSString *errorCode, NSString *resultStr) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([errorCode isEqualToString:@"0"])
        {
            Alert(@"主人,新密码已经设置成功哦");
            self.codeTextFeild.text = @"";
            self.phoneNumberTextFeild.text = @"";
            self.pwdTextFeild.text = @"";
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            Alert(@"主人,新密码已经设置失败哦");
        }
        
    }];
}
#pragma mark - 发送验证码
- (IBAction)codeButtonClick:(id)sender
{
    NSString *phoneNumberString = self.phoneNumberTextFeild.text;
    if ([phoneNumberString length] == 11 && [HENLENSONG isValidateMobile:self.phoneNumberTextFeild.text])
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.timeLblColor=self.timeLabel.backgroundColor;
        /////注册重新发送验证码
        self.codeButton.enabled = NO;
        _oldNum = self.phoneNumberTextFeild.text;
        [RequestEngine sendIdentifyingCodeMobilePhone:phoneNumberString times:nil completed:^(NSString *errorCode, NSString *resultStr) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           
            if([errorCode isEqualToString:@"0"])
            {
                
                [self startTimer];
                 self.timeLabel.backgroundColor=[UIColor grayColor];
            }
            else if([errorCode isEqualToString:@"ME01001"])
            {
                self.codeButton.enabled = YES;
                if([resultStr isEqualToString:@"用户不存在"])
                {
                    Alert(@"主人,该用户不存在哦");
                }
                else
                {
                    Alert(@"主人,你验证码获取太频繁,请在一小时后重新获取吧");
                }
            }
            else
            {
                self.codeButton.enabled = YES;
                Alert(@"主人,网络不给力啊,请检查一下网络吧");
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,请输入正确的手机号码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"已阅", nil];
        [alertView show];
    }
}
#pragma mark -- 定时器 --
- (void)startTimer
{
    _iTimer = 59;
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer) userInfo:nil repeats:YES];
}
#pragma mark - 定时器函数
- (void)myTimer
{
    NSString *string = [NSString stringWithFormat:@"重新获取(%ds)",_iTimer];
    self.timeLabel.text = string;
    if (_iTimer == 0)
    {
        self.timeLabel.backgroundColor=self.timeLblColor;
        self.timeLabel.text = @"重新获取";
        [_myTimer invalidate];
        _myTimer = nil;
        self.codeButton.enabled = YES;
    }
    _iTimer--;
}

#pragma mark - 电话输入框-手机号发生改变
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"忘记密码";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden) name:UIKeyboardWillHideNotification object:nil];
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
    //self.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
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

#pragma mark - 键盘return
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
