//
//  VoiceTableDB.m
//  微密
//
//  Created by iOS Dev on 14-8-29.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "VoiceTableDB.h"
#import "VoiceInfo.h"


#define kVoiceTable @"VoiceTable"


@implementation VoiceTableDB

- (id)init
{
    self = [super init];
    if (self)
    {
        _db = [SDBManager defaultDBManager].dataBase;
    }
    return self;
}

- (NSString *)createVoiceDataBase
{
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kVoiceTable]];
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
        NSString * sql = @"CREATE TABLE VoiceTable (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, cityName VARCHAR(20), lastTime VARCHAR(20) ,fileURL VARCHAR(100) ,remark VARCHAR(255),duration VARCHAR(20),idx VARCHAR(20),locationURL VARCHAR(255))";
        BOOL res = [_db executeUpdate:sql];
        
        
        if (!res)
        {
            return @"数据库创建失败";
        }
        else
        {
            return @"数据库创建成功";
        }
    }
}


- (BOOL)jugde:(NSString *)idx
{
    
    NSArray *array = [self selectVoiceAll];
    
    
    for (NSString *idxString in array)
    {
        if ([idxString isEqualToString:idx])
        {
            return NO;
        }
    }
    return YES;
}

- (void)addVoice:(VoiceInfo *)VoiceInfo
{
    if (![self jugde:VoiceInfo.idx])
    {
        return;
    }
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO VoiceTable"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [[NSMutableArray alloc]init];
    if (VoiceInfo.cityName) {
        [keys appendString:@"cityName,"];
        [values appendString:@"?,"];
        [arguments addObject:VoiceInfo.cityName];
    }
    if (VoiceInfo.lastTime) {
        [keys appendString:@"lastTime,"];
        [values appendString:@"?,"];
        [arguments addObject:VoiceInfo.lastTime];
    }
    if (VoiceInfo.fileURL) {
        [keys appendString:@"fileURL,"];
        [values appendString:@"?,"];
        [arguments addObject:VoiceInfo.fileURL];
    }
    if (VoiceInfo.remark) {
        [keys appendString:@"remark,"];
        [values appendString:@"?,"];
        [arguments addObject:VoiceInfo.remark];
    }
    if (VoiceInfo.duration) {
        [keys appendString:@"duration,"];
        [values appendString:@"?,"];
        [arguments addObject:VoiceInfo.duration];
    }
    if (VoiceInfo.idx) {
        [keys appendString:@"idx,"];
        [values appendString:@"?,"];
        [arguments addObject:VoiceInfo.idx];
    }

    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
    [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
    [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    
    [_db executeUpdate:query withArgumentsInArray:arguments];
}


- (void)deleteVoiceTable
{
    NSString * query = [NSString stringWithFormat:@"DELETE FROM VoiceTable"];
    [_db executeUpdate:query];
}


- (NSArray *)selectVoiceLimit:(int)limit
{
    NSString * query = @"SELECT * FROM VoiceTable";
    
    query = [query stringByAppendingFormat:@" ORDER BY lastTime desc limit %d",limit];
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next])
    {
        VoiceInfo *info = [[VoiceInfo alloc]init];
        
        info.cityName = [rs stringForColumn:@"cityName"];
        info.lastTime = [rs stringForColumn:@"lastTime"];
        info.fileURL = [rs stringForColumn:@"fileURL"];
        info.remark = [rs stringForColumn:@"remark"];
        info.duration = [rs stringForColumn:@"duration"];
        info.idx = [rs stringForColumn:@"idx"];
        info.locationURL = [rs stringForColumn:@"locationURL"];
        [array addObject:info];
    }
    
    [rs close];
    return array;
}


- (NSMutableArray *)selectVoiceAll
{
    NSString * query = @"SELECT * FROM VoiceTable";
    
    FMResultSet * rs = [_db executeQuery:query];
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next])
    {
        NSString *idex = [rs stringForColumn:@"idx"];
        [array addObject:idex];
    }
    
    [rs close];
    return array;
}

- (NSString *)selectLocationURL:(NSString *)networkURL
{
    NSString * query =[NSString stringWithFormat:@"SELECT * FROM VoiceTable where fileURL = '%@'",networkURL];
    
    FMResultSet * rs = [_db executeQuery:query];
    
    [rs columnCount];
    
    NSString *locationString = nil ;
    
    while ([rs next])
    {
        locationString = [rs stringForColumn:@"locationURL"];
    }
    return locationString;
}



- (void)updataWithVoice:(NSString *)netWorkURL location:(NSString *)locationURL;
{
    if (!netWorkURL)
    {
        return;
    }
    
    NSString * query = @"UPDATE VoiceTable SET";
    
    NSMutableString * temp = [[NSMutableString alloc]init];
    
    
    if (locationURL)
    {
        [temp appendFormat:@" locationURL = '%@',",locationURL];
    }
    
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE fileURL = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],netWorkURL];
        
    [_db executeUpdate:query];
}


@end
