//
//  Request1617.h
//  微密
//
//  Created by Daoke Dev on 15/2/28.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UserApplyChannelBLOCK)(int isSuccessBlock);

@interface Request1617 : NSObject


//合约细则
+ (void)getDepositTypeInfoDepositType:(NSString *)depositType complete:(void(^)(NSString * errorCode, NSArray * dictRequest))completed;

//用户通过APP申请微频道/密频道
+ (void)userApplyChannel:(NSString *)channelNumber channelName:(NSString *)channelName channelIntroduction:(NSString *)channelIntroduction channelCityCode:(NSString *)channelCityCode channelCatalog:(NSString *)channelCatalog  chiefAnnouncerIntr:(NSString *)chiefAnnouncerIntr image:(UIImage *)image applyBlock:(UserApplyChannelBLOCK)applyBlock;

//48.修改群聊频道详情
+ (void)modifySecretChannelInfoChannelNumber:(NSString *)channelNumber channelName:(NSString *)channelName channelIntro:(NSString *)channelIntro channelCitycode:(NSString *)channelCitycode channelCatalogID:(NSString *)channelCatalogID channelCatalogUrl:(NSString *)channelCatalogUrl channelOpenType:(NSString *)channelOpenType channelKeyWords:(NSString *)channelKeyWords isVerify:(NSString *)isVerify completed:(void(^)(NSString * errorCode,NSString *result))completed;
//79.获取服务频道列表
+ (void)getServerChannel:(NSString *)startPage pageCount:(NSString *)pageCount longitude:(NSString *)longitude latitude:(NSString *)latitude  completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed;

//80.获取服务频道菜单列表
+ (void)getServerMenuWithserverChannelID:(NSString *)serverChannelID completed:(void(^)(NSString * errorCode,NSArray *resultArr))completed;

//81.获取服务频道消息列表
+ (void)getServerChannel:(NSString *)startPage pageCount:(NSString *)pageCount serverChannelID:(NSString *)serverChannelID completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed;

//48.修改群聊频道详情
+ (void)modifySecretChannelInfo:(NSString *)channelNumber ChannelOpenType:(NSString *)channelOpenType isVerify:(NSString *)isVerify completed:(void(^)(NSString * errorCode,NSString *result))completed;

//禁言或者拉黑
+ (void)manageSecretChannelUsersWithSign:(NSString *)sign infoType:(NSString *)infoType channelNumber:(NSString *)channelNumber curStatus:(NSString *)curStatus userAccountID:(NSString *)userAccountID completed:(void(^)(NSString * errorCode,NSString *result))completed;


//绑定手机号 - 发送验证码
+ (void)sendBindVerifyMessage:(NSString *)mobile times:(NSString *)times completed:(void(^)(NSString * errorCode,NSString *result))completed;

//判断手机号
+ (void)checkMobileRegister:(NSString *)mobile completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed;


//绑定手机号
+ (void)userBindMobile:(NSString *)mobile newmobile:(NSString *)newmobile validateCode:(NSString *)validateCode completed:(void(^)(NSString * errorCode,NSString *result))completed;

//获取版本信息
+ (void)queryUpToDateVersionCompleted:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed;

//获取服务频道列表
+ (void)getCustomDefineInfo:(NSString *)startPage pageCount:(NSString *)pageCount longitude:(NSString *)longitude latitude:(NSString *)latitude defineName:(NSString *)defineName actionType:(NSString *)actionType completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed;

//获取服务频道内容
+ (void)getServiceContent:(NSString *)startPage pageCount:(NSString *)pageCount serverID:(NSString *)serverID  completed:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed;

//存放个人信息
+ (void)putInforInNSUserDefaults:(NSDictionary *)resultDic;


//注册
//+ (void)registeredGetTelephoneVerificationWith:(NSString *)mobile

//流量查询
+ (void)getFlowInfoCompleted:(void(^)(NSString * errorCode,NSDictionary *resultDict))completed;



















@end
