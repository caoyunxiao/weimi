//
//  HTTPRequest.m
//  异步下载图片
//
//  Created by qianfeng on 14-5-6.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "HTTPRequest.h"


@implementation HTTPRequest


- (void)dealloc
{
    [_mData release];
    _mData = nil;
    self.url = nil;
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _mData = [[NSMutableData alloc]init];
    }
    return self;
}


- (void)startRequest
{
    //设置请求数据   并判断需不需要缓存
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    //发起异步请求  立即返回
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    [self retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //开启小转子
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//接受到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.finishBlock(_mData);
    [self release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.failedBlock(error);
    [self release];
}

@end
