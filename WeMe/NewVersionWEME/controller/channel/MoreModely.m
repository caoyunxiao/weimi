//
//  MoreModely.m
//  微密
//
//  Created by mirrtalk on 15/5/29.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MoreModely.h"

@implementation MoreModely
+(MoreModely*)getModelWithDic:(NSDictionary *)dic
{
    MoreModely * model = [[MoreModely alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
