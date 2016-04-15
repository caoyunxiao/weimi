//
//  Custom.h
//  微密
//
//  Created by mirrortalk on 15/8/29.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Custom : NSObject

+(UIButton *)addBtnWithFrame:(CGRect)frame nomalImage:(NSString *)imgName title:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action;

+(UILabel *)addLabelWithFrame:(CGRect)frame labelText:(NSString *)text textColor:(UIColor *)color;

//创建UIImageView
+ (UIImageView *)createImageView:(CGRect)frame imageName:(NSString *)imageName;


@end
