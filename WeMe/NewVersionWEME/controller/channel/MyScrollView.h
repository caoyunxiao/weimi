//
//  MyScrollView.h
//  相册
//
//  Created by qianfeng on 14-11-17.
//  Copyright (c) 2014年 zxf. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyScrollView : UIScrollView{
    UIImageView *iv;
}

- (MyScrollView *)initWithFrame:(CGRect)frame anImage:(NSString *)image;

- (void)addSingleClickWithTarget:(id)target andAction:(SEL)action;

- (void)addDoubleClickWithTarget:(id)target andAction:(SEL)action;

@end
