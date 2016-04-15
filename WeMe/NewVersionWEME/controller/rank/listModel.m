//
//  listModel.m
//  微密
//
//  Created by MacDev on 15/4/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "listModel.h"

@implementation listModel
+(listModel *)getModelWithDic:(NSDictionary *)dic
{
    listModel * model = [[listModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
