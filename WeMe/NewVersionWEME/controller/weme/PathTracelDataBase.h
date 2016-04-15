//
//  PathTracelDataBase.h
//  微密
//
//  Created by iOS Dev on 14-8-28.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBManager.h"
#import "PathTravelInfo.h"
#import "PathDetailInfo.h"


@interface PathTracelDataBase : NSObject
{
    FMDatabase *_db;
}

- (NSString *)createDataBase;

- (void)addPathTracel:(PathTravelInfo *)travelInfo accountID:(NSString *)accountID;

- (void)deletePathTracelTable;

- (NSArray *)selectVoiceLimit:(NSInteger)limit accountID:(NSString *)accountID;

- (BOOL)judge:(NSString *)travelID accountID:(NSString *)accountID;


@end
