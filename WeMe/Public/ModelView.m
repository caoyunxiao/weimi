//
//  ModelView.m
//  微密
//
//  Created by longlz on 14-7-18.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ModelView.h"

@implementation ModelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _view.layer.cornerRadius = 6;
        _view.backgroundColor = [UIColor blackColor];
        _view.alpha = 0.8;
        _view.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        
        [self addSubview:_view];
        
        
        _actView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _actView.center = CGPointMake(30, 30);
        [_view addSubview:_actView];
        [_actView startAnimating];
    }
    return self;
}

@end
