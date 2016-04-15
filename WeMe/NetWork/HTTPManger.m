//
//  HTTPManger.m
//  异步下载图片
//
//  Created by qianfeng on 14-5-6.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "HTTPManger.h"

@implementation HTTPManger


+ (void)requestWithURL:(NSString *)url Finish:(FinishBlock)finishBlock Failed:(FailedBlock)failedBlock
{
    HTTPRequest* request = [[[HTTPRequest alloc]init]autorelease];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.url = url;
    request.finishBlock = finishBlock;
    request.failedBlock = failedBlock;
    [request startRequest];
}

@end
