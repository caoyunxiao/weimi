//
//  HTTPManger.h
//  异步下载图片
//
//  Created by qianfeng on 14-5-6.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"



@interface HTTPManger : NSObject


+ (void)requestWithURL:(NSString*)url Finish:(FinishBlock)finishBlock Failed:(FailedBlock)failedBlock;


@end
