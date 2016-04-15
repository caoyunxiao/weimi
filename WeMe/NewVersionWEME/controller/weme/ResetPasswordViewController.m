//
//  ResetPasswordViewController.m
//  微密
//
//  Created by wemeDev on 15/5/27.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "NewLoginViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"重置密码";
}

#pragma mark - 修改密码
- (IBAction)upDataButton:(UIButton *)sender
{
    if([self judgeIsEnable])
    {
        [self refreshWithStatus:YES];
        [RequestEngine updatePasswordWithOldPsw:self.oldPassWord.text newPsw:self.myNewPassWord.text complete:^(NSString *errorCode) {
            [self refreshWithStatus:NO];
            if ([errorCode isEqualToString:@"0"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"主人,你的密码已经重置成功了,快点去重新登录吧哦" delegate:self cancelButtonTitle:nil otherButtonTitles:@"已阅", nil];
                alert.tag = 777;
                [alert show];
            }
            else
            {
                Alert(@"主人,密码重置失败哦");
            }
        }];
    }
}
#pragma mark - 对密码进行判断
- (BOOL)judgeIsEnable
{
    if(self.oldPassWord.text.length<=0)
    {
        Alert(@"主人,你忘记输入原始密码了哦");
        return NO;
    }
    if(self.myNewPassWord.text.length<=0)
    {
        Alert(@"主人,你忘记输入新的密码了哦");
        return NO;
    }
    if(self.surePassWord.text.length<=0)
    {
        Alert(@"主人,你忘记确认新的密码了哦");
        return NO;
    }
    if(![self.surePassWord.text isEqualToString:self.myNewPassWord.text])
    {
        Alert(@"主人,你两次输入的密码不一样哦");
        return NO;
    }
    if([self.oldPassWord.text isEqualToString:self.myNewPassWord.text])
    {
        Alert(@"主人,你输入的新密码和旧密码一样哦");
        return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==777)
    {
        if(buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kpassworldString];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NewLoginViewController *newLog = [[NewLoginViewController alloc] init];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:newLog];
            [self presentViewController:navigation animated:YES completion:nil];
        }
    }
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
