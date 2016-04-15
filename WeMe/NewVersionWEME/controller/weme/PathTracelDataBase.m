//
//  PathTracelDataBase.m
//  微密
//
//  Created by iOS Dev on 14-8-28.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "PathTracelDataBase.h"


#define kPathTracelTableName @"PathTracelTableName"

@implementation PathTracelDataBase


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
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kPathTracelTableName]];
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
        NSString * sql = @"CREATE TABLE PathTracelTableName (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,startTimeString VARCHAR(50),endTimeString VARCHAR(50),startRouteNameString VARCHAR(50),endRouteNameString VARCHAR(50),averageSpeedString VARCHAR(50),maxSpeedString VARCHAR(50),startCityNameString VARCHAR(50),endCityNameString VARCHAR(50),sumMileageString VARCHAR(50),totalTimeString VARCHAR(50),cityGradeString VARCHAR(3),timeGradeString VARCHAR(3),isSpeedGradeString VARCHAR(3),habitGradeString VARCHAR(3),travelGradeString VARCHAR(3),roadInfoGradeString VARCHAR(3),speedGradeString VARCHAR(3),gsensorGradeString VARCHAR(3),travelIDString VARCHAR(50),accountID VARCHAR(15))";
        
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

- (void)addPathTracel:(PathTravelInfo *)travelInfo accountID:(NSString *)accountID
{
    if (![self judge:travelInfo.detailInfo.travelIDString accountID:accountID])
    {
        return;
    }
    
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO PathTracelTableName"];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    NSMutableArray * arguments = [[NSMutableArray alloc]init];
    
    if (travelInfo.startCityNameString)
    {
        [keys appendString:@"startCityNameString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.startCityNameString];
    }
    
    if (travelInfo.startTimeString)
    {
        [keys appendString:@"startTimeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.startTimeString];
    }
    
    if (travelInfo.endTimeString)
    {
        [keys appendString:@"endTimeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.endTimeString];
    }
    if (travelInfo.startRouteNameString)
    {
        [keys appendString:@"startRouteNameString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.startRouteNameString];
    }
    if (travelInfo.endRouteNameString)
    {
        [keys appendString:@"endRouteNameString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.endRouteNameString];
    }
    if (travelInfo.averageSpeedString)
    {
        [keys appendString:@"averageSpeedString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.averageSpeedString];
    }
    if (travelInfo.maxSpeedString)
    {
        [keys appendString:@"maxSpeedString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.maxSpeedString];
    }
    if (travelInfo.endCityNameString)
    {
        [keys appendString:@"endCityNameString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.endCityNameString];
    }
    if (travelInfo.sumMileageString)
    {
        [keys appendString:@"sumMileageString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.sumMileageString];
    }
    if (travelInfo.totalTimeString)
    {
        [keys appendString:@"totalTimeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.totalTimeString];
    }
    if (travelInfo.detailInfo.cityGradeString)
    {
        [keys appendString:@"cityGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.cityGradeString];
    }
    if (travelInfo.detailInfo.timeGradeString)
    {
        [keys appendString:@"timeGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.timeGradeString];
    }
    if (travelInfo.detailInfo.isSpeedGradeString)
    {
        [keys appendString:@"isSpeedGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.isSpeedGradeString];
    }
    if (travelInfo.detailInfo.speedGradeString)
    {
        [keys appendString:@"speedGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.speedGradeString];
    }
    if (travelInfo.detailInfo.habitGradeString)
    {
        [keys appendString:@"habitGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.habitGradeString];
    }
    if (travelInfo.detailInfo.travelGradeString)
    {
        [keys appendString:@"travelGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.travelGradeString];
    }
    if (travelInfo.detailInfo.roadInfoGradeString)
    {
        [keys appendString:@"roadInfoGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.roadInfoGradeString];
    }
    if (travelInfo.detailInfo.cityGradeString)
    {
        [keys appendString:@"cityGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.cityGradeString];
    }
    if (travelInfo.detailInfo.gsensorGradeString)
    {
        [keys appendString:@"gsensorGradeString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.gsensorGradeString];
    }
    if (travelInfo.detailInfo.travelIDString)
    {
        [keys appendString:@"travelIDString,"];
        [values appendString:@"?,"];
        [arguments addObject:travelInfo.detailInfo.travelIDString];
    }
    
    if (accountID != nil)
    {
        [keys appendString:@"accountID,"];
        [values appendString:@"?,"];
        [arguments addObject:accountID];
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
    NSString * query = [NSString stringWithFormat:@"DELETE FROM PathTracelTableName"];
    [_db executeUpdate:query];
}


- (BOOL)judge:(NSString *)travelID accountID:(NSString *)accountID
{
    NSArray *array = [self selectAllPath:accountID];
    
    for (NSString *travelIDString in array)
    {
        if ([travelIDString isEqualToString:travelID])
        {
            return NO;
        }
    }
    
    return YES;
}


- (NSArray *)selectVoiceLimit:(NSInteger)limit accountID:(NSString *)accountID
{
    NSString * query =[NSString stringWithFormat:@"SELECT * FROM PathTracelTableName where accountID = '%@'",accountID] ;
    
    query = [query stringByAppendingFormat:@" ORDER BY startTimeString desc limit %ld",limit];
    
    FMResultSet * rs = [_db executeQuery:query];
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next])
    {
        PathTravelInfo *travelInfo = [[PathTravelInfo alloc]init];
        PathDetailInfo *detailInfo = [[PathDetailInfo alloc]init];
        travelInfo.startTimeString = [rs stringForColumn:@"startTimeString"];
        travelInfo.endTimeString = [rs stringForColumn:@"endTimeString"];
        travelInfo.startRouteNameString = [rs stringForColumn:@"startRouteNameString"];
        travelInfo.endRouteNameString = [rs stringForColumn:@"endRouteNameString"];
        travelInfo.averageSpeedString = [rs stringForColumn:@"averageSpeedString"];
        travelInfo.maxSpeedString = [rs stringForColumn:@"maxSpeedString"];
        travelInfo.startCityNameString = [rs stringForColumn:@"startCityNameString"];
        travelInfo.endCityNameString = [rs stringForColumn:@"endCityNameString"];
        travelInfo.sumMileageString = [rs stringForColumn:@"sumMileageString"];
        travelInfo.totalTimeString = [rs stringForColumn:@"totalTimeString"];
        
        detailInfo.cityGradeString = [rs stringForColumn:@"cityGradeString"];
        detailInfo.timeGradeString = [rs stringForColumn:@"timeGradeString"];
        detailInfo.isSpeedGradeString = [rs stringForColumn:@"isSpeedGradeString"];
        detailInfo.habitGradeString = [rs stringForColumn:@"habitGradeString"];
        detailInfo.travelGradeString = [rs stringForColumn:@"travelGradeString"];
        detailInfo.roadInfoGradeString = [rs stringForColumn:@"roadInfoGradeString"];
        detailInfo.speedGradeString = [rs stringForColumn:@"speedGradeString"];
        detailInfo.gsensorGradeString = [rs stringForColumn:@"gsensorGradeString"];
        detailInfo.travelIDString = [rs stringForColumn:@"travelIDString"];
        travelInfo.detailInfo = detailInfo;
        [array addObject:travelInfo];
    }
    
    [rs close];
    return array;
}



- (NSArray *)selectAllPath:(NSString *)accountID
{
    NSString * query = @"SELECT * FROM PathTracelTableName";
    
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    
    while ([rs next])
    {
        NSString *travelIDString = [rs stringForColumn:@"travelIDString"];
        [array addObject:travelIDString];
    }
    [rs close];
    return array;
}

@end
