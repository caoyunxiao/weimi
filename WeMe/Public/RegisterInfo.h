//
//  RegisterInfo.h
//  微密
//
//  Created by iOS Dev on 14-8-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterInfo : NSObject


@property(copy ,nonatomic)NSString *phoneNumberString;

@property(copy ,nonatomic)NSString *verificationCodeSting;

@property(copy ,nonatomic)NSString *nicknameString;


+ (RegisterInfo *)shareRegisterInfo;


@end
