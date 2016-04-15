//
//  TerminateViewController.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "TerminateViewController.h"
#import "MobClick.h"

@interface TerminateViewController ()
{
    ModelView *_modelView;
}
@end

@implementation TerminateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uiConfig];
    _textFieldArray = [[NSArray alloc] init];
    _textFieldArray = @[_complanyTextFeild,_oldNumberTextFeild];
    [self.myButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"]forState:UIControlStateHighlighted];
    [self changeTextUIReturnKeyAndDelegate:_textFieldArray];
}

#pragma mark -- 初始化视图
- (void)uiConfig
{
    self.title = @"退货解约";
    
    self.terminateScrollView.frame = [UIScreen mainScreen].bounds;
    self.terminateScrollView.contentSize = CGSizeMake(320, 588);
    self.terminateScrollView.showsVerticalScrollIndicator = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cashPwdChange:(id)sender {
    
    //[self judgeIsEnable];
    
}

- (IBAction)companyChange:(id)sender {
    //[self judgeIsEnable];
}

- (IBAction)expressageChange:(id)sender {
    //[self judgeIsEnable];
}

#pragma mark - 退货解约
- (IBAction)myButton:(UIButton *)sender
{
    if([self judgeIsEnable])
    {
        if (_modelView == nil) {
            _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
        }
        [self.view addSubview:_modelView];
        [RequestEngine applyCancelContractWithDepositPassword:@"" expressNumber:self.complanyTextFeild.text expressCompany:self.oldNumberTextFeild.text completed:^(NSString *errorCode) {
            [_modelView removeFromSuperview];
            NSInteger isCancel = [errorCode integerValue];
            NSString *massage;
            if (isCancel == 0)
            {
                massage = @"主人,解约成功了哦";
            }else if (isCancel == 1)
            {
                massage = @"主人,你还没有提现帐户啊";
            }
//            else if (isCancel == 2)
//            {
//                massage = @"主人,没有押金密码哦";
//            }
//            else if (isCancel == 3)
//            {
//                massage = @"主人,你输入的押金密码有误哦";
//            }
            else if (isCancel == 4)
            {
                massage = @"主人,你没有支付押金哟";
            }
            else if (isCancel == 5)
            {
                massage = @"主人,网络不给力啊,请检查一下网络吧";
            }else if (isCancel == 7)
            {
                massage = @"主人,该设备不允许退货解约哦";
            }else
            {
                massage = @"主人,网络好像不给力啊,检查一下网络吧";
            }
            Alert(massage);
        }];
    }
    else
    {
        Alert(@"主人,退货信息不能为空哟");
    }
}

- (BOOL)judgeIsEnable
{
//    NSString *cashString = self.passworldTextFeild.text;
    NSString *companyString = self.complanyTextFeild.text;
    NSString *exString = self.oldNumberTextFeild.text;
    if (companyString.length==0||exString.length==0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    if([_textFieldArray indexOfObject:textField]!=NSNotFound)
    {
        NSInteger index = [_textFieldArray indexOfObject:textField];
        [textField resignFirstResponder];
        if((index+1)==_textFieldArray.count)
        {
            [self.view endEditing:YES];
        }
        else
        {
            UITextField *textNext = [_textFieldArray objectAtIndex:index+1];
            [textNext becomeFirstResponder];
        }
    }
    else
    {
        [self.view endEditing:YES];
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];//友盟统计
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];//友盟统计
}








@end
