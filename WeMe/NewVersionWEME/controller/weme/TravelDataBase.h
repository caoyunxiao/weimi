//
//  TravelDataBase.h
//  微密
//
//  Created by iOS Dev on 14-8-28.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TravelInfo.h"
#import "SDBManager.h"


@interface TravelDataBase : NSObject
{
    FMDatabase *_db;
}

- (NSString *)createDataBase;

- (void)addPathTracel:(NSString *)travelIDString latAndLong:(TravelInfo *)latAndLong;

- (void)deletePathTracelTable;

- (NSArray *)selectAllPath:(NSString *)travelIDString;

@end
