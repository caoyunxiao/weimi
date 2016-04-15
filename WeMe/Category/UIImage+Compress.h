//
//  UIImage+Compress.h
//  微密
//
//  Created by iOS Dev on 14-9-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

//压缩图片的大小
+ (UIImage *)compressByImage:(UIImage *)image targetSize:(CGSize)targetSize;

@end
