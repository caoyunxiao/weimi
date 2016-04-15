//
//  HeaderModel.h
//  RequestDemo
//
//  Created by mirrtalk on 15/4/25.
//  Copyright (c) 2015年 mirrtalk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderModel : NSObject
@property(nonatomic,copy)NSString * sys;//系统类型
@property(nonatomic,copy)NSString * sysversion;//系统版本
@property(nonatomic,copy)NSString * app;//weme/bangmangla /club    weme  suichepai wodedian
@property(nonatomic,copy)NSString * appversion;//产品版本
@property(nonatomic,copy)NSString * primarykey;//用户手机设备号
@property(nonatomic,copy)NSString * accountID;//帐户ID
@property(nonatomic,copy)NSString * nettype;//网络类型 移到2G /3G /4G WiFi
@property(nonatomic,copy)NSString * devicetype;//手机型号
@property(nonatomic,copy)NSString * longitude;//
@property(nonatomic,copy)NSString * latitude;//

+(HeaderModel *)sharedHeaderModel;
@end
