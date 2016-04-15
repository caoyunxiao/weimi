//
//  Custom.m
//  微密
//
//  Created by mirrortalk on 15/8/29.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "Custom.h"

@implementation Custom

+(UIButton *)addBtnWithFrame:(CGRect)frame nomalImage:(NSString *)imgName title:(NSString *)title titleColor:(UIColor *)color target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=frame;
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(UILabel *)addLabelWithFrame:(CGRect)frame labelText:(NSString *)text textColor:(UIColor *)color
{
    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.text=text;
    label.textColor=color;
    return label;
}

+(UIImageView *)createImageView:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (imageName) {
        imageView.image = [UIImage imageNamed:imageName];
    }
    return imageView;
}

@end
