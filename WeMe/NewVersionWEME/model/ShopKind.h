//
//  ShopKind.h
//  微密
//
//  Created by wemeDev on 15/1/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopKind : NSObject


@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * goodsSubType;
@property (nonatomic,copy) NSString * sort;

@property (nonatomic,copy) NSString * kind;

+ (NSArray*)getModelArrayWtih:(NSArray*)arr;

@end
