//
//  FriendModel.h
//  微密
//
//  Created by MacDev on 15/4/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
@property(nonatomic,copy)NSString * icon;//好友头像
@property(nonatomic,copy)NSString * name;//好友名称
@property(nonatomic,copy)NSString * area;//地区
@property(nonatomic,copy)NSString * sex;//性别

@property(nonatomic,copy)NSString * intro;//简介
@property(nonatomic,copy)NSString * acquaintance;//相熟度
@property(nonatomic,copy)NSString * isAllowAdd;//是否允许被添加为好友
@property(nonatomic,copy)NSString * isAllowRecommend;//是否允许被推荐
@property(nonatomic,copy)NSString * isNeedTest;//添加我为好友是否需要验证
@property(nonatomic,copy)NSString * isAllowOnLineNotify;//是否允许收到好友上线提醒
+(FriendModel *)getModelWithDic:(NSDictionary *)dic;
@end
