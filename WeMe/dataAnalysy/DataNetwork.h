//
//  DataNetwork.h
//  Example
//
//  Created by wkl-mac-4 on 15/4/27.
//  Copyright (c) 2015年 Welite. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataNetwork : NSObject
+ (NSString *)getNetType;//获取网络状态
+(NSString*) uuid;//获取udid
+(NSString *)getSysversion;//系统版本
+(NSString *)getAppWithType:(NSInteger)type;//产品类型 0 微密2.0, 1  我的店1.0 ,  2 随车拍1.0,  3 道客FM1.0
+(NSString *)getAppversion;//获得产品版本
+(NSString *)getDevicetype;//手机型号

@end
