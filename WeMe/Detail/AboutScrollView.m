//
//  AboutScrollView.m
//  微密
//
//  Created by iOS Dev on 14-8-26.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "AboutScrollView.h"

@implementation AboutScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(0, 568);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        self.contentSize = CGSizeMake(0, 568);
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
