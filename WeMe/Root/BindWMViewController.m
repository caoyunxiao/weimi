//
//  BindWMViewController.m
//  微密
//
//  Created by MacDev on 15/3/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BindWMViewController.h"
#import "MyViewController.h"
#import "BindWM.h"
#import "MobClick.h"
#import "NewRootViewController.h"
@interface BindWMViewController ()
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;
@property (weak, nonatomic) IBOutlet UIButton *bindButton;


@end
@implementation BindWMViewController
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
    // Do any additional setup after loading the view from its nib.
    _imeiField.keyboardType = UIKeyboardTypeNumberPad;
    self.title = @"绑定微密";
    self.bindButton.layer.masksToBounds = YES;
    self.bindButton.layer.cornerRadius = 5;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goBackToRootView) name:BINDWMSUCCESS object:nil];
}
- (IBAction)jumpClick:(UIButton *)sender
{
    [self login];
}
#pragma mark -- 登录网络请求
- (void)login
{
    ModelView *modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:modelView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *nameString = [defaults objectForKey:kNameString];
    
    NSString *psdString = [defaults objectForKey:kpassworldString];
    [RequestEngine LoginWithName:nameString psw:psdString complete:^(NSInteger fSucceed) {
        //0、登录成功  1、账号密码错误  2、用户名不存在    3、服务器错误 4、网络错误
        [modelView removeFromSuperview];
        
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
            //RootViewController *root_Controller = [[RootViewController alloc]init];
            NewRootViewController *root_Controller = [[NewRootViewController alloc] init];
            [self.navigationController pushViewController:root_Controller animated:NO];
        }
            break;
        case 1:
        {
            Alert(@"主人,你输入的账号或者密码有错误,请再检查一遍吧");
            //self.passwordTextFeild.text = @"";
        }
            break;
        case 2:
        {
            Alert(@"主人,该用户不存在哦");
            //self.passwordTextFeild.text = @"";
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

- (IBAction)bindClick:(UIButton *)sender
{
    if (_imeiField.text.length != 15)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,请输入正确IMEI" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    BindWM * bind = [[BindWM alloc]init];
    [bind bindWMWithStr:_imeiField.text boudBtn:sender];
    //[bind bindWMWithStr:_imeiField.text sender];
}
#pragma mark -- 绑定微密成功了
- (void)goBackToRootView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //textField.background = [UIImage imageNamed:@"green"];
    if (self.view.frame.origin.y != -140)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.view.frame = CGRectMake(0, -140, self.view.bounds.size.width, self.view.bounds.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //textField.background = [UIImage imageNamed:@"black"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //textField.background = [UIImage imageNamed:@"black"];
    [textField resignFirstResponder];
    [self viewAnimation];
    return YES;
}
- (void)viewAnimation
{
    if (self.view.frame.origin.y == -140)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
            
        } completion:^(BOOL finished)
         {
             
         }];
    }
}

#pragma mark - 还没购买WEMI
- (IBAction)whatIMEIButton:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://item.m.jd.com/product/1553794.html"]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end