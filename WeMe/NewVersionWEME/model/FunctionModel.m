//
//  FunctionModel.m
//  微密
//
//  Created by longlz on 14-7-29.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "FunctionModel.h"
#import "HTTPPostManger.h"
#import "PersonInfo.h"
#import "FunctionInfo.h"
#import "FunctionHeaderInfo.h"





#define kFunctionArray @"kFunctionArray"

#define kFunctionInfo @"kFunctionInfo"

@implementation FunctionModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _db = [[FunctionSettingDB alloc]init];
        
        [_db createFunctionDataBase];
        [_db createFunctionHeaderDataBase];
        
        _allListArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)getListFunction:(GetListFunctionBlock)listFunction
{
    [_allListArray removeAllObjects];
    [RequestEngine getFunctionList:^(NSString *errorCode, NSArray *dataArray) {
        if ([errorCode isEqualToString:@"0"])
        {
            [_db deleteFunctionHeaderTable];
            [_db deleteFunctionTable];
            [self analysisArray:dataArray];
        }
        else
        {
            NSArray *fArray = [_db selectFunctionAll];
            NSArray *fhArray = [_db selectFunctionHeaderAll];
            if ([fArray count] > 0)
            {
                [self analysisHiStoryArray:fArray hisArray:fhArray];
            }
        }
        if (listFunction)
        {
            listFunction(_allListArray);
        }
    }];
}
- (void)analysisArray:(NSArray *)array
{
    int aCount = (int)[array count];
    
    for (int i = 0; i < aCount; i++)
    {
        FunctionInfo *info = [[FunctionInfo alloc]init];
        FunctionHeaderInfo *headerInfo = [[FunctionHeaderInfo alloc]init];
        
        info.selected = [[array objectAtIndex:i] objectForKey:@"selected" ] ;
        
        info.subIdx = [[array objectAtIndex:i] objectForKey:@"subIdx" ];
        info.subName = [[array objectAtIndex:i] objectForKey:@"subName"];
        info.intro = [[array objectAtIndex:i] objectForKey:@"intro"];
        
        headerInfo.catalogID = [[array objectAtIndex:i] objectForKey:@"catalogID"];
        headerInfo.catalogName = [[array objectAtIndex:i] objectForKey:@"catalogName"];
        
        
        [_db addFunction:info];
        [_db addFunctionHeader:headerInfo];
        
        int hCount = (int)[_allListArray count];
        int j;
        
        for (j = 0; j < hCount; j++)
        {
            FunctionHeaderInfo *fhInfo = [[_allListArray objectAtIndex:j]objectForKey:kFunctionInfo];
            if ([fhInfo.catalogID intValue] == [headerInfo.catalogID intValue])
            {
                [[[_allListArray objectAtIndex:j] objectForKey:kFunctionArray] addObject:info];
                break;
            }
        }
        
        if (j == hCount)
        {
            NSMutableArray *headerArray2 = [[NSMutableArray alloc]init];
            [headerArray2 addObject:info];
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:headerInfo,kFunctionInfo,headerArray2,kFunctionArray, nil];
            [_allListArray addObject:dict];
        }
    }
    
}

- (void)analysisHiStoryArray:(NSArray *)fArray hisArray:(NSArray *)fhArray
{
    int aCount = (int)[fArray count];
    
    for (int i = 0; i < aCount; i++)
    {
        FunctionInfo *info = [fArray objectAtIndex:i];
        
        FunctionHeaderInfo *headerInfo = [fhArray objectAtIndex:i];
        
        int hCount = (int)[_allListArray count];
        int j;
        
        for (j = 0; j < hCount; j++)
        {
            FunctionHeaderInfo *fhInfo = [[_allListArray objectAtIndex:j]objectForKey:kFunctionInfo];
            
            if ([fhInfo.catalogID intValue] == [headerInfo.catalogID intValue])
            {
                [[[_allListArray objectAtIndex:j] objectForKey:kFunctionArray] addObject:info];
                break;
            }
        }
        
        if (j == hCount)
        {
            NSMutableArray *headerArray2 = [[NSMutableArray alloc]init];
            [headerArray2 addObject:info];
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:headerInfo,kFunctionInfo,headerArray2,kFunctionArray, nil];
            [_allListArray addObject:dict];
        }
    }
}

- (void)setListFunction:(NSMutableArray *)listArray setFunction:(SetFunctionBlock)setFunction;
{
    if (listArray == nil) {
        return;
    }
    int lCount = (int)[listArray count];
    
    NSMutableString *subParameterString = [[NSMutableString alloc]initWithFormat:@"subParameter="];
    
    for (int i = 0; i < lCount; i++)
    {
        FunctionInfo *info = [listArray objectAtIndex:i];
        if ([info.subIdx intValue] == 33)
        {
            continue;
        }
        if (i == 0)
        {
            [subParameterString appendString:info.subIdx];
            [subParameterString appendString:@":"];
            [subParameterString appendString:info.selected];
        }else
        {
            [subParameterString appendString:@"%7C"];
            [subParameterString appendString:info.subIdx];
            [subParameterString appendString:@":"];
            [subParameterString appendString:info.selected];
        }
    }
    NSString *bodyString = [NSString stringWithFormat:@"%@&%@&accountID=%@",subParameterString,SecretOrAppkey,[PersonInfo sharePersonInfo].accountIDString];
    [RequestEngine saveNewsListWithStr:bodyString complete:^(NSString *errorCode) {

        if ([errorCode isEqualToString:@"0"])
        {
            if (setFunction) {
                setFunction(YES);
            }
        }
        else
        {
            if (setFunction) {
                setFunction(NO);
            }
        }
    }];
}


@end
