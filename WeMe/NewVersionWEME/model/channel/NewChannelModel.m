//
//  NewChannelModel.m
//  微密
//
//  Created by MacDev on 15/4/21.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewChannelModel.h"

@implementation NewChannelModel
+(NewChannelModel *)getModelWithDic:(NSDictionary *)dic
{
    NewChannelModel * model = [[NewChannelModel alloc]init];
    [model setValuesForKeysWithDictionary:dic
     ];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
