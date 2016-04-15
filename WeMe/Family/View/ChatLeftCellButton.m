//
//  ChatLeftCellButton.m
//  微密
//
//  Created by iOS Dev on 14-8-19.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ChatLeftCellButton.h"

@implementation ChatLeftCellButton



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}




- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(80, 11.5, 30, 30);
}




- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(30, 11.5, 30, 30);
}


@end
