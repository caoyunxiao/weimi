//
//  HTTPPostRequest.h
//  请求
//
//  Created by longlz on 14-7-17.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^FaileBlock)(NSError *error);
typedef void(^FinishBlock)(NSData *data);

@interface HTTPPostRequest : NSObject

@property(copy,nonatomic)NSString *url;
@property(copy,nonatomic)NSString *bodyString;
@property(copy,nonatomic)NSString *fileNameString;
@property(copy,nonatomic)NSString *accountID;
@property(assign,nonatomic)int parameterType;
@property(copy,nonatomic)NSString *phoneImei;


@property(copy,nonatomic)FaileBlock faileBlock;
@property(copy,nonatomic)FinishBlock finishBlock;


- (void)startRequest;

- (void)startUpVoiceRequest;

@end
