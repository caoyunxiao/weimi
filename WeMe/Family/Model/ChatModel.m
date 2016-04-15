//
//  ChatModel.m
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ChatModel.h"
#import "HTTPManger.h"
#import "ChatInfo.h"
#import "SUserDB.h"
#import "HTTPPostManger.h"


@implementation ChatModel

#pragma mark --
#pragma mark -- 发送消息

- (void)upVoice:(NSString *)fileNameString isChat:(ChatBlock)isChat
{
    FamilyInfo *info = [FamilyInfo shareFamilyInfo];
    
    NSString *receiceID = info.receiceID;
    
    //int parameterType = info.parameterType;
    int parameterType;
    
    if ([receiceID length] == 15)
    {
        parameterType = 3;
    }else
    {
        parameterType = 2;
    }
    
    NSString *uuidString = info.uuidString;
    
    
    [HTTPPostManger requestWithURL:LOGINURL(@"appConnectSendWeibo.do") accountID:receiceID parameterType:parameterType phoneImei:uuidString fileName:fileNameString finish:^(NSData *data)
    {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
        {
            if (isChat)
            {
                isChat(0);
            }
        }
        else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18091"])
        {
            if (isChat)
            {
                isChat(1);
            }
        }
        else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18068"])
        {
            if (isChat)
            {
                isChat(2);
            }
        }else if([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"ME18006"])
        {
            if (isChat)
            {
                isChat(3);
            }
        }else
        {
            if (isChat)
            {
                isChat(4);
            }
        }
        
    } Failed:^(NSError *error)
     {
         if (isChat)
         {
             isChat(5);
         }

    }];
    
}

#pragma mark -- 
#pragma mark -- 获取连线消息

- (void)getChatMessage:(GetChatMessageBlock)messageBlock
{
    SUserDB *userDB = [[SUserDB alloc]init];
    
    NSString *recvAccountID = [FamilyInfo shareFamilyInfo].accountID;
    
    NSMutableArray *chatArray = [[NSMutableArray alloc]init];
    
    NSString *bodyString = [NSString stringWithFormat:@"phoneImei=%@&accountID=%@",[FamilyInfo shareFamilyInfo].uuidString,recvAccountID];
    
    NSString *urlString =[NSString stringWithFormat:@"%@?%@",LOGINURL(@"getConnMessages.do"),bodyString];
    
    [HTTPManger requestWithURL:urlString Finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
        {
            NSArray *array = [dict objectForKey:@"RESULT"];
            NSUInteger aCount = [array count];
            
            for (int i = 0; i < aCount; i++)
            {
                NSDictionary *aDict = [array objectAtIndex:i];
                
                ChatInfo *info = [[ChatInfo alloc]init];
                info.iMessageType = @"1";
                info.iAccountType = @"2";
                info.mediaTimeLength = [aDict objectForKey:@"fileDuration"];
                info.networkUrl = [aDict objectForKey:@"fileURL"];
                info.receiveNickname = [aDict objectForKey:@"nickName"];
                info.phoneImei = [aDict objectForKey:@"phoneImei"];
                info.nowMessage = @"0";
                info.createTime = [NSString currentDetailDate];
                info.receiveAccount = [FamilyInfo shareFamilyInfo].receiceID;
                [chatArray addObject:info];
                
                [userDB addUser:info];
                
            }
            if (messageBlock)
            {
                messageBlock(chatArray);
            }
        }else
        {
            if (messageBlock)
            {
                messageBlock(chatArray);
            }
        }
        
    } Failed:^(NSError *error)
    {
        if (messageBlock)
        {
            messageBlock(chatArray);
        }
    }];
}

#pragma mark -- 判断是否连线连线

- (void)validationConnection:(NSString *)receiveID phoneImei:(NSString *)phoneImei isConnection:(ValidationConnectionBlock)isConnection
{
    NSString *bodyString = [NSString stringWithFormat:@"accountID=%@&phoneImei=%@",receiveID,phoneImei];
    
    [HTTPPostManger requestWithURL:LOGINURL(@"isConnect.do") bodyString:bodyString finish:^(NSData *data)
     {
         
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         if ([[dict objectForKey:@"ERRORCODE"]isEqualToString:@"0"])
         {
             int station = [[dict objectForKey:@"RESULT"] intValue];
             
             BOOL isSuccess = YES;
             
             if (station == 0)
             {
                 isSuccess = NO;
             }
             
             if (isConnection)
             {
                 isConnection(isSuccess);
             }
         }
         else
         {
             if (isConnection)
             {
                 isConnection(NO);
             }
         }
     } Failed:^(NSError *error)
    {
         if (isConnection)
         {
             isConnection(NO);
         }
     }];
    
}


@end
