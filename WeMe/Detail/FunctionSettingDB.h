//
//  FunctionSettingDB.h
//  微密
//
//  Created by iOS Dev on 14-8-28.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBManager.h"
#import "FunctionInfo.h"
#import "FunctionHeaderInfo.h"



@interface FunctionSettingDB : NSObject
{
    FMDatabase *_db;
}


- (NSString *)createFunctionDataBase;

- (void)addFunction:(FunctionInfo *)functionInfo;

- (void)deleteFunctionTable;

- (NSArray *)selectFunctionAll;

//22222222
- (NSString *)createFunctionHeaderDataBase;

- (void)addFunctionHeader:(FunctionHeaderInfo *)functionHeaderInfo;

- (void)deleteFunctionHeaderTable;

- (NSArray *)selectFunctionHeaderAll;


@end
