//
//  LoginViewController.h
//  微密
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginBlock)(BOOL finshed);

@interface NewLoginViewController : UIViewController<UITextFieldDelegate>
{
    UINavigationController *_wxNav;
    NSString *_city;
    NSString *_country;
    NSString *_headimgurl;
    NSString *_nickname;
    NSString *_province;
    NSString *_sex;
    NSString *_openid;
}

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *nameTextFeild;//用户名
@property (strong, nonatomic) IBOutlet UITextField *passwordTextFeild;//密码
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property(copy,nonatomic) LoginBlock loginStartBlock;
@property(assign,nonatomic) BOOL isFirstLoad;

- (IBAction)loginButtonClick:(id)sender;
- (IBAction)registerButtonClick:(id)sender;
- (IBAction)dismissPsdButtonClick:(id)sender;
- (IBAction)nameChanage:(id)sender;
- (IBAction)pwdChanage:(id)sender;
- (IBAction)HiddenKeyClick:(UIButton *)sender;
- (IBAction)weiXinLogIn:(UIButton *)sender;
- (IBAction)jiaRenLogIn:(UIButton *)sender;

@property (nonatomic,copy) NSString *isJiaRenLine;


@end
