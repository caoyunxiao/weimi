//
//  PersonInfo.m
//  微密
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "PersonInfo.h"

static PersonInfo *g_personInfo;

@implementation PersonInfo

+ (PersonInfo *)sharePersonInfo
{
    if (g_personInfo == nil)
    {
        g_personInfo = [[self alloc]init];
    }
    return g_personInfo;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //
    }
    return self;
}


- (void)resetPersonInfo
{
    self.nameString=nil;
    self.iconString=nil;        //头像字符串
    self.nameString=nil;        //姓名
    self.nicknameString=nil;    //昵称
    self.IMEIString=nil;        //IMEI号
    self.accountIDString=nil;   //
    self.phoneString=nil;       //电话号码
    self.sexString=nil;         //性别
    self.carNumberString=nil;   //车牌号
    self.driveString=nil;       //
    self.miCionNumber=nil;      //
    self.weiCionNumber=nil;     //
    self.areaStr=nil;           //地区
    self.headDataStr=nil;       //
    self._isLogine=nil;            //
    self.senderUserHeadName=nil;//
    self.idNumber=nil;//身份证号
    self.birthday=nil;           //
    self.checkMobileTime=nil;           //
    self.gender=nil;           //
    self.guardianMobile=nil;           //
    self.grade=nil;//等级
    self.gradeTitle=nil;
    self.needRefresh=nil;
    self.isHaveShowFirstImage=nil;
    self.adCountDownModels=nil;
}

@end
