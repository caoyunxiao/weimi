//
//  MoneyModely.m
//  微密
//
//  Created by mirrtalk on 15/6/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MoneyModely.h"

@implementation MoneyModely
+(MoneyModely *)getModelWithDic:(NSDictionary *)dic
{
    MoneyModely * model = [[MoneyModely alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
