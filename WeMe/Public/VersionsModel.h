//
//  VersionsModel.h
//  微密
//
//  Created by iOS Dev on 14-8-25.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VersionBlock)(NSString *version);

@interface VersionsModel : NSObject


- (void)versionUpdate:(NSString *)appId version:(VersionBlock)version;


@end
