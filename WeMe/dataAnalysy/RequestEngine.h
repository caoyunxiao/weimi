//
//  RequestEngine.h
//  DemoText
//
//  Created by MacDev on 14/12/25.
//  Copyright (c) 2014年 MacDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewChannelModel.h"
#import "NewWModel.h"
#import "ChannelModely.h"
#import "listModel.h"
#import "RankModel.h"
#import "MoreModely.h"

@interface RequestEngine : NSObject

////20,验证微密的合法性
+(void)getWeMeModelWithIMEIStr:(NSString *)imeiStr complete:(void(^)(NewWModel * model,NSString * errorCode))completed;

/////21,绑定微密
+(void)getWeMeBindWithIMEIStr:(NSString *)imeiStr complete:(void(^)(NSString * errorCode))completed;

/////22,判断微密是否设置押金密码
+(void)judgeWeMeHasSereat:(void(^)(NSString* hasPassword,NSString * errorCode))completed;

/////23,接触绑定微密
+(void)disconnestWithWeMe:(void(^)(NSString * errorCode))completed;

////25,获取IMEI手机号
+(void)getIMEIAndPhone:(void(^)(NSString *imeiStr,NSString *phoneStr,NSString *errorCode))completed;

//////+27登录请求函数
+(void)LoginWithName:(NSString *)name psw:(NSString *)pswd complete:(void(^)(NSInteger  fSucceed))completed;

//////+28注册发送验证码
+(void)registerWithPhoneNumber:(NSString *)phone times:(NSString *)times complete:(void(^)(NSString * errorCode, NSString * regCode))completed;

/////+29设置个人信息完整注册
+(void)finishedRegisterWithDic:(NSDictionary *)dic complete:(void(^)(NSString * errorCode, NSString * strFinsed))completed;

////+32得到功能设置列表
+(void)getFunctionList:(void(^)(NSString * errorCode,NSArray * dataArray))completed;


/////+33保存功能设置订阅
+(void)saveNewsListWithStr:(NSString *)bodayStr complete:(void(^)(NSString * errorCode))completed;

////+34修改密码
+(void)updatePasswordWithOldPsw:(NSString *)oldPsw newPsw:(NSString *)newPsw complete:(void(^)(NSString * errorCode))completed;

////+341轨迹
+(void)updateRoutePathWithStr:(NSDictionary *)str complete:(void(^)(NSString * errorCode,NSArray * dateArray))completed;

/////+44榜单首页接口
+(void)getList:(void(^)(NSString * errorCode,listModel *model))completed;

////+45全国排名和本月排名接口
//+(void)getRankListWithUrl:(NSString *)url complete:(void(^)(NSString * errorCode,NSMutableArray *dataArray))completed;
+(void)getRankListWithUrl:(NSString *)url complete:(void(^)(NSString * errorCode,NSString *rankRuleText,RankModel *model,NSMutableArray *dataArray))completed;

/////新的频道接口

///1获取用户按键自定义接口
///2查询我关注的主播频道列表
+(void)getUserFollowListMicroChannel:(NSInteger)startPage pageCount:(NSInteger)pageCount completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray))completed;

///+3根据频道名称,号码,管理员,所在地区查询群聊频道
+(void)fetchSecretChannelWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray,NSDictionary *resultDict))completed;

///+4获取频道类别列表
+(void)getCatalogInfoWithType:(NSString *)channelType startPg:(NSInteger)startPg pageSize:(NSInteger)pageSize completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray,NSDictionary *result))completed;

///上传头像图片
+(void)uploadImageWithImage:(UIImage *)image completed:(void(^)(NSString * errorCode,NSString *result))completed;

+(void)uploadImageWithImage:(UIImage *)inage imageType:(NSString *)opertaionType channel:(NewChannelModel *)model completed:(void(^)(NSString * errorCode,NSDictionary *result))completed;
////+28 得到群聊频道详情
+(void)getSecretChannelInfoWithChannelNumber:(NSString *)channelNumber completed:(void(^)(NSString * errorCode,NewChannelModel * model))completed;
/////+29 申请加入群聊频道
+(void)joinSecretChannelWithCode:(NSString *)uniqueCode completed:(void(^)(NSString * errorCode,NSString *isVerify,NSString * applyIdx))completed;

/////+38关注,取消关注 followType;1关注2，取消关注(主播频道)
+(void)followMicroChannelWithChannelNum:(NSString *)channelNumber uniqueCode:(NSString *)uniqueCode type:(NSString *)followType completed:(void(^)(NSString * errorCode))completed;
/////+30 用户退出群聊频道
+(void)quitSecretChannelWithNumber:(NSString *)channelNumber channelName:(NSString *)channelName completed:(void(^)(NSString * errorCode))completed;
///+31 获取群聊频道的用户列表
+(void)getUserJoinListWithChannelNum:(NSString *)channelNum type:(NSString *)infoType starPage:(NSString *)startPage completed:(void(^)(NSString * errorCode,NSMutableArray * dataArr))completed;

////+42 主播频道列表
+ (void) getAnchorList:(NSDictionary *) dict completed:(void(^)(NSString * errorCode,NSMutableArray *dataArray,NSDictionary *resultDict))completed;

////59 好友设置
+ (void) friendsSetting:(NSDictionary *) dict completed:(void(^)(NSString * errorCode))completed;


///55.添加好友
+ (void) addFriends:(NSDictionary *)dict completed:(void(^)(NSString * errorCode,NSString *result))completed;

//根据频道编码获取主播频道详情信息
+ (void)getDetailsOfChannelInfors:(NSString *)channelNumber completed:(void(^)(NSString * errorCode,NSArray *resultArr))completed;

////61 .根据通讯录判断是否是微密用户

+(void)judgeIsWeMeAccountWithMobiles:(NSMutableArray *)mobilesArr completed:(void(^)(NSString * errorCode,NSMutableArray *modelArr))completed;


//44主播查询本频道所有关注用户列表
+ (void)getBossFollowListMicroChannel:(NSString *)channelNumber startPage:(NSString *)startPage pageCount:(NSString *)pageCount completed:(void(^)(NSString * errorCode,NSArray *resultArr))completed;

////63 获取我的好友
+(void)queryUserFriendWithstartPage:(NSString *)startPage pageCount:(NSString *)pageCount completed:(void(^)(NSString * errorCode,NSMutableArray *modelArr))completed;
//指数榜单详情
+(void)getUserRankInfoWithRankType:(NSString *)rankType complete:(void(^)(NSString * errorCode,NSString *rankRuleText,RankModel *model,NSMutableArray *dataArray))completed;
////60 聊天推送
+(void)talkPushMessageWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed;

///user/v1.0/mobileRewardRochelle  领取谢尔值 64
+(void)getRochelleWithRewardID:(NSString *)rewardID completed:(void(^)(NSString * errorCode))completed;

//谢尔值详情页面
+(void)getUserTaskInfoWithtaskInfoType:(NSString *)taskInfoType complete:(void (^)(NSString * errorcode,NSString *resultInfo, NSArray *dataArr))completed;//errorcode,resultInfo,dataArr
//66榜单配置页
+(void)getRankCofig:(void (^)(NSString * errorcode,NSArray *rankCofigArray))completed;
// 67 68 全部排名 本月排名
+(void)getRankListInfoByShellWithUrl:(NSString *)url complete:(void (^)(NSString * errorcode,NSArray *rankArray, NSDictionary *myRankInfoDic))completed;
//73  获取用户去过的城市
+(void)getArriveCity:(void (^)(NSString * errorcode,NSArray *cityArray))completed;
//72 获取去过的热点
+(void)getHotPointForWebView:(void (^)(NSString *errorcode,NSDictionary *dic))completed;
////获取去过的城市webData
//+(void)getArriveCityForWebView:(void (^)(NSDictionary *dic))completed;
//获取日历列表 里程和日期
+(void)getSumMileageListWithBeginDate:(NSString *)beginDate andEndDate:(NSString *)endDate complete:(void(^)(NSString * errorCode,NSArray *dateTimeArray,NSArray *sumMileageArray))completed;

/////+75举报
+(void)insertTeportInfoWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed;
///+76删除好友
+(void)removeUserFriendWithFriendAccountId:(NSString *)accountId completed:(void(^)(NSString * errorCode))completed;
//注册 个人信息
+ (void)uploadUserInforWith:(NSString *)nickname areaCode:(NSString *)areaCode gender:(NSString *)gender completed:(void(^)(NSString * errorCode, NSString * resultStr))completed;

//////我的消息
+ (void) getPushMessage:(NSDictionary *)dict completed:(void(^)(NSString * errorCode,NSMutableArray *modelArr))completed;

//77.找回密码发送验证码
+ (void)sendIdentifyingCodeMobilePhone:(NSString *)mobile times:(NSString *)times completed:(void(^)(NSString * errorCode, NSString * resultStr))completed;

////36.设置用户按键自定义接口
+ (void)setUserkeyInfo:(NSDictionary *)parameter completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

//37.设置一个用户按键自定义
+ (void)setOnlyOneUserkeyInfocustomType:(NSString *)customType actionType:(NSString *)actionType customParameter:(NSString *)customParameter completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;


///56.同意添加好友
+ (void) agreeAddFriend:(NSDictionary *)dict completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

////57.不同意添加好友

+ (void) noAgreeAddFriend:(NSDictionary *)dict completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;



///标记消息读取

+ (void) markReadMessage:(NSDictionary *)dict completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;
///35.获取用户按键自定义接口
+ (void)getUserkeyInfo:(NSString *)actionType Completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

///62.申请加入群聊频道验证推送

+(void)pushJoinSecretChannelMessageWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed;

///78.手机用户根据验证码重置新密码请求
+ (void)resetPasswordCheckVerifyCodeWithMobile:(NSString *)mobile verifyCode:(NSString *)verifyCode newPassword:(NSString *)newPassword completed:(void(^)(NSString * errorCode, NSString * resultStr))completed;


////79 ..群聊频道消息提醒
+(void)secretChannelMessageWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed;


////解散频道
+(void)dissolveSecretChannelWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed;

////转移频道

+(void)transferSecretChannelWithDic:(NSDictionary *)dic completed:(void(^)(NSString * errorCode))completed;



///同意或拒绝加入频道
+ (void) agreeOrRefuseJoinChannel:(NSDictionary *)dict completed:(void(^)(NSString * errorCode))completed;

////更多
+(void)getMoreListWithDic:(NSDictionary *)dic comple:(void(^)(NSString * errorCode,NSMutableArray *dataArr,NSMutableArray *adArray,NSDictionary *resultDict))completed;
///更改地区
+ (void) fixUserInfo:(NSDictionary *) dict completed:(void(^)(NSString * errorCode))completed;

////创建者修改群聊频道详情
+(void)modifySecretChannelInfoWithDic:(NSDictionary *)dic image:(UIImage *)image completed:(void(^)(NSString * errorCode))completed;

///清空消息中心
+ (void) clearMessageCenter:(NSDictionary *) dict completed:(void(^)(NSString * errorCode))completed;


//查询有多少未读消息
+ (void) selectMessageCount:(NSDictionary *) dict completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

//88 分享图片足迹
+(void)uploadFootmarkShareWithImage:(UIImage *)image completed:(void(^)(NSString * errorCode,NSString *url))completed;

//76.查询用户好友设置
+ (void)queryFriendSettingcompleted:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

////77,查询道客钱包页面

+(void)queryDaoKeWallet:(void(^)(NSString * errorCode,NSMutableArray * dataArray))completed;

+ (void)getLocation:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed;

//微信登录绑定手机号输入密码
+ (void)verifyAndresetWithMobile:(NSString *)mobile verificationCode:(NSString *)verificationCode newPassword:(NSString *)newPassword completed:(void(^)(NSString * errorCode, NSString * resultStr))completed;


//获取用户信息
+ (void)getUserInfo:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed;


//把文件存到本地
+ (NSString *)filePath:(NSString *)fileName;

//微密换货
+ (void)applyExchangeGoods:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany name:(NSString *)name telephone:(NSString *)telephone address:(NSString *)address exchangeReason:(NSString *)exchangeReason completed:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed;

//历史反押
+ (void)fetchDepositHisotry:(void (^)(NSString *errorCode, NSArray *resultArr))completed;

//修改押金密码
+ (void)updateDepositPasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completed:(void (^)(NSString *errorCode))completed;

//退货解约
+ (void)applyCancelContractWithDepositPassword:(NSString *)depositPassword expressNumber:(NSString *)expressNumber expressCompany:(NSString *)expressCompany completed:(void (^)(NSString *errorCode))completed;
//申领押金->我要转账
+ (void)applyWithdrawDepositApplyWithdrawAmount:(NSString *)applyWithdrawAmount depositPassword:(NSString *)depositPassword completed:(void (^)(NSString *errorCode))completed;
//获取个人信息

+ (void)getUserDepositInfoCompleted:(void (^)(NSString *errorCode, NSDictionary *resultDic))completed;

//微信登录 创建手机号
+ (void)wxLoginUidCreateAccountID:(NSString *)uid nickname:(NSString *)nickname completed:(void (^)(NSString *errorCode))completed;


//搜索的历史记录
+(void)searchHistoryCreateAccountID:(NSString *)countID completed:(void (^)(NSString *errorCode))completed;

/**
 *  置空
 *
 *  @param actionType actiontype
 *  @param completed  完成的回掉函数
 */
+(void)setOnlyOneUserkeyInfoEmpty:(NSString*)actionType completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

//重设吐槽键
+(void)setOnlyOneUserkeyInfoActionType:(NSString*)actionType customType:(NSString *)customType completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;
//解除绑定手机号
+(void)dismissBindTelPhone:(NSString*)telPhoneNum validateCode:(NSString*)validateCode completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

//绑定过的手机号获取验证码
+(void)getBindPhoneNumCode:(NSString*)telPhoneNum completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

/**
 *  获取appstroe的版本信息
 *
 *  @param completed 回调函数
 */
+(void)checkAPPStoreAppInfo:(void(^)(NSDictionary * resultDic))completed;

/**
 *  申请加入群聊频道
 *
 *  @param remark     备注
 *  @param actionType 类型
 *  @param uniqueCode <#uniqueCode description#>
 *  @param completed  回调
 */
+(void)applyJoinChannel:(NSString *)remark actionType:(NSString *)actionType customParameter:(NSString *)uniqueCode completed:(void(^)(NSString * errorCode, NSDictionary * resultDic))completed;

@end
