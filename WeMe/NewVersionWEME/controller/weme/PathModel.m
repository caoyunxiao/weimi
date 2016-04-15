//
//  PathModel.m
//  微密
//
//  Created by longlz on 14-7-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "PathModel.h"
#import "PathTravelInfo.h"
#import "HTTPPostManger.h"
#import "PathDetailInfo.h"
#import "NSString+Time.h"
#import "Request1617.h"

//张福杰zfj
@implementation PathModel

- (id)init
{
    self = [super init];
    if (self)
    {
        _travelArray = [[NSMutableArray alloc]init];
        _currentPage = 1;
        _currentPageSize = 10;
        
        _db = [[PathTracelDataBase alloc]init];
        [_db createDataBase];
        
        _accountID = [PersonInfo sharePersonInfo].accountIDString;
    }
    return self;
}

- (NSString *)dateFormatWithSeconds:(long long int)totalSeconds
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *timeString = [NSString stringWithFormat:@"%@",localeDate];
    
    return [timeString substringToIndex:19];
}


#pragma mark
#pragma mark -- 刷新
- (void)pathTravelRefrsh:(PathTravelBlock)pathTravelBlock;
{
    [_travelArray removeAllObjects];
    _currentPage = 1;
    _currentPageSize = 8;
    NSDictionary * dic = @{@"accountID":_accountID,@"pageNumber":[NSString stringWithFormat:@"%ld",_currentPage],@"pageSize":[NSString stringWithFormat:@"%ld",_currentPageSize],@"appKey":@"iOS"};
    [RequestEngine updateRoutePathWithStr:dic complete:^(NSString *errorCode, NSArray *dateArray) {
        if ([errorCode isEqualToString:@"0"])
        {
            [self analysisArray:dateArray];
        }
        else
        {
            NSArray *dbArray = [_db selectVoiceLimit:_currentPageSize accountID:_accountID];
            
            if ([dbArray count] > 0)
            {
                [self analysisHisstoryArray:dbArray];
            }
        }
        if (pathTravelBlock)
        {
            pathTravelBlock(_travelArray);
        }
    }];
}


- (void)analysisArray:(NSArray *)array
{
    int count = (int)[array count];
    
    for (int i = 0; i < count; i++)
    {
        PathTravelInfo *info = [[PathTravelInfo alloc]init];
        
        long long int startTime =[[[array objectAtIndex:i]objectForKey:@"startTime"] longLongValue];
        long long int endTime = [[[array objectAtIndex:i]objectForKey:@"endTime"] longLongValue];
        
        NSString *startTimeSt = [[NSString dateFormatWithSeconds:startTime] substringToIndex:10];
        NSString * startTimeString = [NSString getString:startTimeSt];
        NSString *endTimeString = [NSString dateFormatWithSeconds:endTime];
        
        info.startTimeString = [NSString dateFormatWithSeconds:startTime];
        info.endTimeString = endTimeString;
        
        info.startRouteNameString =[[array objectAtIndex:i]objectForKey:@"startRoadName"];
        
        info.endRouteNameString =[[array objectAtIndex:i]objectForKey:@"endRoadName"];
        
        info.startCityNameString =[[array objectAtIndex:i]objectForKey:@"startCityName"];
        
        info.endCityNameString = [[array objectAtIndex:i]objectForKey:@"endCityName"];
        
        int average = [[[array objectAtIndex:i]objectForKey:@"averageSpeed"] intValue];
        
        info.averageSpeedString = [NSString stringWithFormat:@"%d",average];
        
        int max = [[[array objectAtIndex:i]objectForKey:@"maximumSpeed"] intValue];
        
        info.maxSpeedString =[NSString stringWithFormat:@"%d",max];
        
        int sum = [[[array objectAtIndex:i]objectForKey:@"actualMileage"] intValue];
        
        info.sumMileageString = [NSString stringWithFormat:@"%.3f",sum / 1000.0];
        
        int total = [[[array objectAtIndex:i]objectForKey:@"totalTime"] intValue] / 60;
        
        info.totalTimeString = [NSString stringWithFormat:@"%d",total];
        
        info.detailInfo = [self pathDetailInfoWithArray:array atIndex:i];
        
        [_db addPathTracel:info accountID:_accountID];
        
        int j;
        int tCount = (int)[_travelArray count];
        
        for (j = 0; j < tCount; j++)
        {
            NSString *dString = [[[_travelArray objectAtIndex:j] objectForKey:kDateString] substringToIndex:10];
            
            if ([startTimeString isEqualToString:dString])
            {
                [[[_travelArray objectAtIndex:j] objectForKey:kTravelString] addObject:info];
                break;
            }
        }
        if (j == tCount)
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:info];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:startTimeString,kDateString, array,kTravelString,nil];
            [_travelArray addObject:dict];
        }
    }
}


- (void)analysisHisstoryArray:(NSArray *)array
{
    int count = (int)[array count];
    
    for (int i = 0; i < count; i++)
    {
        PathTravelInfo *info = [array objectAtIndex:i];
        
        NSString *startTimeString =[info.startTimeString substringToIndex:10];
        
        int j;
        int tCount = (int)[_travelArray count];
        
        for (j = 0; j < tCount; j++)
        {
            NSString *dString = [[[_travelArray objectAtIndex:j] objectForKey:kDateString] substringToIndex:10];
            
            if ([startTimeString isEqualToString:dString])
            {
                [[[_travelArray objectAtIndex:j] objectForKey:kTravelString] addObject:info];
                break;
            }
        }
        
        if (j == tCount)
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:info];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:startTimeString,kDateString, array,kTravelString,nil];
            [_travelArray addObject:dict];
        }
    }
}


- (PathDetailInfo *)pathDetailInfoWithArray:(NSArray *)array atIndex:(int)index
{
    PathDetailInfo *info = [[PathDetailInfo alloc]init];
    
    if ([array count] - 1 < index)
    {
        return nil;
    }
    
    int cityGrade = [[[array objectAtIndex:index]objectForKey:@"cityGrade"] intValue];
    
    int isSpeedGrade = [[[array objectAtIndex:index]objectForKey:@"isSpeedGrade"] intValue];
    
    int gsensorGrade = [[[array objectAtIndex:index]objectForKey:@"gsensorGrade"] intValue];
    int habitGrade = [[[array objectAtIndex:index]objectForKey:@"habitGrade"] intValue];
    int roadInfoGrade = [[[array objectAtIndex:index]objectForKey:@"roadInfoGrade"] intValue];
    int speedGrade = [[[array objectAtIndex:index]objectForKey:@"speedGrade"] intValue];
    int timeGrade = [[[array objectAtIndex:index]objectForKey:@"timeGrade"] intValue];
    int travelGrade = [[[array objectAtIndex:index]objectForKey:@"travelGrade"] intValue];
    
    info.cityGradeString = [NSString stringWithFormat:@"%d",cityGrade];
    info.isSpeedGradeString = [NSString stringWithFormat:@"%d",isSpeedGrade];
    info.gsensorGradeString = [NSString stringWithFormat:@"%d",gsensorGrade];
    info.habitGradeString = [NSString stringWithFormat:@"%d",habitGrade];
    
    info.roadInfoGradeString = [NSString stringWithFormat:@"%d",roadInfoGrade];
    info.speedGradeString = [NSString stringWithFormat:@"%d",speedGrade];
    info.timeGradeString = [NSString stringWithFormat:@"%d",timeGrade];
    
    info.travelGradeString = [NSString stringWithFormat:@"%d",travelGrade];
    
    info.travelIDString = [[array objectAtIndex:index]objectForKey:@"travelID"];

    return info;
}

#pragma mark
#pragma mark -- 下拉加载更多

- (void)pathTravelLoadMore:(PathTravelBlock)pathTravelBlock
{
    ++_currentPage;
    _currentPageSize = 8;
     NSDictionary * dic = @{@"accountID":_accountID,@"pageNumber":[NSString stringWithFormat:@"%ld",_currentPage],@"pageSize":[NSString stringWithFormat:@"%ld",_currentPageSize],@"appKey":@"iOS"};
    [RequestEngine updateRoutePathWithStr:dic complete:^(NSString *errorCode, NSArray *dateArray) {
        if ([errorCode isEqualToString:@"0"])
        {
            [self analysisArray:dateArray];
        }
        else
        {
            --_currentPage;
            if (_currentPage==0)
            {
                _currentPage=1;
            }
        }
        if (pathTravelBlock)
        {
            pathTravelBlock(_travelArray);
        }
    }];
}


#pragma mark
#pragma mark -- 请求最新的一条数据
- (void)pathOneTraveRefrsh:(PathOneTravelBlock)pathTravelBlock
{
    NSString *bodyString = [NSString stringWithFormat:@"accountID=%@&pageNumber=%d&pageSize=%d&%@",[PersonInfo sharePersonInfo].accountIDString,1,1,SecretOrAppkey];
    
    __block PathTravelInfo *info = [[PathTravelInfo alloc]init];
    
    [HTTPPostManger requestWithURL:LOGINURL(@"getRouteList.do") bodyString:bodyString finish:^(NSData *data)
     {
         
         id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         
         if ([jsonObject isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dataDict = (NSDictionary *)jsonObject;
             
             if ([[dataDict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
             {
                 id aObject = [dataDict objectForKey:@"RESULT"];
                 
                 if ([aObject isKindOfClass:[NSArray class]])
                 {
                     NSArray *array = (NSArray *)aObject;
                     
                     int count = (int)[array count];
                     
                     for (int i = 0; i < count; i++)
                     {
                         long long int startTime =[[[array objectAtIndex:i]objectForKey:@"startTime"] longLongValue];
                         long long int endTime =[[[array objectAtIndex:i]objectForKey:@"endTime"] longLongValue];
                         
                         NSString *endTimeString = [self dateFormatWithSeconds:endTime];
                         
                         info.startTimeString = [NSString dateFormatWithSeconds:startTime];
                         info.endTimeString = endTimeString;
                         
                         info.startRouteNameString =[[array objectAtIndex:i]objectForKey:@"startRoadName"];
                         info.endRouteNameString =[[array objectAtIndex:i]objectForKey:@"endRoadName"];
                         info.startCityNameString =[[array objectAtIndex:i]objectForKey:@"startCityName"];
                         
                         
                         int average = [[[array objectAtIndex:i]objectForKey:@"averageSpeed"] intValue];
                         
                         info.averageSpeedString = [NSString stringWithFormat:@"%d",average];
                         
                         int max = [[[array objectAtIndex:i]objectForKey:@"maximumSpeed"] intValue];
                         
                         info.maxSpeedString =[NSString stringWithFormat:@"%d",max];
                         
                         int sum = [[[array objectAtIndex:i]objectForKey:@"sumMileage"] intValue];
                         
                         info.sumMileageString = [NSString stringWithFormat:@"%.3f",sum / 1000.0];
                         
                         int total = [[[array objectAtIndex:i]objectForKey:@"totalTime"] intValue];
                         
                         info.totalTimeString = [NSString stringWithFormat:@"%d",total / 100];
                         
                         info.detailInfo = [self pathDetailInfoWithArray:array atIndex:i];
                         
                         //保存数据库
                         [_db addPathTracel:info accountID:_accountID];
                         
                         if (pathTravelBlock)
                         {
                             pathTravelBlock(info);
                         }
                     }
                 
                 }
                 else
                 {
                     if (pathTravelBlock)
                     {
                         pathTravelBlock(nil);
                     }
                 }
             }
             else
             {
                 NSArray *onepathInfo = [_db selectVoiceLimit:1 accountID:_accountID];
                 
                 if ([onepathInfo count] > 0)
                 {
                     if (pathTravelBlock)
                     {
                         pathTravelBlock([onepathInfo objectAtIndex:0]);
                     }
                 }
                 else
                 {
                     if (pathTravelBlock)
                     {
                         pathTravelBlock(nil);
                     }
                 }
             }
             
         }else
         {
             NSArray *onepathInfo = [_db selectVoiceLimit:1 accountID:_accountID];
             
             if ([onepathInfo count] > 0)
             {
                 if (pathTravelBlock)
                 {
                     pathTravelBlock([onepathInfo objectAtIndex:0]);
                 }
             }else
             {
                 if (pathTravelBlock)
                 {
                     pathTravelBlock(nil);
                 }
             }
         }
         
     } Failed:^(NSError *error)
     {
         NSArray *onepathInfo = [_db selectVoiceLimit:1 accountID:_accountID];
         
         if ([onepathInfo count] > 0)
         {
             if (pathTravelBlock)
             {
                 pathTravelBlock([onepathInfo objectAtIndex:0]);
             }
         }
         else
         {
             if (pathTravelBlock)
             {
                 pathTravelBlock(nil);
             }
         }
     }];
}
@end
