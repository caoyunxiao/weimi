//
//  HTTPPostManger.m
//  请求
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "HTTPPostManger.h"

@implementation HTTPPostManger

+(void)requestWithURL:(NSString *)url bodyString:(NSString *)bodyString finish:(FinishBlock)finishBlock Failed:(FaileBlock)failedBlock;
{
    HTTPPostRequest *request = [[HTTPPostRequest alloc]init];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    request.url = url;
    
    request.bodyString = bodyString;
    
    request.finishBlock = finishBlock;
    request.faileBlock = failedBlock;
    
    [request startRequest];
}


+ (void)requestWithURL:(NSString *)url accountID:(NSString *)accountID parameterType:(int)parameterType phoneImei:(NSString *)phoneImei fileName:(NSString *)fileNameURL finish:(FinishBlock)finishBlock Failed:(FaileBlock)failedBlock;
{
    HTTPPostRequest *request = [[HTTPPostRequest alloc]init];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    request.url = url;
    
    request.fileNameString = fileNameURL;
    request.accountID = accountID;
    request.parameterType=parameterType;
    request.phoneImei = phoneImei;
    request.finishBlock = finishBlock;
    request.faileBlock = failedBlock;
    
    [request startUpVoiceRequest];
}

+  (NSData *)requestSynchronization:(NSString *)url bodyString:(NSString *)bodyString
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]init];
    [urlRequest setURL:[NSURL URLWithString:url]];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setTimeoutInterval:30];
    
    NSMutableData *bodyData = [[NSMutableData alloc]initWithData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *headerFieldsDic = @{@"Content-Length":[NSString stringWithFormat:@"%ld",(long)bodyData.length]};
    [urlRequest setHTTPBody:bodyData];
    [urlRequest setAllHTTPHeaderFields:headerFieldsDic];
    
    
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    
    
    return data;
}


@end
