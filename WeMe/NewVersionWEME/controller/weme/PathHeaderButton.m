//
//  PathHeaderButton.m
//  微密
//
//  Created by longlz on 14-7-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "PathHeaderButton.h"

@implementation PathHeaderButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width - 60, 15, 80, 20)];
        
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:13];
        
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_rightLabel];
        
        UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.alpha = 0.8;
        [self addSubview:imageView];
        
    }
    return self;
}


- (void)setNumberString:(NSString *)numberString
{
    _rightLabel.text = numberString;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(50, 15, 170, 20);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(20, 15, 20, 20);
}

@end
