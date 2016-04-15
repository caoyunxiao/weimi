//
//  NSString+Time.h
//  微密
//
//  Created by longlz on 14-7-26.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)


+ (NSString *)dateFormatWithSeconds:(long long int)totalSeconds;


+(NSString *)yearAndMonth:(NSString *)yearAndMonth;


+ (NSString *)currentDate;

+ (NSString *)currentFormartDate;

+ (NSString *)currentDetailDate;

+ (NSString *)getDay:(NSString *)date;


+ (NSString *)yesterdayDate;
+(NSString *)getString:(NSString *)date;
@end
