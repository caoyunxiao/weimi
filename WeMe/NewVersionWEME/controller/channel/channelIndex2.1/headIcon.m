//
//  headIcon.m
//  WeMe
//
//  Created by weme on 15/10/22.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import "headIcon.h"

@implementation headIcon

-(void)awakeFromNib{
    self.centerWordLbl.textColor=getRGB(0, 122, 255);
    self.layer.borderColor=getRGB(0, 122, 255).CGColor;
    self.layer.borderWidth=1;
}
+(instancetype)initWithHeadNib{
    return [[NSBundle mainBundle]loadNibNamed:@"headIcon" owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
