//
//  ChannelHeadSettingView.m
//  微密
//
//  Created by weme on 15/10/12.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import "ChannelHeadSettingView.h"

@implementation ChannelHeadSettingView

-(void)awakeFromNib{
    
}
+(instancetype)initWithNib{
    return [[NSBundle mainBundle]loadNibNamed:@"ChannelHeadSettingView" owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
