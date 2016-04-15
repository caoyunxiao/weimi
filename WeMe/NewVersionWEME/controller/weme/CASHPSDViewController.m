//
//  CASHPSDViewController.m
//  微密
//
//  Created by longlz on 14-7-19.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "CASHPSDViewController.h"

@interface CASHPSDViewController ()

@end

@implementation CASHPSDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.oldTextFeild.text = @"";
    self.modiyButton.enabled = NO;

    if (_isCashPwd)
    {
        [self.modiyButton setTitle:@"立即设置" forState:UIControlStateNormal];
        self.title = @"设置押金密码";
        self.reminderLabel.text = @"主人,您还没设置密码呢,请先设置吧";
        self.oldTextFeild.hidden = YES;
    }
    else
    {
        self.title = @"修改押金密码";
        self.oldTextFeild.hidden = NO;
        [self.modiyButton setTitle:@"立即修改" forState:UIControlStateNormal];
        self.reminderLabel.text = @"";
    }
}
- (void)setIsCashPwd:(BOOL)isCashPwd
{
    if (isCashPwd)
    {
        self.title = @"设置押金密码";
        self.oldTextFeild.hidden = YES;
        [self.modiyButton setTitle:@"立即设置" forState:UIControlStateNormal];
    }
    else
    {
        self.oldTextFeild.hidden = NO;
        [self.modiyButton setTitle:@"立即修改" forState:UIControlStateNormal];
        self.title = @"修改押金密码";
    }
    _isCashPwd = isCashPwd;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)modifyButtonClick:(id)sender
{
    
    if (!_isCashPwd)
    {
        if (![self.nowTextFeild.text isEqualToString:self.conformTextFeild.text])
        {
            Alert(@"主人,你输入的密码不一致哦");
            return;
        }
    }
    [RequestEngine updateDepositPasswordWithOldPassword:self.oldTextFeild.text newPassword:self.nowTextFeild.text completed:^(NSString *errorCode) {
        NSInteger cash = [errorCode integerValue];
        if (cash == 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            _preBlock();
        }
        else if (cash == 1)
        {
            Alert(@"主人,你输入的原始密码有误哦");
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oldTextFeild resignFirstResponder];
    [self.nowTextFeild resignFirstResponder];
    [self.conformTextFeild resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
