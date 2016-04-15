//
//  VolumeImageView.m
//  微密
//
//  Created by iOS Dev on 14-8-19.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "VolumeImageView.h"

@implementation VolumeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _upVolumeImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_upVolumeImageView];
    }
    return self;
}


- (void)setVolumeString:(NSString *)volumeString
{
    _upVolumeImageView.image = [UIImage imageNamed:volumeString];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
