//
//  DismissBindTelPhoneController.m
//  微密
//
//  Created by weme on 15/9/23.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import "DismissBindTelPhoneController.h"
#import "HENLENSONG.h"
#import "NewLoginViewController.h"

@interface DismissBindTelPhoneController ()<UIAlertViewDelegate>
//手机号码
@property (weak, nonatomic) IBOutlet UITextField *telPhoneNumTxt;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *validateCOde;

/**
 *  获取验证码的button
 */
@property (weak, nonatomic) IBOutlet UIButton *getValidateBtn;
/**
 *  定时器
 */
@property(nonatomic,strong)NSTimer *timer;

/**
 *  传递过来的电话号码
 */
@property(nonatomic,copy)NSString *phoneNum;

//倒计时
@property(nonatomic,assign)NSInteger countDown;
//倒计时lbl
@property(nonatomic,strong)UILabel *countDownLbl;

@property(nonatomic,strong)UIAlertView *alertView;
@end

@implementation DismissBindTelPhoneController
#pragma 获取验证码


- (IBAction)getValidateCodeAction:(UIButton *)sender {
    self.countDown=60;
    NSString *phoneNum=self.telPhoneNumTxt.text;
    if (![HENLENSONG isValidateMobile:phoneNum]) {
        [MBProgressHUD showError:@"主人，输入的手机号码有错!"];
        return;
    }
    self.getValidateBtn.enabled=NO;
    //倒计时lbl
    UILabel *lbl=[[UILabel alloc]initWithFrame:self.getValidateBtn.bounds];
    lbl.textColor=[UIColor whiteColor];
    lbl.font=[UIFont systemFontOfSize:14];
    lbl.backgroundColor=[UIColor grayColor];
    lbl.textAlignment=NSTextAlignmentCenter;
    [self.getValidateBtn addSubview:lbl];
    self.countDownLbl=lbl;
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Mytimer) userInfo:nil repeats:YES];
    
    [RequestEngine getBindPhoneNumCode:phoneNum completed:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"ME18922"]){

            [MBProgressHUD showError:@"已经绑定三方用户"];
            [self.timer invalidate];
            self.timer=nil;
            [self.countDownLbl removeFromSuperview];
            self.getValidateBtn.enabled=YES;

        }else if ([errorCode isEqualToString:@"ME18059"]){
            self.alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,该手机号已经绑定IMEI号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去重新登录", nil];
            [self.alertView show];
            [self.timer invalidate];
            self.timer=nil;
            [self.countDownLbl removeFromSuperview];
            self.getValidateBtn.enabled=YES;
        }else if([errorCode isEqualToString:@"0"]){

            [MBProgressHUD showSuccess:@"主人验证码已发送!"];
        }else{
            [MBProgressHUD showError:@"主人网络好像不给力啊"];
            [self.timer invalidate];
            self.timer=nil;
            [self.countDownLbl removeFromSuperview];
            self.getValidateBtn.enabled=YES;
        }
        
    }];
}
#pragma alert代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //重新登录
    if (self.alertView==alertView&&buttonIndex==1) {
        NewLoginViewController *loginController=[[NewLoginViewController alloc]initWithNibName:@"NewLoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginController animated:NO];
        self.tabBarController.tabBar.hidden=YES;
    }
}
//定时器函数
-(void)Mytimer{
    --self.countDown;
    if (self.countDown>0) {
        NSString *title=[NSString stringWithFormat:@"重新获取(%ld秒)",(long)self.countDown];
        [self.countDownLbl setText:title];
    }else{
        [self.timer invalidate];
        self.timer=nil;
         [self.countDownLbl removeFromSuperview];
        self.getValidateBtn.enabled=YES;
    }
}

#pragma 解除绑定
- (IBAction)dismissTelPhoneNumAction:(UIButton *)sender {
    NSString *phoneNum=self.telPhoneNumTxt.text;
    NSString *codeTxt=self.validateCOde.text;
    if (![HENLENSONG isValidateMobile:phoneNum]) {
        [MBProgressHUD showError:@"主人，输入的手机号码有错!"];
        return;
    }
    if (codeTxt.length==0&&[codeTxt isEqualToString:@""]) {
        [MBProgressHUD showError:@"主人，没输入验证码噢"];
        return;
    }
    //解除绑定手机号码
    [RequestEngine dismissBindTelPhone:phoneNum validateCode:codeTxt completed:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"0"]){
            [MBProgressHUD showSuccess:@"主人,解绑成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"主人网络不给力啊"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"解除绑定手机号";
    self.telPhoneNumTxt.text=self.phoneNum;
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
