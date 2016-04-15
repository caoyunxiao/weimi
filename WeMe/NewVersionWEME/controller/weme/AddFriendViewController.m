//
//  AddFriendViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/25.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "AddFriendViewController.h"
#import "MessagePushModel.h"
#import "RequestEngine.h"
#import "PersonInfo.h"
#import "MessagePushModel.h"
@interface AddFriendViewController ()

@end

@implementation AddFriendViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Display Data
    [self _disPlayData];
    
}

- (void) _disPlayData
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:self.pushModel.senderUserHeadName] placeholderImage:[UIImage imageNamed:@"Default"]];
    _friendName.text = self.pushModel.param[@"accountNickName"];
    _addRess.text = self.pushModel.param[@"userArea"];
    _message.text = self.pushModel.param[@"verifyMessage"];
    
    if ([self.pushModel.param[@"gender"] integerValue] == 1) {
        
        [self.sexImage setImage:[UIImage imageNamed:@"boy.png"]];
        
    }else{
        
        [self.sexImage setImage:[UIImage imageNamed:@"girl.png"]];
        
    }
    if([self.pushModel.isAgree isEqualToString:@"1"]){
        
        self.refuseButton.hidden = YES;
        self.agreeButton.hidden = YES;
        self.resultButton.hidden = NO;
    }
}


//接收
- (IBAction)agreeButton:(UIButton *)sender
{
    /*
     accountID	用户帐户ID
     accountNickName	用户昵称
     friendAccountID	好友ID
     gender	性别
     */
    if ([self.pushModel.messageType isEqualToString:@"addFriend"])
    {
        PersonInfo *info = [PersonInfo sharePersonInfo];
        NSString *accountID = info.accountIDString;//获取用户的accountID
        NSString *friendAccountID = self.pushModel.senderAccountID;
        NSInteger gender = [self.pushModel.param[@"gender"] integerValue];
        NSString *nickName = self.pushModel.param[@"accountNickName"];
        
        [RequestEngine agreeAddFriend:@{@"accountID":accountID,@"accountNickName":nickName,@"friendAccountID":friendAccountID,@"gender":@(gender),@"messageID":self.pushModel.messageID}  completed:^(NSString *errorCode, NSDictionary *resultDic) {
            if ([errorCode isEqualToString:@"0"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
   else if ([self.pushModel.messageType isEqualToString:@"joinSecretChannel"]) {
       PersonInfo *info = [PersonInfo sharePersonInfo];
       NSString *accountID = info.accountIDString;//获取用户的accountID
       NSString *friendAccountID = self.pushModel.senderAccountID;
       NSString *nickName = self.pushModel.param[@"accountNickName"];
       NSString *applyldx = self.pushModel.param[@"applyIdx"];
       NSString *channeName = self.pushModel.param[@"channelName"];
       NSString *messageID = self.pushModel.messageID;
        //处理加入群频道的
       [RequestEngine agreeOrRefuseJoinChannel:@{@"appKey":@"iOS",@"accountID":accountID,@"applyAccountID":friendAccountID,@"checkStatus":@"1",@"applyIdx":applyldx,@"accountNickName":nickName,@"channelName":channeName,@"messageID":messageID,@"messageID":self.pushModel.messageID}completed:^(NSString *errorCode) {
           if ([errorCode isEqualToString:@"0"])
           {
               [self.navigationController popToRootViewControllerAnimated:YES];
           }else{
               [self.navigationController popToRootViewControllerAnimated:YES];
           }
           
       }];
    }
}

- (IBAction)refuse:(UIButton *)sender{//拒绝
    PersonInfo *info = [PersonInfo sharePersonInfo];
    NSString *accountID = info.accountIDString;//获取用户的accountID
    NSString *friendAccountID = self.pushModel.senderAccountID;
    NSString *nickName = self.pushModel.param[@"accountNickName"];
    
    /*
     
     accountNickName	用户昵称
     friendAccountID	好友ID
     accountID	用户ID
     
     */
    if ([self.pushModel.messageType isEqualToString:@"addFriend"]) {
        
        [RequestEngine noAgreeAddFriend:@{@"accountNickName":nickName,@"friendAccountID":friendAccountID,@"accountID":accountID,@"messageID":self.pushModel.messageID} completed:^(NSString *errorCode, NSDictionary *resultDic) {
            if ([errorCode isEqualToString:@"0"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else if ([self.pushModel.messageType isEqualToString:@"joinSecretChannel"])
    {
        //处理加入群频道的
        PersonInfo *info = [PersonInfo sharePersonInfo];
        NSString *accountID = info.accountIDString;//获取用户的accountID
        NSString *friendAccountID = self.pushModel.senderAccountID;
        NSString *nickName = self.pushModel.param[@"accountNickName"];
        NSString *applyldx = self.pushModel.param[@"applyIdx"];
        NSString *channeName = self.pushModel.param[@"channelName"];
        NSString *messageID = self.pushModel.messageID;

        //处理加入群频道的
        [RequestEngine agreeOrRefuseJoinChannel:@{@"appKey":@"iOS",@"accountID":accountID,@"applyAccountID":friendAccountID,@"checkStatus":@"2",@"applyIdx":applyldx,@"accountNickName":nickName,@"channelName":channeName,@"messageID":messageID,@"messageID":self.pushModel.messageID} completed:^(NSString *errorCode) {
            if ([errorCode isEqualToString:@"0"])
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
}
- (void)didReceiveMemoryWarning
{
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
