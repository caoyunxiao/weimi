//
//  HTTPRequest.h
//  异步下载图片
//
//  Created by qianfeng on 14-5-6.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishBlock)(NSData *data);
typedef void (^FailedBlock)(NSError *error);

@interface HTTPRequest : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData   *_mData;
}

@property(nonatomic,copy)NSString* url;

@property(nonatomic,copy)FinishBlock  finishBlock;
@property(nonatomic,copy)FailedBlock  failedBlock;


- (void)startRequest;

@end
