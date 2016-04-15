//
//  TemHeadViewz.m
//  微密
//
//  Created by APP on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TemHeadViewz.h"

@implementation TemHeadViewz


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.rochelleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.precentLabel.font = [UIFont boldSystemFontOfSize:13.0];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    ImageViewCorner(_headImageView);
    ImageViewCorner(self.bottomView);
}

@end
