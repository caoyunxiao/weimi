//
//  HENLENSONG.h
//  chuangchaungyingxiao
//
//  Created by ccapp on 14-8-19.
//  Copyright (c) 2014年 ccapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HENLENSONG : NSObject

+(BOOL)isValidateEmail:(NSString *)email;

+(BOOL) isValidateMobile:(NSString *)mobile;

+(BOOL) isValidateCarNo:(NSString*)carNo;

+ (BOOL) isRightdate:(NSString*)date;

+ (BOOL) isRightNumber:(NSString*)number;

+ (BOOL) isRightNameWithNumberAndEnglishAndHanZi:(NSString*)msg;

+ (BOOL) isRightLetterBeginAndContainNumber:(NSString*)string;

@end
