//
//  FamilyInfo.m
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "FamilyInfo.h"


static FamilyInfo *g_familyInfo;

@implementation FamilyInfo


+ (FamilyInfo *)shareFamilyInfo
{
    if (g_familyInfo == nil)
    {
        g_familyInfo = [[self alloc]init];
    }
    return g_familyInfo;
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
