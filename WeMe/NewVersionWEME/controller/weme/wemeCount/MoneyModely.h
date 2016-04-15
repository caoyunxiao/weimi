//
//  MoneyModely.h
//  微密
//
//  Created by mirrtalk on 15/6/9.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyModely : NSObject
@property(nonatomic,copy)NSString * name;//名字
@property(nonatomic,copy)NSString * icon;//图标
@property(nonatomic,copy)NSString * url;//链接
@property(nonatomic,copy)NSString * createTime;//
@property(nonatomic,copy)NSString * mid;//

+(MoneyModely *)getModelWithDic:(NSDictionary *)dic;
@end
