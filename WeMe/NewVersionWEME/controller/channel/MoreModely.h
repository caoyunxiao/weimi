//
//  MoreModely.h
//  微密
//
//  Created by mirrtalk on 15/5/29.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreModely : NSObject
@property(nonatomic,copy)NSString * picUrl;//图片
@property(nonatomic,copy)NSString * appName;//
@property(nonatomic,copy)NSString * url;//
@property(nonatomic,copy)NSString * remark;//
@property(nonatomic,copy)NSString * markType;//消息类型
@property(nonatomic,copy)NSString * close;
@property(nonatomic,copy)NSString * seconds;
@property(nonatomic,copy)NSString * urlRedirect;

+(MoreModely*)getModelWithDic:(NSDictionary *)dic;
@end
