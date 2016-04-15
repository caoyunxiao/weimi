//
//  TestViewController.m
//  微密
//
//  Created by MacDev on 15/4/15.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TestViewController.h"
#import "RequestEngine.h"
@interface TestViewController ()<UITextViewDelegate>
{
    NSString * _sendText;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"验证信息";
    [self addNavigationItem];  
}
- (void)addNavigationItem
{
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 60, 45)];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 60, 45)];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
//    self.message.text=[NSString stringWithFormat:@"主人，您正在申请加入 %@ (可自行编辑哦)",_model.name];
    
}
#pragma mark - 取消
- (void)goBack
{
   [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 发送好友请求
- (void)sendMessage
{
     [self.message resignFirstResponder];
    if(self.message.text.length>0)
    {
        if (_isFriend)
        {
            NSString * nickName = _model.nickName.length==0?@"":_model.nickName;
            NSString * gender = _model.gender==nil?@"1":_model.gender;
            NSString * area = _model.userArea.length==0?@"":_model.userArea;
            NSDictionary *dict = @{@"msgContent":self.message.text,@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"friendAccountID":_model.accountID,@"friendNickName":nickName,@"gender":gender,@"userArea":area};
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RequestEngine addFriends:dict completed:^(NSString *errorCode, NSString *result) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if([errorCode isEqualToString:@"0"])
                {
                    Alert(@"主人,你的好友申请已发送了哦");
                    [self.view endEditing:YES];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                else if([errorCode isEqualToString:@"ME01001"]){
                    Alert(result);
                }
                else{
                    Alert(@"主人,你的好友申请发送失败了,再试试吧");
                }
            }];
        }
        else
        {

            NSString * channelName = _model.name.length==0?@"":_model.name;
            NSString * applyIndx = self.applyIdx==0?@"1":self.applyIdx;
            NSString * nickName = _model.adminName.length==0?@"微密":_model.adminName;
            NSString * gender = _model.gender.length==0?@"1":_model.gender;
            NSString * userAres = _model.userArea.length==0?@"上海":_model.userArea;
            NSString *accountId=_model.accountID.length==0?@"":_model.accountID;

            NSDictionary *dict = @{@"msgContent":self.message.text,@"channelName":channelName,@"accountNickName":[PersonInfo sharePersonInfo].nicknameString,@"adminAccountID":accountId,@"applyAccountID":[PersonInfo sharePersonInfo].accountIDString,@"applyIdx":applyIndx,@"adminAccountNickName":nickName,@"gender":gender,@"userArea":userAres};
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [RequestEngine pushJoinSecretChannelMessageWithDic:dict completed:^(NSString *errorCode) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([errorCode isEqualToString:@"0"])
                {
                    Alert(@"主人,验证信息发送成功啦");
                    [self.view endEditing:YES];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                    [self.navigationController popToViewController:self.vc animated:YES];
                    [self.message resignFirstResponder];
                }
                else
                {
                    Alert(@"主人,验证信息发送失败,稍后再试试哟");

                }
            }];
        }
    }
    else
    {
        Alert(@"主人,请输入验证信息哟");
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _sendText = textView.text;
    //NSLog(@"___%@",textView.text);
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
     //NSLog(@"___%@",textView.text);
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.message resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self.message resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end