//
//  newInputViewController.m
//  微密
//
//  Created by wemeDev on 15/5/21.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "newInputViewController.h"

@interface newInputViewController ()

@end

@implementation newInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationItem];
}
#pragma mark - 添加navigationItem
- (void)addNavigationItem
{
    [self.inputTextField becomeFirstResponder];
    self.title = self.twoTitleLable;
    self.inputTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.inputTextField.layer.borderWidth = 1.0;
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
}
#pragma mark - 完成
- (void)complete
{
    [self.view endEditing:YES];
    if([self.twoTitleLable isEqualToString:@"频道名"])
    {
        if(self.inputTextField.text.length==0)
        {
            Alert(@"主人,频道名不能为空哦");
            return;
        }
        if(self.inputTextField.text.length>15)
        {
            Alert(@"主人,频道名不能超过15个字符哦");
            return;
        }
    }
    else if([self.twoTitleLable isEqualToString:@"关键字"])
    {
        if(self.inputTextField.text.length==0)
        {
            Alert(@"主人,关键字不能为空哦");
            return;
        }
        if(self.inputTextField.text.length>4)
        {
            Alert(@"主人,关键字不能超过4个字符哦");
            return;
        }
    }
    else if([self.twoTitleLable isEqualToString:@"简介"])
    {
        if(self.inputTextField.text.length==0)
        {
            Alert(@"主人,简介不能为空哦");
            return;
        }
        if(self.inputTextField.text.length>20)
        {
            Alert(@"主人,简介不能超过20个字符哦");
            return;
        }
    }
    NSDictionary * dict = @{@"inputTextField":self.inputTextField.text,@"twoTitleLable":self.twoTitleLable};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newInputViewController" object:nil userInfo:dict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation.

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
