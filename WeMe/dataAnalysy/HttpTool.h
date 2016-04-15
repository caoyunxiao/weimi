//
//  HttpTool.h
//  WeMe
//
//  Created by weme on 14/10/29.
//  Copyright © 2015年 chenjie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    HTTPRequestType = 0x11,      // 二进制格式 (不设置的话为默认格式)
    JSONRequestType,             // JSON方式
    PlistRequestType,            // 集合文件方式
    
} AFNetworkingRequestType;


typedef enum : NSUInteger {
    
    HTTPResponseType = 0x22,     // 二进制格式 (不设置的话为默认格式)
    JSONResponseType,            // JSON方式
    PlistResponseType,           // 集合文件方式
    ImageResponseType,           // 图片方式
    CompoundResponseType,        // 组合方式
    
} AFNetworkingResponseType;

@interface HttpTool : NSObject

/**
 *  AFNetworking的GET请求
 *
 *  @param URLString    请求网址
 *  @param parameters   网址参数
 *  @param timeInterval 超时时间(可以设置为nil)
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
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  AFNetworking的POST请求
 *
 *  @param URLString    请求网址
 *  @param parameters   网址参数
 *  @param timeInterval 超时时间(可以设置为nil)
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
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
