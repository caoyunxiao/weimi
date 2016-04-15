//
//  DockItem.m
//  weibo
//
//  Created by apple on 13-8-28.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "DockItem.h"

@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
    }
    return self;
}

#pragma mark 重写父类的方法（覆盖父类在高亮时所作的行为）
- (void)setHighlighted:(BOOL)highlighted {}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
}

#pragma mark 返回是按钮内部UIImageView的边框
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
//}

@end
