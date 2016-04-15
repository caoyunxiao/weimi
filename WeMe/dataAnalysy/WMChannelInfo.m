//
//  WMChannelInfo.m
//  微密
//
//  Created by MacDev on 15/3/2.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "WMChannelInfo.h"

@implementation WMChannelInfo
+(WMChannelInfo *)getChannelInfoWithDic:(NSDictionary *)dic
{
    WMChannelInfo * info = [[WMChannelInfo alloc]init];
    [info setValuesForKeysWithDictionary:dic];
    return info;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
