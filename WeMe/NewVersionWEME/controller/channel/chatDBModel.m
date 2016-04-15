//
//  chatDBModel.m
//  微密
//
//  Created by wemeDev on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "chatDBModel.h"

@implementation chatDBModel
+(chatDBModel*)getModelWithDic:(NSDictionary *)dic
{
    chatDBModel * model = [[chatDBModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //zfj
}


@end
