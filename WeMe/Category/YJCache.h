//
//  YJCache.h
//  微密
//
//  Created by iOS Dev on 14-9-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RemoveCacheBlock)();

@interface YJCache : NSObject


- (float)yjCacheSize;

- (void)yjRemoveCache:(RemoveCacheBlock)finish;


@end
