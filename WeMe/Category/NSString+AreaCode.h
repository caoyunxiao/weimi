//
//  NSString+AreaCode.h
//  微密
//
//  Created by iOS Dev on 14/11/10.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AreaCode)


+ (NSString *)arearCodeWithProvince:(NSString *)province city:(NSString *)city;

@end
