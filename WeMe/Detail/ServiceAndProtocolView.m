//
//  ServiceAndProtocolView.m
//  微密
//
//  Created by iOS Dev on 14-9-13.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ServiceAndProtocolView.h"

@implementation ServiceAndProtocolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (IBAction)daokeClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(daokeIsClick)])
    {
        [_delegate daokeIsClick];
    }
    
}
@end
