//
//  LoginModel.h
//  微密
//
//  Created by longlz on 14-7-21.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginBLock)(int fSucceed);

typedef void(^RegisterBlock)(NSString *regCode);

typedef void(^FinisedRegisterBlock)(NSString *strFinsed);


typedef void(^WXLoginBlock)(int iSuccess);


@interface LoginModel : NSObject


/**
 *  登录
 *
 *  @param name    用户名
 *  @param pwd     密码
 *  @param succeed 请求返回
 */
//- (void)loginWithName:(NSString *)name pwd:(NSString *)pwd succeed:(LoginBLock)succeed;

/**
 *  同步登录
 *
 *  @param name 用户名
 *  @param pwd  密码
 *
 *  @return 返回状态
 */
- (int)loginSynchronousWithName:(NSString *)name pwd:(NSString *)pwd;

+ (BOOL)getUserInfo;

+ (NSInteger)wxLoginSynchronousWith:(NSString *)uid;

//获取IMEI号和手机号
+ (NSDictionary *)getIMEIAndPhone;

//获取首页大图 -- 广告图
+ (MoreModely *)getAdvertisementViewImageWithDic;

@end
