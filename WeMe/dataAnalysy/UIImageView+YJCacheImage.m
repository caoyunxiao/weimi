//
//  UIImageView+YJCacheImage.m
//  DaokeClub
//
//  Created by wemeDev on 15/6/30.
//  Copyright (c) 2015年 Daoke Dev. All rights reserved.
//

#import "UIImageView+YJCacheImage.h"
#import "UIImageView+WebCache.h"
#import "NSString+MD5Addition.h"
#import "UIImage+CJ.h"

@implementation UIImageView (YJCacheImage)

- (void)setImageWithURLOfZFJ:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    if(url ==nil || url.length==0)
    {
        
        //[self setImage:[UIImage imageNamed:@"touxy.jpg"]];
        [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"默认频道头像%d",(arc4random() % 5) + 1]]];
    }
    else
    {
        NSData *data;
        NSString *filename = [url stringFromMD5];
        NSString *fullPath = [self filePath:filename];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:fullPath])
        {
            //从本地读取
            data = [NSData dataWithContentsOfFile:fullPath];

//            [UIImage imageCompressForSize:[UIImage imageWithData:data] targetSize:CGSizeMake(ANCHORIMGWIDTH, ANCHORIMGWIDTH)];
            [self setImage:[UIImage imageWithData:data]];
        }
        else
        {
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            //网络下载
            [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"默认频道头像%d",(arc4random() % 5) + 1]]];
            //存到本地
            [data writeToFile:fullPath atomically:YES];
        }
    }
}

- (NSString *)filePath:(NSString *)fileName
{
    NSString *homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents/DataCache"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:homePath])
    {
        [fm createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(fileName && fileName.length !=0)
    {
        homePath = [homePath stringByAppendingPathComponent:fileName];
    }
    //NSLog(@"图片保存的路径为   --------------   %@",homePath);
    return homePath;
}

    


   










@end
