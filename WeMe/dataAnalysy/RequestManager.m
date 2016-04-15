//
//  RequestManager.m
//  DaokeClub
//
//  Created by mirrtalk on 15/4/29.
//  Copyright (c) 2015年 Daoke Dev. All rights reserved.
//

#import "RequestManager.h"
#import "HeaderModel.h"
@implementation RequestManager

#pragma mark --获取请求头--  


+(AFHTTPRequestOperationManager *)getManager
{

    NSString *workAble=[UserDefaults objectForKey:@"netWork"];
    if ([workAble isEqual:@"0"]) {
        [MBProgressHUD showError:@"主人,网络异常"];
    }
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:KSys forHTTPHeaderField:[HeaderModel sharedHeaderModel].sys];
    [manager.requestSerializer setValue:KSysversion forHTTPHeaderField:[HeaderModel sharedHeaderModel].sysversion];
    [manager.requestSerializer setValue:KApp forHTTPHeaderField:[HeaderModel sharedHeaderModel].app];
    [manager.requestSerializer setValue:Kappversion forHTTPHeaderField:[HeaderModel sharedHeaderModel].appversion];
    [manager.requestSerializer setValue:KPrimarykey forHTTPHeaderField:[HeaderModel sharedHeaderModel].primarykey];
    [manager.requestSerializer setValue:KNettype forHTTPHeaderField:[HeaderModel sharedHeaderModel].nettype];
    [manager.requestSerializer setValue:KDevicetype forHTTPHeaderField:[HeaderModel sharedHeaderModel].devicetype];
    
    NSString * accountId = [PersonInfo sharePersonInfo].accountIDString;
    if ([accountId isEqualToString:@""]||accountId == nil)
    {
        accountId = @"";
    }
    NSString *longitude = [HeaderModel sharedHeaderModel].longitude;
    if ([longitude isEqualToString:@""]||longitude == nil)
    {
        longitude = @"";
    }
    NSString *latitude = [HeaderModel sharedHeaderModel].latitude;
    if ([latitude isEqualToString:@""]||latitude == nil)
    {
        latitude = @"";
    }
    
    [manager.requestSerializer setValue:KAccountID forHTTPHeaderField:accountId];
    [manager.requestSerializer setValue:KLon forHTTPHeaderField:longitude];
    [manager.requestSerializer setValue:KLat forHTTPHeaderField:latitude];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return manager;
}
@end
