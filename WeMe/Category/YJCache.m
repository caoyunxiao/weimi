//
//  YJCache.m
//  微密
//
//  Created by iOS Dev on 14-9-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "YJCache.h"

@implementation YJCache



- (float)yjCacheSize
{
    long long cacheSize = 0;
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *p in files)
    {
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([manager fileExistsAtPath:path])
        {
            cacheSize += [[manager attributesOfItemAtPath:path error:nil]fileSize];
        }
    }
    return cacheSize / 1024.0 /1024.0;
}


- (void)yjRemoveCache:(RemoveCacheBlock)finish
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files)
                       {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                           {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if (finish)
                           {
                               finish();
                           }
                       });
                       
                   });
}

@end
