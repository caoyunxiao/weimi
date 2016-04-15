//
//  NSString+AreaCode.m
//  微密
//
//  Created by iOS Dev on 14/11/10.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "NSString+AreaCode.h"

@implementation NSString (AreaCode)

+ (NSString *)arearCodeWithProvince:(NSString *)province city:(NSString *)city
{
    NSArray *provinces = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"area.plist" ofType:nil]];
    
    NSUInteger aCount = [provinces count];
    
    for (int i = 0; i < aCount; i++)
    {
        NSDictionary *proDic = [provinces objectAtIndex:i];
        
        NSString *proName = [proDic objectForKey:@"name"];
        
        if ([proName isEqualToString:province])
        {
            NSArray *cities = [proDic objectForKey:@"list"];
            
            NSUInteger cCount = [cities count];
            
            for (int j = 0; j < cCount; j++) {
                
                NSDictionary *citDic = [cities objectAtIndex:j];
                
                NSString *citName = [citDic objectForKey:@"name"];
                
                if ([citName isEqualToString:city])
                {
                    return [citDic objectForKey:@"code"];
                }
            }
            return nil;
        }
    }
    
    return nil;
}


@end
