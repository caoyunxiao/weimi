//
//  MessagePushModel.h
//  微密
//
//  Created by mirrtalk on 15/5/22.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MessagePushModel : NSObject



@property (nonatomic,copy) NSString *msgTitle;//消息标题
@property (nonatomic,copy) NSString *content;//消息内容（推送消息）
@property (nonatomic,copy) NSString *senderUserHeadName;//消息头像
@property (nonatomic,copy) NSString *messageType;//消息类型
@property (nonatomic,assign) NSInteger createTime;//时间戳
@property (nonatomic,strong) NSDictionary *param;//验证消息
@property (nonatomic,copy) NSString *senderAccountID;//添加你为好友的ID
@property (nonatomic,copy) NSString *messageID;//消息的ID
@property (nonatomic,assign) NSInteger isRead;//标注消息
@property (nonatomic,copy) NSString *messageContent;//聊天内容
@property (nonatomic,copy) NSString *isAgree;//判断申请消息是否已经处理

@end
