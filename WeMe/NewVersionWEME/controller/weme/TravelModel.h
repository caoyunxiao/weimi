//
//  TravelModel.h
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^TravelModelBlock)(NSMutableArray *travelPoints);


@interface TravelModel : NSObject
{
    NSMutableArray   *_ponitsArray;
}

- (void)travelPathWithID:(NSString *)travelID travels:(TravelModelBlock)travels;

@end
