//
//  HeaderView.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.uiViewBackView.frame = CGRectMake(-5, -2, ScreenWidth+10, 35);
        self.uiViewBackView.layer.borderColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1].CGColor;
        self.uiViewBackView.layer.borderWidth = 1.0;
    }
    return self;
}


- (void)fillDataString:(NSString *)totalDepositAmountstring frozenDepositAmount:(NSString *)frozenDepositAmountString
{
    self.allCashLabel.text = totalDepositAmountstring;
    self.freezeLabel.text = frozenDepositAmountString;
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
