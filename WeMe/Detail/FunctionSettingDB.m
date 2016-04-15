//
//  FunctionSettingDB.m
//  微密
//
//  Created by iOS Dev on 14-8-28.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "FunctionSettingDB.h"


#define kFunctionTable @"FunctionTable"
#define kFunctionHeaderTable @"FunctionHeaderTable"

@implementation FunctionSettingDB

- (id)init
{
    self = [super init];
    if (self)
    {
        _db = [SDBManager defaultDBManager].dataBase;
    }
    return self;
}


- (NSString *)createFunctionDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kFunctionTable]];
    [set next];
    
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable)
    {
        // TODO:是否更新数据库
        
        return @"数据库已经存在";
    } else
    {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE FunctionTable (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, selected VARCHAR(2), subIdx VARCHAR(2) ,subName VARCHAR(100) ,intro VARCHAR(20))";
        BOOL res = [_db executeUpdate:sql];
        
        
        if (!res)
        {
            return @"数据库创建失败";
        } else
        {
            return @"数据库创建成功";
        }
    }
}

- (void)addFunction:(FunctionInfo *)functionInfo
{
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO FunctionTable"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [[NSMutableArray alloc]init];
    
    if (functionInfo.selected) {
        [keys appendString:@"selected,"];
        [values appendString:@"?,"];
        [arguments addObject:functionInfo.selected];
    }
    if (functionInfo.subIdx) {
        [keys appendString:@"subIdx,"];
        [values appendString:@"?,"];
        [arguments addObject:functionInfo.subIdx];
    }
    if (functionInfo.subName) {
        [keys appendString:@"subName,"];
        [values appendString:@"?,"];
        [arguments addObject:functionInfo.subName];
    }
    if (functionInfo.intro) {
        [keys appendString:@"intro,"];
        [values appendString:@"?,"];
        [arguments addObject:functionInfo.intro];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    
    [_db executeUpdate:query withArgumentsInArray:arguments];
}

- (void)deleteFunctionTable
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM FunctionTable"];
    [_db executeUpdate:query];
}

- (NSArray *)selectFunctionAll
{
    NSString * query = @"SELECT * FROM FunctionTable";
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next])
    {
        FunctionInfo *info = [[FunctionInfo alloc]init];
        info.selected = [rs stringForColumn:@"selected"];
        info.subIdx = [rs stringForColumn:@"subIdx"];
        info.subName = [rs stringForColumn:@"subName"];
        info.intro = [rs stringForColumn:@"intro"];
        [array addObject:info];
        
    }
    [rs close];
    
    return array;
}

//22222222
- (NSString *)createFunctionHeaderDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kFunctionHeaderTable]];
    [set next];
    
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    
    if (existTable)
    {
        return @"数据库已经存在";
    }
    else
    {
        // TODO: 插入新的数据库
        NSString * sql = @"CREATE TABLE FunctionHeaderTable (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, catalogName VARCHAR(20), catalogID VARCHAR(20),isSelectd VARCHAR(2))";
        BOOL res = [_db executeUpdate:sql];
        
        
        if (!res)
        {
            return @"数据库创建失败";
        } else
        {
            return @"数据库创建成功";
        }
    }
}

- (void)addFunctionHeader:(FunctionHeaderInfo *)functionHeaderInfo
{
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO FunctionHeaderTable"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [[NSMutableArray alloc]init];
    
    if (functionHeaderInfo.catalogID)
    {
        [keys appendString:@"catalogID,"];
        [values appendString:@"?,"];
        [arguments addObject:functionHeaderInfo.catalogID];
    }
    if (functionHeaderInfo.catalogName)
    {
        [keys appendString:@"catalogName,"];
        [values appendString:@"?,"];
        [arguments addObject:functionHeaderInfo.catalogName];
    }
    if (functionHeaderInfo.isSelectd)
    {
        [keys appendString:@"isSelectd,"];
        [values appendString:@"?,"];
        [arguments addObject:functionHeaderInfo.isSelectd];
    }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    
    [_db executeUpdate:query withArgumentsInArray:arguments];
}

- (void)deleteFunctionHeaderTable
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM FunctionHeaderTable"];
    [_db executeUpdate:query];
}

- (NSArray *)selectFunctionHeaderAll
{
    NSString * query = @"SELECT * FROM FunctionHeaderTable";
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next])
    {
        FunctionHeaderInfo *info = [[FunctionHeaderInfo alloc]init];
        info.catalogName = [rs stringForColumn:@"catalogName"];
        info.catalogID = [rs stringForColumn:@"catalogID"];
        info.isSelectd = [rs stringForColumn:@"isSelectd"];
        [array addObject:info];
    }

    [rs close];
    return array;
}

@end
