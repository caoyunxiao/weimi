//
//  CONST.h
//  微密
//
//  Created by iOS Dev on 14-9-10.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#ifndef ___CONST_h
#define ___CONST_h




#endif


//微信

/**
 *  微信的相关
 */
#define wxAppID @"wx013ad54e5ca94428"
#define wxAppSecret @"ca26c144f8f91c9e9ade559d6fd1f10d"

//微博
/**
 *  微博的相关
 */
#define sinaAppKey @"3193835599"
#define sinaAppSecret @"5546070b7120585420d6d52374bc8718"
#define sinaRedirectUri @"http://weixin.daoke.me/tsukkomiauth"


//ShareSDK
#define shareAppKey @"32ec2931bde0"

//高德 //c09fe3246518b02f284911a144fd0794
//7f5a8adf4f3227aacafc44aceb389f7f
//#define maMapAppKey @"c09fe3246518b02f284911a144fd0794"


//接口
//appkey和secret //286302235  CD5ED55440C21DAF3133C322FEDE2B63D1E85949

/**
 *  平台标示位
 */
#define SecretOrAppkey @"appKey=iOS"

/**
 *  微信登录
 */

//登录
//微信登录
#define WXLOGIN @"createAccountID.do"
//#define WXBOUND @"verifyAndreset.do"


/**
 *  用户反馈
 */

//获取反馈回复
#define GETSUGGESTION @"querySuggestComment.do"

//评论反馈
#define DISCUSS @"addSuggestComment.do"



/**
 *  查询排名
 */

//查询某用户的驾驶里程和时长排名
#define GETRANKINFO @"getRankInfo.do"

//查询某用户的查询吐槽排名
#define QUERYTWEET @"queryTweetCountRank.do"


//查询用户Weme信息
//#define GETINFO @"getInfo.do"



/**
 *  频道
 */

//申请微频道
#define APPLYMICROCHANNEL @"applyMicroChannel.do"

#define MODIFYMICROCHANNEL @"modifyMicroChannel.do"

//获取微频道列表
#define FETCHMICROCHANNEL @"fetchMicroChannel.do"

//获取自己关注的
#define GETOWNERFOLLOWLISTUSERCHANNEL @"getOwnerFollowListUserChannel.do"

//获取微频道所有类别的列表
#define  GETCATALOGINFO @"getCatalogInfo.do"

//关注微频道
#define FOLLOWMICROHANNEL @"followMicroChannel.do"

//根据频道编码获取频道详情与关注(加入状态)
#define GETUSERCHANNELINFO @"getMicroChannelInfo.do"

//取消关注微频道
#define UNFOLLOWUSERCHANNEL @"unFollowUserChannel.do"

//重置频道当前邀请的惟一码
#define  RESETINVITEUNIQUECODE @"resetInviteUniqueCode.do"

//获取微频道关注的用户列表信息
#define FETCHFOLLOWLISTUSERCHANNEL @"fetchFollowListUserChannel.do"

//获取微频道关注的用户列表信息
#define GETOWNERUSERCHANNELFOLLOWLIST @"getBossFollowListMicroChannel.do"




/**
 *  我的微密
 */
#define kRandom  @"Random"
// 自动转账

#define kAutoDraw @"AutoDraw"

//NSUserDefaults 密点和微点
#define DenseNumber @"DenseNumber"//密点
#define SmallNumber @"SmallNumber"//微点

//获取某用户的成长明细
#define GETGROWTHDETAIL @"getGrowthDetail.do"

//用户成长信息
#define GETGROWTHINFO @"getGrowthInfo.do"

//用户领取某任务的谢尔值
#define  GETSHAREVALUE  @"getShareValue.do"

// 获取某用户的任务列表以及完成情况
#define  GETTASKLIST @"getTaskList.do"

//线上.....
#define SHOPINGS(url) [NSString stringWithFormat:@"http://store.daoke.me/index.php/%@",url]

#define alert(msg,cancelMessage,otherButtonMessage) [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:cancelMessage otherButtonTitles:otherButtonMessage, nil] show];

#define Alert(msg) [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil] show];

#define alerts(msg,cancelMessage,otherButtonMessage) [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:cancelMessage otherButtonTitles:otherButtonMessage, nil] show];

#define ImageViewCorner(view) view.layer.cornerRadius = 5;view.layer.masksToBounds = YES;
#define judgeEnpty(model) model==nil?@"":model;
#define judgeZero(model) model == nil?@"0":model;
/**
 *  商城
 */

//获取商品列表
//线上

#define WEMEKEY @"key"//设置押金密码通知
#define POPVIEW @"popView"//绑定成功后跳转页面通知

#define kGetGoodsSubType   @"http://192.168.11.85/store/index.php/storeapi/getGoodsSubType"




