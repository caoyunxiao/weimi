//
//  VersionsModel.m
//  微密
//
//  Created by iOS Dev on 14-8-25.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "VersionsModel.h"
#import "AFHTTPRequestOperationManager.h"
@implementation VersionsModel


- (void)versionUpdate:(NSString *)appId version:(VersionBlock)version
{ 
     NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appId];
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSMutableArray * array = [responseObject objectForKey:@"results"];
            NSDictionary * dic = [array firstObject];
            NSString * versions = [dic objectForKey:@"version"];
            if (version)
            {
                version(versions);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
