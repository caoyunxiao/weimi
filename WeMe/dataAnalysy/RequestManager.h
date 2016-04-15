//
//  RequestManager.h
//  DaokeClub
//
//  Created by mirrtalk on 15/4/29.
//  Copyright (c) 2015年 Daoke Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
@interface RequestManager : NSObject
+(AFHTTPRequestOperationManager *)getManager;
@end
