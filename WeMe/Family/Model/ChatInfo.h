//
//  ChatInfo.h
//  微密
//
//  Created by iOS Dev on 14-8-19.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatInfo : NSObject

@property(copy,nonatomic)NSString *uid;

@property(copy,nonatomic)NSString *iMessageType;
//消息类型 0、主动发送 1、对方

//接收的account
@property(copy ,nonatomic)NSString *receiveAccount;

//对方的手机号
@property(copy,nonatomic)NSString  *iAccountType;

//本地IMEI
@property(copy,nonatomic)NSString *phoneImei;

//本地链接地址
@property(copy,nonatomic)NSString *mediaUrl;

//网络链接
@property(copy,nonatomic)NSString *networkUrl;

//创建时间
@property(copy,nonatomic)NSString *createTime;

//音频的长度
@property(copy,nonatomic)NSString *mediaTimeLength;

//接受者的呢称
@property(copy,nonatomic)NSString *receiveNickname;

//发送者的呢称
@property(copy,nonatomic)NSString *locationNickname;

//是否是新消息 0、新  1、老
@property(copy,nonatomic)NSString *nowMessage;

//发送状态  0、已发送 1、正在发送 2、发送失败
@property(copy,nonatomic)NSString *sendStatus;


@end
