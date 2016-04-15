//
//  WMChannelInfo.h
//  微密
//
//  Created by MacDev on 15/3/2.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMChannelInfo : NSObject
@property(copy,nonatomic)NSString *accountID;

@property(copy,nonatomic)NSString *catalogID;

@property(copy,nonatomic)NSString *catalogName;

@property(copy,nonatomic)NSString *channelType;

//主播介绍
@property(copy,nonatomic)NSString *chiefAnnouncerIntr;

@property(copy,nonatomic)NSString *cityCode;

@property(copy,nonatomic)NSString *cityName;

@property(copy,nonatomic)NSString *createTime;

@property(copy,nonatomic)NSString *idx;

@property(copy,nonatomic)NSString *logoURL;

//频道介绍
@property(copy,nonatomic)NSString *introduction;

//频道号
@property(copy,nonatomic)NSString *number;

//名称
@property(copy,nonatomic)NSString *name;

//邀请码
@property(copy,nonatomic)NSString *inviteUniqueCode;

@property(copy,nonatomic)NSString *checkStatus;

@property(copy,nonatomic)NSString *tableInfo;

@property(copy,nonatomic)NSString *remark;

+(WMChannelInfo *)getChannelInfoWithDic:(NSDictionary *)dic;
@end
