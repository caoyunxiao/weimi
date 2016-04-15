//
//  HTTPPostRequest.m
//  请求
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "HTTPPostRequest.h"




@implementation HTTPPostRequest

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)startRequest
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]init];
    [urlRequest setURL:[NSURL URLWithString:self.url]];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setTimeoutInterval:30];
    
    NSMutableData *bodyData = [[NSMutableData alloc]initWithData:[self.bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *headerFieldsDic = @{
                                      @"Content-Length":[NSString stringWithFormat:@"%ld",(long)bodyData.length]
                                      };
    [urlRequest setHTTPBody:bodyData];
    [urlRequest setAllHTTPHeaderFields:headerFieldsDic];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (connectionError != nil)
        {
            self.faileBlock(connectionError);
        }
        else if (data != nil)
        {
            self.finishBlock(data);
        }
    }];
}


- (void)startUpVoiceRequest
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]init];
    
    [urlRequest setURL:[NSURL URLWithString:self.url]];
    
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *beginBodyStr = [NSString stringWithFormat:@"--0xKhTmLbOuNdArY\r\nContent-Disposition: form-data;name=\"appKey\"\r\n\r\n%@\r\n--0xKhTmLbOuNdArY\r\nContent-Disposition: form-data;name=\"secret\"\r\n\r\n%@\r\n--0xKhTmLbOuNdArY\r\nContent-Disposition: form-data;name=\"accountID\"\r\n\r\n%@\r\n--0xKhTmLbOuNdArY\r\nContent-Disposition: form-data;name=\"parameterType\"\r\n\r\n%d\r\n--0xKhTmLbOuNdArY\r\nContent-Disposition: form-data;name=\"phoneImei\"\r\n\r\n%@\r\n--0xKhTmLbOuNdArY\r\nContent-Disposition: form-data;name=\"file\";filename=\"%@\"\r\n\r\n",@"286302235",@"CD5ED55440C21DAF3133C322FEDE2B63D1E85949",self.accountID,self.parameterType,self.phoneImei,[self.fileNameString substringFromIndex:5]];
    
    NSString *endBodyStr = @"\r\n--0xKhTmLbOuNdArY--\r\n";
    NSMutableData *bodyData = [[NSMutableData alloc]initWithData:[beginBodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *voiceData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",self.fileNameString]];
    
    
    [bodyData appendData:voiceData];
    
    [bodyData appendData:[endBodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *headerFieldsDic = @{
                                      @"Content-Type":@"multipart/form-data;boundary=0xKhTmLbOuNdArY",
                                      @"Content-Length":[NSString stringWithFormat:@"%ld",(long)bodyData.length]
                                      };
    [urlRequest setHTTPBody:bodyData];
    
    //NSLog(@"%@%@",headerFieldsDic,self.url);
    
    
    [urlRequest setAllHTTPHeaderFields:headerFieldsDic];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         if (connectionError != nil)
         {
             self.faileBlock(connectionError);
         }
         else if (data != nil)
         {
             self.finishBlock(data);
         }
     }];
}


@end
