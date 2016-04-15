//
//  TravelModel.m
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "TravelModel.h"
#import "HTTPPostManger.h"
#import "TravelInfo.h"
#import "NSString+Float.h"
#import "TravelDataBase.h"

//张福杰zfj
@implementation TravelModel

- (id)init
{
    self = [super init];
    if (self)
    {
        _ponitsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)travelPathWithID:(NSString *)travelID travels:(TravelModelBlock)travels
{
     NSString *bodyString = [NSString stringWithFormat:@"travelID=%@&%@",travelID,SecretOrAppkey];

    [_ponitsArray removeAllObjects];
    
    TravelDataBase *db = [[TravelDataBase alloc]init];
    
    [db createDataBase];
    
    NSArray *dbArray = [db selectAllPath:travelID];
    
    if ([dbArray count] > 0)
    {
        NSUInteger dCount = [dbArray count];
        
        for (int i = 0; i < dCount; i++)
        {
            [_ponitsArray addObject:[dbArray objectAtIndex:i]];
        }
        if (travels)
        {
            travels(_ponitsArray);
        }
        return;
    }
    
   
    
    [HTTPPostManger requestWithURL:LOGINURL(@"getRouteWayToRoadList.do") bodyString:bodyString finish:^(NSData *data)
     {
         
         id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         //NSLog(@"jsonObject :: %@",jsonObject);
         if ([jsonObject isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dataDict = (NSDictionary *)jsonObject;
             
             if ([[dataDict objectForKey:@"ERRORCODE"] isEqualToString:@"0"])
             {
                 
                 id aObject = [dataDict objectForKey:@"RESULT"];
                 
                 if ([aObject isKindOfClass:[NSArray class]])
                 {
                     NSArray *array = (NSArray *)aObject;

                     NSUInteger pCount = [array count];
                     
                     for (int i = 0; i < pCount; i++)
                     {
                         TravelInfo *sInfo = [[TravelInfo alloc]init];
                         TravelInfo *eInfo = [[TravelInfo alloc]init];
                         
                         long sLatitude = [[[array objectAtIndex:i] objectForKey:@"startLatitude"] longValue];
                         long sLongitude = [[[array objectAtIndex:i] objectForKey:@"startLongitude"] longValue];
                         long eLatitude = [[[array objectAtIndex:i] objectForKey:@"endLatitude"] longValue];
                         
                         long eLongitude = [[[array objectAtIndex:i] objectForKey:@"endLongitude"] longValue];
                         
                         NSMutableString *sLaString = [NSMutableString stringWithFormat:@"%ld",sLatitude];
                         
                         NSMutableString *sLoString = [NSMutableString stringWithFormat:@"%ld",sLongitude];
                         
                         NSMutableString *eLaString = [NSMutableString stringWithFormat:@"%ld",eLatitude];
                         
                         NSMutableString *eLoString = [NSMutableString stringWithFormat:@"%ld",eLongitude];
                         
                         sInfo.latitudeString = [NSString stringWithFloat:sLaString atIndex:2];
                         sInfo.longitudeString = [NSString stringWithFloat:sLoString atIndex:3];
                         
                         eInfo.latitudeString = [NSString stringWithFloat:eLaString atIndex:2];
                         eInfo.longitudeString = [NSString stringWithFloat:eLoString atIndex:3];
                        
                         [db addPathTracel:travelID latAndLong:eInfo];
                         [_ponitsArray addObject:eInfo];
                     }
                 }
             }
         }
         
        if (travels)
        {
             travels(_ponitsArray);
        }
         
    } Failed:^(NSError *error)
    {
        if (travels)
        {
            travels(_ponitsArray);
        }
    }];
}

@end
