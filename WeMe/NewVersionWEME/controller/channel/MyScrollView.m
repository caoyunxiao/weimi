//
//  MyScrollView.m
//  相册
//
//  Created by qianfeng on 14-11-17.
//  Copyright (c) 2014年 zxf. All rights reserved.
//

#import "MyScrollView.h"

@interface MyScrollView ()

@property (retain, nonatomic) id targetS;

@property (assign, nonatomic) SEL actionS;

@property (retain, nonatomic) id targetD;

@property (assign, nonatomic) SEL actionD;

@end

@implementation MyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (MyScrollView *)initWithFrame:(CGRect)frame anImage:(NSString *)image
{
    if (self = [super initWithFrame:frame])
    {
        NSURL *url = [NSURL URLWithString:image];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *imageNew = [UIImage imageWithData: imageData];
        float height = (self.frame.size.width*imageNew.size.height)/imageNew.size.width;
        
        iv = [[UIImageView alloc] init];
        iv.frame = CGRectMake(0, (self.frame.size.height-height-64)/2, self.frame.size.width, height);
        [iv sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@""]];
        iv.userInteractionEnabled = YES;
        [self addSubview:iv];
        self.maximumZoomScale = 5.0;
        self.minimumZoomScale = 1.0;
    }
    return self;
}

- (void)addSingleClickWithTarget:(id)target andAction:(SEL)action
{
    self.targetS = target;
    self.actionS = action;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)addDoubleClickWithTarget:(id)target andAction:(SEL)action
{
    self.targetD = target;
    self.actionD = action;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 2;
    
    [self addGestureRecognizer:tap];
    for (UIGestureRecognizer *gesR in self.gestureRecognizers) {
        if ([gesR isKindOfClass:[UITapGestureRecognizer class]]) {
           
            if (((UITapGestureRecognizer *)gesR).numberOfTapsRequired == 1) {
                [gesR requireGestureRecognizerToFail:tap];
            }
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (tap.numberOfTapsRequired == 1)
    {
        if ([self.targetS respondsToSelector:self.actionS])
        {
            IMP imp = [self.targetS methodForSelector:self.actionS];
            void (*func)(id, SEL) = (void *)imp;
            func(self.targetS, self.actionS);
        }
        //[self.targetS performSelector:self.actionS];
    }
    else
    {
        if ([self.targetD respondsToSelector:self.actionD])
        {
            IMP imp = [self.targetD methodForSelector:self.actionD];
            void (*func)(id, SEL) = (void *)imp;
            func(self.targetD, self.actionD);
        }
        //[self.targetD performSelector:self.actionD withObject:self];
    }
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
