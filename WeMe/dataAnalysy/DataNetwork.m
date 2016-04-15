//
//  DataNetwork.m
//  Example
//
//  Created by wkl-mac-4 on 15/4/27.
//  Copyright (c) 2015年 Welite. All rights reserved.
//

#import "DataNetwork.h"
#import "AppDelegate.h"

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_2G= 3,
    NETWORK_TYPE_4G= 4,
}NETWORK_TYPE;
@implementation DataNetwork
//以前的方法 删除掉  网络监听已经加入 删除了之后报错，没找到原因，先放在这里
+ (NSString *)getNetType {
    NSArray * _netArr = @[@"无网络",@"Wifi",@"2G",@"3G",@"4G"];
    //NSString * type = nil;
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSInteger netType = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        netType = NETWORK_TYPE_NONE;
    }else{
        NSInteger n = [num intValue];
        if (n == 0) {
            netType = NETWORK_TYPE_NONE;
        }else if (n == 1){
            netType = NETWORK_TYPE_2G;
        }else if (n == 2){
            netType = NETWORK_TYPE_3G;
        }else if (n == 5){
            netType = NETWORK_TYPE_WIFI;
        }else if (n == 3){
            netType = NETWORK_TYPE_4G;
        }
    }
    return @"Wifi";
}
+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString * result=(NSString*)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
+(NSString *)getSysversion
{
    return [[UIDevice currentDevice]systemVersion];
}
+(NSString *)getAppWithType:(NSInteger)type
{
    NSArray * typeArr = @[@"微密2.0",@"我的店1.0",@"随车拍1.0",@"道客FM1.0"];
    return [typeArr objectAtIndex:type];
}
+(NSString *)getAppversion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
+(NSString *)getDevicetype
{
    return [[UIDevice currentDevice] model];
}

@end
