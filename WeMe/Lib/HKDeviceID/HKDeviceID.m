//
//  HKDeviceID.m
//  Test2
//
//  Created by 夏 利兵 on 13-9-22.
//  Copyright (c) 2013年 handkoo. All rights reserved.
//

#import "HKDeviceID.h"
#import "KeychainItemWrapper.h"
#import "NSString+MD5Addition.h"

#include <stdlib.h>


@implementation HKDeviceID


+ (NSString*)getCurTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // y-year M-month d-day H-hour m-minutes s:secodes s:miseconds  字符 /,: 任意修改
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    NSString*timeString=[[formatter stringFromDate: [NSDate date]]copy];
    
    
    formatter = nil;
    
    return timeString;
}

/*
 int randomNum = arc4random() % 89999 + 10000;
 这是一个五位数的随机数；
 
 arc4random()%n 这是从0到(n-1)的随机数
 */

+ (NSString*)createHKDeviceID
{    
    //生成5位随机数
    int randomNum = arc4random() % 89999999 + 10000000;
    NSString *str = [NSString stringWithFormat:@"%d",randomNum];
    
    NSString *strTime = [self getCurTime];
    
    NSString *strID = [NSString stringWithFormat:@"%@%@",strTime,str];
 
  //  strID = [strID stringFromMD5];
   // DLog(@"%@",strID);
    
    //加密
    return strID;
}

+ (NSString*)getHKDeviceID
{  
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"HDTKDeviceID" accessGroup:nil];    
       
    NSString *strID = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    if ( strID == nil || [strID isEqualToString:@""] )
    {
        strID = [self createHKDeviceID];
        [wrapper setObject:strID forKey:(__bridge id)(kSecAttrAccount)];
    }
    wrapper = nil;
    
    NSString *str = [strID stringFromMD5];
    
    return str;
}



@end
