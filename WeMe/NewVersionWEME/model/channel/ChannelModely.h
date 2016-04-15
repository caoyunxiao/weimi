//
//  ChannelModely.h
//  微密
//
//  Created by MacDev on 15/4/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelModely : NSObject
@property(nonatomic,copy)NSString * channelIntro;//频道简介
@property(nonatomic,assign)NSInteger onLineMembers;//频道中在线人数
@property(nonatomic,assign)NSInteger  totalMembers
;//频道中的总人数
@property(nonatomic,copy)NSString * hostSpreadName;//主播名
@property(nonatomic,copy)NSString * channelName;//频道名称
@property(nonatomic,assign)NSInteger  channelID;//Id
@property(nonatomic,copy)NSString * area;//地区
@property(nonatomic,copy)NSString * category;//类别---吃喝玩乐
@property(nonatomic,copy)NSString * photoUrl;//头像url
@property(nonatomic,copy)NSString * isCollected;//是否被收藏,1为已被收藏,  0为未被收藏
@property(nonatomic,copy)NSString * channelNum;//频道号码
@property(nonatomic,copy)NSString * keyWords;//关键字
@property(nonatomic,copy)NSString * twoDimensionCode;//二维码
@property(nonatomic,copy)NSString * adminPosition;//管理员职位
@property(nonatomic,copy)NSString * adminName;//管理员名称
@property(nonatomic,copy)NSString * adminSex;//管理员性别
@property(nonatomic,copy)NSString * adminArea;//管理员所在区域
@property(nonatomic,copy)NSString * adminPhoto;//管理员头像
@property(nonatomic,copy)NSString * adminNickname;//管理员昵称
@property(nonatomic,copy)NSString * adminIsFriend;//管理员是否为好友
@property(nonatomic,copy)NSString * isFollow;//是否被关注
@property(nonatomic,copy)NSString * isPublic;//是否对外公开,1为对外公开,0不对外公开
@property(nonatomic,copy)NSString * isNeedTest;//是否需要验证,1为需要验证,0为不需要验证
@property(nonatomic,copy)NSString * hostSpreadIntro;//主播简介
@property(nonatomic,copy)NSString * channelLogo;//频道logo



+(ChannelModely *)getModelWithDic:(NSDictionary*)dic;
@end
