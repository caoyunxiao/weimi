//
//  NewChannelModel.h
//  微密
//
//  Created by MacDev on 15/4/21.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewChannelModel : NSObject
@property(nonatomic,copy)NSString * channelNumber;//频道编号 9/10位
@property(nonatomic,copy)NSString * channelName;//频道名称  长度大于2 最大长度16，可以是汉字
@property(nonatomic,copy)NSString * name;//频道名
@property(nonatomic,copy)NSString * catalogID;//频道类别编码
@property(nonatomic,copy)NSString * cityCode;//频道区域编码

@property(nonatomic,copy)NSString * capacity;//频道最大人数
@property(nonatomic,copy)NSString * introduction;//频道简介
@property(nonatomic,copy)NSString * logoURL;//图片的地址
@property(nonatomic,copy)NSString * number;//频道编号
@property(nonatomic,copy)NSString * InviteUniqueCode;//邀请码
@property(nonatomic,copy)NSString * cityName;//城市名
@property(nonatomic,copy)NSString * catalogName;//类别名称chu 频道类别编号
@property(nonatomic,copy)NSString * createTime;//创建时间
@property(nonatomic,copy)NSString * openType;//密频道类型 1开放 0非开放@end
@property(nonatomic,copy)NSString * isJoined;//是否加入

@property(nonatomic,copy)NSString * bindKey;//是否有关联键

@property(nonatomic,copy)NSString * isVerity;//是否校验、、、、、、
@property(nonatomic,copy)NSString *  channelCityCode;
@property(nonatomic,copy)NSString * chiefAnnouncerIntr;//主播简介

@property(nonatomic,copy)NSString * channelKeyWords;//关键字
@property(nonatomic,copy)NSString * userCount;//频道用户总数
@property(nonatomic,copy)NSString * onlineCount;//频道在线用户数
@property(nonatomic,copy)NSString * keyWords;//频道关键字
@property(nonatomic,copy)NSString * adminName;//管理员名称
@property(nonatomic,copy)NSString * channelCatalogID;//平道类别编号
@property(nonatomic,copy)NSString * online;//是否在线
@property(nonatomic,copy)NSString * talkStatus;//用户状态 1正常 2禁言 3剔除
@property(nonatomic,copy)NSString * role;//身份 0普通成员 1创建者 2管理员


@property (nonatomic,copy) NSString *accountID;
@property (nonatomic,copy) NSString *isAllowedOpinion;//是否允许添加为好友 1:允许 0:不允许
@property (nonatomic,copy) NSString *isFriend;
@property (nonatomic,copy) NSString *isVerifyOpinion;//被添加为好友是否需要验证
@property (nonatomic,copy) NSString *nickName;//昵称
@property (nonatomic,copy) NSString *nickname;//昵称
@property (nonatomic,copy) NSString *userHeadName;//用户头像
@property (nonatomic,copy) NSString *channelStatus;
@property (nonatomic,copy) NSString *chiefAnnouncerName;
@property (nonatomic,copy) NSString *idx;
@property (nonatomic,copy) NSString *validity;
@property(nonatomic,assign)NSInteger  isWeMeAccount;//是否是微密用户 1是0不是
@property(nonatomic,copy)NSString * mobile;//手机号
@property(nonatomic,copy)NSString * gender;//性别  1:男 2:女
@property(nonatomic,copy)NSString * phoneName;//手机通讯录里地名字
@property(nonatomic,copy)NSString * userAreaCode;
@property(nonatomic,copy)NSString * applyIdx;
@property(nonatomic,copy)NSString * isVerify;

@property(nonatomic,copy)NSString * userArea;


+(NewChannelModel *)getModelWithDic:(NSDictionary *)dic;
@end