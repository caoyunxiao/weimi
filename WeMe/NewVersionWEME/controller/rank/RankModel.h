//
//  RankModel.h
//  微密
//
//  Created by MacDev on 15/4/16.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankModel : NSObject
@property(nonatomic,copy)NSString * accountID;//用户accountID
@property(nonatomic,copy)NSString * grade;//谢尔值等级
@property(nonatomic,copy)NSString * userHeadName;//头像路径
@property(nonatomic,copy)NSString * nickName;//昵称

@property(nonatomic,copy)NSString * rochelle;//谢尔值
@property(nonatomic,copy)NSString * createDate;//创建日期
@property(nonatomic,copy)NSString * modifyDate;//修改日期
@property(nonatomic,copy)NSString * isValid;
@property(nonatomic,copy)NSString * recordID;

@property(nonatomic,copy)NSString * grede;//error
@property(nonatomic,copy)NSString * title;//幽灵游侠
@property(nonatomic,copy)NSString * itemValue;//加好友上面的 用时
@property(nonatomic,copy)NSString * star;//星级
@property(nonatomic,copy)NSString * gender;//性别
@property(nonatomic,copy)NSString * fromChannel;//来自频道
@property(nonatomic,copy)NSString * fType;//时间
@property (nonatomic,copy)NSString *precent;//击败用户百分比
@property (nonatomic,copy)NSString *distanceTask;
@property (nonatomic,copy)NSString *totalTravelCount;///
@property (nonatomic,copy)NSString *mileageSum;//
@property (nonatomic,copy)NSString *restRule;//
@property (nonatomic,copy)NSString *userArea;
@property (nonatomic,copy)NSString *completedTask;////////
@property (nonatomic,copy)NSString *isAllowedOpinion;//是否允许添加好友(1:是,0:否)
@property (nonatomic,copy)NSString *isVerifyOpinion;//是否需要验证(1:是,0:否)


+(RankModel *)getModelWithDic:(NSDictionary *)dic;
@end
