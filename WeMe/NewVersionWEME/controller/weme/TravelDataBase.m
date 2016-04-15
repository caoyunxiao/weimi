//
//  TravelDataBase.m
//  微密
//
//  Created by iOS Dev on 14-8-28.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "TravelDataBase.h"


#define kPonintDataBaseTable @"PonintDataBaseTable"

@implementation TravelDataBase

- (id)init
{
    self = [super init];
    if (self)
    {
        _db = [SDBManager defaultDBManager].dataBase;
    }
    return self;
}
- (NSString *)createDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kPonintDataBaseTable]];
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
        
        NSString * sql = @"CREATE TABLE PonintDataBaseTable (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,latitudeString VARCHAR(20),longitudeString VARCHAR(20),travelIDString VARCHAR(50))";
        
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

- (void)addPathTracel:(NSString *)travelIDString latAndLong:(TravelInfo *)latAndLong;
{
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO PonintDataBaseTable"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [[NSMutableArray alloc]init];
    if (latAndLong.latitudeString)
    {
        [keys appendString:@"latitudeString,"];
        [values appendString:@"?,"];
        [arguments addObject:latAndLong.latitudeString];
    }
    if (latAndLong.longitudeString)
    {
        [keys appendString:@"longitudeString,"];
        [values appendString:@"?,"];
        [arguments addObject:latAndLong.longitudeString];
    }
    if (travelIDString)
    {
        [keys appendString:@"travelIDString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelIDString];
    }
    
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    
    [_db executeUpdate:query withArgumentsInArray:arguments];
}

- (void)deletePathTracelTable
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM PonintDataBaseTable"];
    [_db executeUpdate:query];
}

- (NSArray *)selectAllPath:(NSString *)travelIDString;
{
    NSString * query =[NSString stringWithFormat: @"SELECT * FROM PonintDataBaseTable WHERE travelIDString = '%@'",travelIDString];
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next])
    {
        TravelInfo *info = [[TravelInfo alloc]init];
        info.latitudeString = [rs stringForColumn:@"latitudeString"];
        info.longitudeString = [rs stringForColumn:@"longitudeString"];
        
        [array addObject:info];
    }
    
    [rs close];
    
    return array;
}

@end
