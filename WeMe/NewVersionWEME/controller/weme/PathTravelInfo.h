//
//  PathTravelInfo.h
//  微密
//
//  Created by longlz on 14-7-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PathDetailInfo.h"

@interface PathTravelInfo : NSObject

@property(copy,nonatomic)NSString *startTimeString;
@property(copy,nonatomic)NSString *endTimeString;

@property(copy,nonatomic)NSString *startRouteNameString;
@property(copy,nonatomic)NSString *endRouteNameString;

@property(copy,nonatomic)NSString *averageSpeedString;
@property(copy,nonatomic)NSString *maxSpeedString;

@property(copy,nonatomic)NSString *startCityNameString;

@property(copy,nonatomic)NSString *endCityNameString;


@property(copy,nonatomic)NSString *sumMileageString;

@property(copy,nonatomic)NSString *totalTimeString;

@property(strong,nonatomic)PathDetailInfo *detailInfo;

@end
