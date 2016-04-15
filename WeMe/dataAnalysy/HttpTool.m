//
//  HttpTool.m
//  WeMe
//
//  Created by weme on 15/10/29.
//  Copyright © 2015年 chenjie. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

/**
 *  AFNetworking的GET请求
 *
 *  @param URLString    请求网址
 *  @param parameters   网址参数
 *  @param timeInterval 超时时间
 *  @param requestType  请求类型
 *  @param responseType 返回结果类型
 *  @param success      成功时调用的block
 *  @param failure      失败时调用的block
 *
 *  @return AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                timeoutInterval:(NSNumber *)timeInterval
                    requestType:(AFNetworkingRequestType)requestType
                   responseType:(AFNetworkingResponseType)responseType
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // 请求类型
    manager.requestSerializer=[HttpTool requestSerializerWith:requestType];
    // 回复类型
    manager.responseSerializer=[HttpTool responseSerializerWith:responseType];
    // 回复内容信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // 设置超时时间 nil为afn默认
    if (timeInterval) {
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = timeInterval.floatValue;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    
    
    AFHTTPRequestOperation *httpOperation = [manager GET:URLString
                                              parameters:parameters
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if (success) {
                                                         success(operation, responseObject);
                                                     }
                                                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if (failure) {
                                                         failure(operation, error);
                                                     }
                                                 }];
    
    
    return httpOperation;
}


/**
 *  AFNetworking的POST请求
 *
 *  @param URLString    请求网址
 *  @param parameters   网址参数
 *  @param timeInterval 超时时间
 *  @param requestType  请求类型
 *  @param responseType 返回结果类型
 *  @param success      成功时调用的block
 *  @param failure      失败时调用的block
 *
 *  @return AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                 timeoutInterval:(NSNumber *)timeInterval
                     requestType:(AFNetworkingRequestType)requestType
                    responseType:(AFNetworkingResponseType)responseType
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // 请求类型
    manager.requestSerializer=[HttpTool requestSerializerWith:requestType];
    // 回复类型
    manager.responseSerializer= [HttpTool responseSerializerWith:responseType];
    // 设置回复内容信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    // 设置超时时间
    if (timeInterval) {
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = timeInterval.floatValue;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    AFHTTPRequestOperation *httpOperation = [manager POST:URLString
                                               parameters:parameters
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      if (success) {
                                                          success(operation, responseObject);
                                                      }
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      if (failure) {
                                                          failure(operation, error);
                                                      }
                                                  }];
    return httpOperation;
}

/**
 *  请求类型
 *
 *  @param serializerType AFNetworkingRequestType
 *
 *  @return AFHTTPRequestSerializer
 */
+ (AFHTTPRequestSerializer *)requestSerializerWith:(AFNetworkingRequestType)serializerType {
    if (serializerType == JSONRequestType) {
        return [AFJSONRequestSerializer serializer];
    } else if (serializerType == HTTPRequestType) {
        return [AFHTTPRequestSerializer serializer];
    } else if (serializerType == PlistRequestType) {
        return [AFPropertyListRequestSerializer serializer];
    } else {
        return nil;
    }
}

/**
 *  返回类型
 *
 *  @param serializerType AFNetworkingResponseType
 *
 *  @return AFHTTPResponseSerializer
 */
+ (AFHTTPResponseSerializer *)responseSerializerWith:(AFNetworkingResponseType)serializerType {
    if (serializerType == JSONResponseType) {
        return [AFJSONResponseSerializer serializer];
    } else if (serializerType == HTTPResponseType) {
        return [AFHTTPResponseSerializer serializer];
    } else if (serializerType == PlistResponseType) {
        return [AFPropertyListResponseSerializer serializer];
    } else if (serializerType == ImageResponseType) {
        return [AFImageResponseSerializer serializer];
    } else if (serializerType == CompoundResponseType) {
        return [AFCompoundResponseSerializer serializer];
    } else {
        return nil;
    }
}


@end
