//
//  PathModel.h
//  微密
//
//  Created by longlz on 14-7-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathTravelInfo.h"
#import "PathDetailInfo.h"
#import "PathTracelDataBase.h"



typedef void(^PathTravelBlock)(NSMutableArray *travelBlock);

typedef void(^PathRouteWayBlock)(NSMutableArray *routeBlock);

typedef void(^PathOneTravelBlock)(PathTravelInfo *pathTravelInfo);


@interface PathModel : NSObject
{
    NSMutableArray *_travelArray;
    
    NSInteger        _currentPage;
    NSInteger        _currentPageSize;
    
    PathTracelDataBase *_db;
    
    
    NSString *_accountID;
}

- (void)pathTravelRefrsh:(PathTravelBlock)pathTravelBlock;

- (void)pathTravelLoadMore:(PathTravelBlock)pathTravelBlock;


- (void)pathOneTraveRefrsh:(PathOneTravelBlock)pathTravelBlock;

@end
