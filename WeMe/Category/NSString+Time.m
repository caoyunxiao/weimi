//
//  NSString+Time.m
//  微密
//
//  Created by longlz on 14-7-26.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)


+ (NSString *)dateFormatWithSeconds:(long long int)totalSeconds
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *timeString = [NSString stringWithFormat:@"%@",localeDate];
    
    return [timeString substringToIndex:19];
}


+ (NSString *)currentDate
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter  alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *todayTime = [formatter stringFromDate:currentDate];
    
    return todayTime;
}


+ (NSString *)currentFormartDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc]  init ];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *todayTime = [formatter stringFromDate:currentDate];
    return todayTime;
}

+ (NSString *)currentDetailDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc]  init ];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *todayTime = [formatter stringFromDate:currentDate];
    return todayTime;
}


int isUnion(int year)
{
    if((year/4 == 0 && year/100 != 0)||(year/400 == 0))
    {
        return 1;
    }
    return 0;
}


+ (NSString *)yearAndMonth:(NSString *)yearAndMonth
{
    int year = [[yearAndMonth substringToIndex:4]intValue];
    int month = [[yearAndMonth substringFromIndex:5]intValue];
    NSString *day;
    
    switch (month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:
            day = @"31";
            break;
        case 2:
        {
            if (isUnion(year) == 1)
            {
                day = @"29";
            }else
            {
                day = @"28";
            }
        }
            break;
            
        case 4:case 6:case 9:case 11:
            day = @"30";
            break;
        default:
            break;
    }
    return day;
}

+ (NSString *)getDay:(NSString *)date
{
    return [date substringFromIndex:8];
}


+ (NSString *)yesterdayDate
{
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter *formatter = [[NSDateFormatter  alloc]  init ];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *yesterdayTime = [formatter stringFromDate:yesterday];
    
    return yesterdayTime;
}
+(NSString *)getString:(NSString *)date
{
    NSDictionary * dic = @{@"01":@"1",@"02":@"2",@"03":@"3",@"04":@"4",@"05":@"5",@"06":@"6",@"07":@"7",@"08":@"8",@"09":@"9"};
    NSArray * dateArr = [date componentsSeparatedByString:@"-"];
    NSString * year = [dateArr firstObject];
    NSString * months = [dateArr objectAtIndex:1];
    NSString * month = [[months substringToIndex:1]isEqualToString:@"0"]?[dic objectForKey:months]:months;
    NSString * days = [dateArr objectAtIndex:2];
    //NSString * day = [[days substringToIndex:1]isEqualToString:@"0"]?[dic objectForKey:days]:days;
    NSString * getDate = [NSString stringWithFormat:@"%@年%@月%@日",year,month,days];
    
    return getDate;
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName:font};
    //    Size:文本能占用的最大宽高
    //    options: ios提供的计算方式
    //    attributes: 字体和大小
    //    context: nil
    // 如果计算的文本超过了给定的最大的宽高,就返回最大宽高,如果没有超过,就返回真实占用的宽高
    CGRect rect =  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size;
}
@end
