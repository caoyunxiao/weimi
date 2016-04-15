//
//  StarView.m
//  LimitDemo
//
//  Created by pk on 15/3/10.
//  Copyright (c) 2015年 pk. All rights reserved.
//

#import "StarView.h"

@interface StarView (){
    UIView* _foreView;
    UIView* _backView;
}

@end

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self makeView];
    }
    return self;
}

- (void)awakeFromNib{
    [self makeView];
}

- (void)makeView{
    //1.主页_14.png  背景:1.主页_16.png 15*14
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    [self addSubview:_backView];
    _foreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _foreView.clipsToBounds = YES;
    [self addSubview:_foreView];
    
    for (int i = 0; i < 3; i++) {
        UIImageView* foreStar = [[UIImageView alloc] initWithFrame:CGRectMake(i * 20, 0, 20, 20)];
        foreStar.image = [UIImage imageNamed:@"full-star"];
        [_foreView addSubview:foreStar];
        
        UIImageView* backStar = [[UIImageView alloc] initWithFrame:CGRectMake(i * 20, 0, 20, 20)];
        backStar.image = [UIImage imageNamed:@"empty-star"];
        [_backView addSubview:backStar];
    }
}

- (void)setStar:(float)star{
    _foreView.frame = CGRectMake(0, 0, 60 * (star / 3.0), 20);
}


@end
