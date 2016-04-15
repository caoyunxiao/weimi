//
//  RecordsModel.h
//  微密
//
//  Created by wemeDev on 15/5/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordsModel : NSObject

@property (nonatomic,copy) NSString *msgid;//消息唯一ID
@property (nonatomic,copy) NSString *touser;//接受者accountid
@property (nonatomic,copy) NSString *fromuser;//发送者accountid
@property (nonatomic,copy) NSString *channel;//服务频道号
@property (nonatomic,copy) NSString *createtime;//消息发送时间
@property (nonatomic,copy) NSString *msgtype;//消息类型
@property (nonatomic,copy) NSDictionary *text;//文本消息
@property (nonatomic,copy) NSDictionary *image;//图片消息
@property (nonatomic,copy) NSDictionary *voice;//voice
@property (nonatomic,copy) NSDictionary *video;//视频消息
@property (nonatomic,copy) NSDictionary *news;//图文消息

@property (nonatomic,copy) NSDictionary *media_url;
@property (nonatomic,copy) NSDictionary *thumb_media_url;
@property (nonatomic,copy) NSDictionary *title;
@property (nonatomic,copy) NSDictionary *descriptionDict;
@property (nonatomic,copy) NSDictionary *url;
@property (nonatomic,copy) NSDictionary *picurl;




@end
