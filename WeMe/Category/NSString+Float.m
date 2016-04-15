//
//  NSString+Float.m
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "NSString+Float.h"

@implementation NSString (Float)


+ (NSString *)stringWithFloat:(NSMutableString *)string atIndex:(int)index
{
    if ([string length] - 1 < index)
    {
        return [NSString stringWithFormat:@"%f",[string intValue] / 10000000.0];
    }
    
    [string insertString:@"." atIndex:index];
    
    return string;
}

@end
