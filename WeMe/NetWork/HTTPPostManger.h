//
//  HTTPPostManger.h
//  请求
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPPostRequest.h"


@interface HTTPPostManger : NSObject

+  (void)requestWithURL:(NSString *)url bodyString:(NSString *)bodyString finish:(FinishBlock)finishBlock Failed:(FaileBlock)failedBlock;

+  (NSData *)requestSynchronization:(NSString *)url bodyString:(NSString *)bodyString;

+ (void)requestWithURL:(NSString *)url accountID:(NSString *)accountID parameterType:(int)parameterType phoneImei:(NSString *)phoneImei fileName:(NSString *)fileNameURL finish:(FinishBlock)finishBlock Failed:(FaileBlock)failedBlock;

@end
