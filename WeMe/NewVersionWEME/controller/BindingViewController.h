//
//  BindingViewController.h
//  微密
//
//  Created by wemeDev on 15/6/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"

@interface BindingViewController : BasesViewController{
    
    NSTimer *_myTimer;
    int _iTimer;
    UIAlertView *_alert;
    BOOL _isHavePassWord;
    NSString *_oldNum;//旧的电话号码
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;//手机号
@property (weak, nonatomic) IBOutlet UITextField *VerificationCode;//验证码输入框
- (IBAction)getVerificationCode:(UIButton *)sender;//获取验证码
- (IBAction)BindingButton:(UIButton *)sender;//绑定
@property (weak, nonatomic) IBOutlet UIButton *getVerificationCode;//获取验证码
@property (weak, nonatomic) IBOutlet UILabel *tiShiLabel;//显示时间的label
@property (weak, nonatomic) IBOutlet UILabel *topLabel;//顶部提示label
@property (weak, nonatomic) IBOutlet UIButton *bigButton;//绑定button
@property (weak, nonatomic) IBOutlet UITextField *passWord;//密码
@property (weak, nonatomic) IBOutlet UITextField *surePassWord;//确认密码

//电话号码输入框发生变化
- (IBAction)phoneNumberTextFeild:(UITextField *)sender;

@property (nonatomic,copy) NSString *oldPhoneNumber;
@property (nonatomic,copy) NSString *passwordTextFeild;
@property (nonatomic,copy) NSString *isShowTiaoGuo;

@end
