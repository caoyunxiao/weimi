//
//  FamilyInfo.h
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyInfo : NSObject

//对方的ID
@property(copy,nonatomic)NSString *accountID;

@property(assign,nonatomic)int parameterType;

@property(copy,nonatomic)NSString *uuidString;

//对方的手机号  手机号或者IMEI
@property(copy,nonatomic)NSString *receiceID;

@property(copy,nonatomic)NSString *receiveNicknameString;

@property(copy,nonatomic)NSString *locationNicknameString;

+ (FamilyInfo *)shareFamilyInfo;

@end
