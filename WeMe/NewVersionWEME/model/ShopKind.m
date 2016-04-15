//
//  ShopKind.m
//  微密
//
//  Created by wemeDev on 15/1/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ShopKind.h"

@implementation ShopKind

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (NSArray*)getModelArrayWtih:(NSArray*)arr
{
    NSMutableArray * mArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dic in arr)
    {
        ShopKind * kind = [[ShopKind alloc] init];
        
        [kind setValuesForKeysWithDictionary:dic];
        
        [mArr addObject:kind];
    }
    
    return mArr;
    
}
@end
