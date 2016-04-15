//
//  UIImageView+YJCacheImage.h
//  DaokeClub
//
//  Created by wemeDev on 15/6/30.
//  Copyright (c) 2015年 Daoke Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YJCacheImage)

//类别调用方法

- (void)setImageWithURLOfZFJ:(NSString *)url placeholderImage:(UIImage *)placeholder;

//将文件存在本地

- (NSString *)filePath:(NSString *)fileName;

@end
