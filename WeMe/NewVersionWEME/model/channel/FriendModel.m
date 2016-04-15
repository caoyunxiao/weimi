//
//  FriendModel.m
//  微密
//
//  Created by MacDev on 15/4/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel
+(FriendModel *)getModelWithDic:(NSDictionary *)dic
{
    FriendModel * model = [[FriendModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
