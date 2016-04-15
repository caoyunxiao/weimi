//
//  ModifictionViewController.m
//  微密
//
//  Created by longlz on 14-7-15.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ModifictionViewController.h"
#import "MobClick.h"

#import "NewLoginViewController.h"
@interface ModifictionViewController ()
{
    BOOL isModifiySucceed;
    ModelView *_modelView;
    BOOL _canSelect;//可以点击确认按钮
}
@end
@implementation ModifictionViewController
- (id)init
{
    self = [super init];
    if (self) {
       self.title = @"修改密码";
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_modifyButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"]forState:UIControlStateHighlighted];
    [self uiConfig];
}

#pragma mark --初始化视图
- (void)uiConfig
{
    [_modifyButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"]forState:UIControlStateHighlighted];
    _textFieldArray = [[NSArray alloc] init];
    _textFieldArray = @[_oldTextField,_nowTextField,_confirmPwdTextFeild];
    [self changeTextUIReturnKeyAndDelegate:_textFieldArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignResponder];
}
#pragma mark -- 键盘放弃第一响应 --
- (void)resignResponder
{
    [self.view endEditing:YES];
}
- (IBAction)modification:(id)sender
{
    [self resignResponder];
    [self judgeIsEnable];
    
    if (!_canSelect)
    {
        return;
    }
    if (_modelView == nil)
    {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }
    [self.view addSubview:_modelView];
    [RequestEngine updatePasswordWithOldPsw:self.oldTextField.text newPsw:self.nowTextField.text complete:^(NSString *errorCode) {
        _canSelect = NO;
         [_modelView removeFromSuperview];
        if ([errorCode isEqualToString:@"0"])
        {
            isModifiySucceed = YES;
            Alert(@"主人,修改成功了哦");
//            [self.navigationController popViewControllerAnimated:YES];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"1" forKey:@"isLogOut"];
            [defaults removeObjectForKey:kpassworldString];
            [defaults removeObjectForKey:@"imei"];
            [defaults removeObjectForKey:@"phone"];
            [defaults removeObjectForKey:@"gradeTitle"];
            [defaults removeObjectForKey:@"bind"];
            [defaults removeObjectForKey:@"nickname"];
            [defaults removeObjectForKey:@"accountID"];
            [defaults removeObjectForKey:@"midian"];
            [defaults removeObjectForKey:@"name"];
            [defaults synchronize];
            [[PersonInfo sharePersonInfo] resetPersonInfo];
            NewLoginViewController *newLog = [[NewLoginViewController alloc] init];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:newLog];
            [self presentViewController:navigation animated:YES completion:nil];
        }
        else if([errorCode isEqualToString:@"-1"])
        {
            Alert(@"主人,网络好像不给力啊,检查一下网络吧");
        }
        else
        {
            Alert(errorCode);
        }
    }];
}
- (void)judgeIsEnable
{
    if (![self.oldTextField.text isEqualToString:@""]&&![self.nowTextField.text isEqualToString:@""]&&![self.confirmPwdTextFeild.text isEqualToString:@""])
    {
             if (![self.nowTextField.text isEqualToString:self.confirmPwdTextFeild.text])
             {
                 Alert(@"主人,你输入的密码不一致哦");
                 return;
             }
            else
            {
                if ([self.nowTextField.text isEqualToString:self.oldTextField.text])
                {
                    Alert(@"主人,新密码不能和旧密码一致,请从新输入吧");
                    return;
                }
                else
                {
                      if (self.nowTextField.text.length<6)
                      {
                         Alert(@"主人,密码长度必须大于5,请重新输入新密码吧");
                         return;
                       }
                       else
                       {
    
                          _canSelect = YES;
                        }
                }
            }
    }
    else
    {
        Alert(@"主人,请把信息输入完整吧");
    }
}

#pragma mark - 设置所有的textField的代理和键盘方式
- (void)changeTextUIReturnKeyAndDelegate:(NSArray *)array
{
    for (UITextField *textField in array)
    {
        textField.delegate = self;
        NSInteger index = [array indexOfObject:textField];
        if((index+1)==array.count)
        {
            textField.returnKeyType =UIReturnKeyDone;
        }
        else
        {
            textField.returnKeyType =UIReturnKeyNext;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.oldTextField == textField)
    {
        [self.oldTextField resignFirstResponder];
        [self.nowTextField becomeFirstResponder];
    }
    else if (self.nowTextField == textField)
    {
        [self.nowTextField resignFirstResponder];
        [self.confirmPwdTextFeild becomeFirstResponder];
    }
    else if (self.confirmPwdTextFeild == textField)
    {
        [self.confirmPwdTextFeild resignFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isModifiySucceed)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 密码显示明文或暗文
- (IBAction)isShowPassword:(UIButton *)sender {
    if (sender.tag == 22) {
        if ( self.oldTextField.secureTextEntry) {
            self.oldTextField.secureTextEntry = NO;
        }else{
            self.oldTextField.secureTextEntry = YES;
        }
    }
    if (sender.tag == 23) {
        if (self.nowTextField.secureTextEntry) {
            self.nowTextField.secureTextEntry = NO;
        }else{
            self.nowTextField.secureTextEntry = YES;
        }
    }
    if (sender.tag == 24) {
        if (self.confirmPwdTextFeild.secureTextEntry) {
            self.confirmPwdTextFeild.secureTextEntry = NO;
        }else{
            self.confirmPwdTextFeild.secureTextEntry = YES;
        }
    }
}

@end