//
//  AppDelegate.h
//  微密
//
//  Created by longlz on 14-7-14.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
#import "LoginModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapManager *_mapManager;
    LoginModel *_loginModel;
    NSString *_nameString;//用户名
    NSString *_psdString;
    NSString *_uidString;
    NSString *_longitude;
    NSString *_latitude;
    BMKLocationService *_locService;
}

@property (strong, nonatomic) UIWindow *window;

@property (copy,nonatomic)NSString *code;

#pragma mark --- 获取用户的资金信息;
//- (void)fetchUserFinanceInfoAction:(void(^)(NSString*midian,NSString*weidian,NSError*error))block;
- (void)congieurePushAction:(NSString*)accountID;

@end
