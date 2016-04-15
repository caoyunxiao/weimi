//
//  PersonInfo.h
//  微密
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoreModely.h"

@interface PersonInfo : NSObject

@property(copy,nonatomic)NSString *iconString;        //头像字符串
@property(copy,nonatomic)NSString *nameString;        //姓名
@property(copy,nonatomic)NSString *nicknameString;    //昵称
@property(copy,nonatomic)NSString *IMEIString;        //IMEI号
@property(copy,nonatomic)NSString *accountIDString;   //
@property(copy,nonatomic)NSString *phoneString;       //电话号码
@property(copy,nonatomic)NSString *sexString;         //性别
@property(copy,nonatomic)NSString *carNumberString;   //车牌号
@property(copy,nonatomic)NSString *driveString;       //
@property(copy,nonatomic)NSString *miCionNumber;      //
@property(copy,nonatomic)NSString *weiCionNumber;     //
@property(copy,nonatomic)NSString *areaStr;           //地区
@property(strong,nonatomic)NSData *headDataStr;       //
@property(nonatomic,assign)BOOL _isLogine;            //
@property(nonatomic,copy)NSString * senderUserHeadName;//
@property (nonatomic,copy) NSString *idNumber;//身份证号

@property(copy,nonatomic)NSString *birthday;           //生日
@property(copy,nonatomic)NSString *checkMobileTime;           //
@property(copy,nonatomic)NSString *gender;           //
@property(copy,nonatomic)NSString *guardianMobile;           //

@property(nonatomic,copy)NSString *grade;//等级
@property(nonatomic,copy)NSString *gradeTitle;
@property (nonatomic,assign)BOOL needRefresh;//是否需要刷新

@property (nonatomic,assign)BOOL isHaveShowFirstImage;//是否显示过首页广告图片
@property (nonatomic,retain)MoreModely *adCountDownModels;//存放首页广告图的model

@property (nonatomic,copy) NSString *JiaJiaKeyNumber;//设置的++键频道名称
@property (nonatomic,copy) NSString *JiaKeyNumber;//设置的+键频道名称
@property (nonatomic,copy) NSString *makeComplaintsJKeyNumber;//设置的吐槽键频道号
@property(nonatomic,copy)NSString *isThirdModel;//是否是第三方设备
@property(nonatomic,copy)NSString *brandType;//设备类型，是weme终端还是第三方
@property(nonatomic,copy)NSString *model;



+ (PersonInfo *)sharePersonInfo;

- (void)resetPersonInfo;

@end
