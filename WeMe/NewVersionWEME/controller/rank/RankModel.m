//
//  RankModel.m
//  微密
//
//  Created by MacDev on 15/4/16.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "RankModel.h"

@implementation RankModel
+(RankModel *)getModelWithDic:(NSDictionary *)dic
{
    RankModel * model = [[RankModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
