//
//  NSString+file.m
//  网易云相册
//
//  Created by qianfeng on 14-6-10.
//  Copyright (c) 2014年 linglong. All rights reserved.
//

#import "NSString+file.h"

@implementation NSString (file)


- (NSString *)fileNameAppend:(NSString*)append
{
    //取得没有后缀名的文件名
    NSString *fileName = [self stringByDeletingPathExtension];
    
    //拼接append
    fileName = [fileName stringByAppendingString:append];
    
    //拼接拓展名
    NSString *extension = [self pathExtension];
    
    
    
    return [fileName stringByAppendingPathExtension:extension];;
}

@end
