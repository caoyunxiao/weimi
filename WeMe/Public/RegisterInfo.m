//
//  RegisterInfo.m
//  微密
//
//  Created by iOS Dev on 14-8-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "RegisterInfo.h"


static RegisterInfo *g_registerInfo;

@implementation RegisterInfo

+ (RegisterInfo *)shareRegisterInfo
{
    if (g_registerInfo == nil)
    {
        g_registerInfo = [[self alloc]init];
    }
    
    return g_registerInfo;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


@end
