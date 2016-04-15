//
//  HeaderModel.m
//  RequestDemo
//
//  Created by mirrtalk on 15/4/25.
//  Copyright (c) 2015年 mirrtalk. All rights reserved.
//

#import "HeaderModel.h"

@implementation HeaderModel
+(HeaderModel *)sharedHeaderModel
{
    static HeaderModel * model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (model == nil)
        {
            model = [[HeaderModel alloc]init];
        }
    });
    return model;
}
@end
