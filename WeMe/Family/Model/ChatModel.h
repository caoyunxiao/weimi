//
//  ChatModel.h
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ChatBlock)(int isChat);


typedef void(^GetChatMessageBlock)(NSMutableArray *array);


typedef void(^ValidationConnectionBlock)(BOOL isConnection);



@interface ChatModel : NSObject


- (void)upVoice:(NSString *)fileNameString isChat:(ChatBlock)isChat;


- (void)getChatMessage:(GetChatMessageBlock)messageBlock;

- (void)validationConnection:(NSString *)receiveID phoneImei:(NSString *)phoneImei isConnection:(ValidationConnectionBlock)isConnection;



@end
