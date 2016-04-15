//
//  UIImage+CJ.h
//  WeMe
//
//  Created by weme on 15/10/21.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CJ)
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (UIImage *)resizedImageWithData:(NSData *)data left:(CGFloat)left top:(CGFloat)top;
+ (UIImage *)resizedImageWithImage:(UIImage *)image left:(CGFloat)left top:(CGFloat)top;

+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

-(UIImage*)scaleToSize:(CGSize)size;
@end
