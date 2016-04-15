//
//  FunctionSettingHeaderButton.m
//  微密
//
//  Created by longlz on 14-8-4.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "FunctionSettingHeaderButton.h"

@implementation FunctionSettingHeaderButton
{
    BOOL _flag;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        
        imageView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:imageView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
        
        imageView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:imageView];
        
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return self;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _allOrderSwitch.on = isSelected;
}

- (IBAction)allOrderValueChanage:(id)sender
{
    UISwitch * mySwitch = (UISwitch*)sender;
    
    _flag = mySwitch.on;
    
    if ([_delegate respondsToSelector:@selector(functionValueChanage:isSeleted:)])
    {
//        if (_flag != mySwitch.on)
//        {
//            
//        }
        
        [_delegate functionValueChanage:_section isSeleted:_allOrderSwitch.isOn];
    }
}

- (BOOL)isSelected
{
    return _allOrderSwitch.isOn;
}

- (void)orderVlaueChanage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(functionValueChanage:isSeleted:)])
    {
        [_delegate functionValueChanage:_section isSeleted:_allOrderSwitch.isOn];
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(40, 15, 100, 20);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(10, 15, 20, 20);
}

@end
