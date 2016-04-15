//
//  NewWModel.m
//  微密
//
//  Created by MacDev on 15/3/6.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewWModel.h"

@implementation NewWModel
+(NewWModel *)getWeMeModelWithDic:(NSDictionary *)dic
{
    NewWModel * model = [[NewWModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
