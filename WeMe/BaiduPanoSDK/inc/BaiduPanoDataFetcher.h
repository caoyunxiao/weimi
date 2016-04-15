//
//  BaiduPanoDataFetcher.h
//  BaiduPanoSDK
//
//  Created by bianheshan on 15/5/4.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BaiduPanoDataFetcher : NSObject

/**
 * @abstract 获取室内全景描述信息
 * @param   pid 全景pid
 */
+ (NSString *)requestPanoramaIndoorDataWithPid:(NSString *)pid;

/**
 * @abstract 获取全景pid周边所有的推荐服务信息
 * @param   pid 全景pid
 */
+ (NSString *)requestPanoramaRecommendationServiceDataWithPid:(NSString *)pid;

@end
