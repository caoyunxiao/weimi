//
//  drawHeadIcon.m
//  微密
//
//  Created by weme on 15/10/8.
//  Copyright © 2015年 longlz. All rights reserved.
//

#import "drawHeadIcon.h"

@implementation drawHeadIcon


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat w=self.frame.size.width;
    CGFloat h=self.frame.size.width;
    CGFloat x=self.frame.origin.x;
    CGFloat y=self.frame.origin.y;
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.frame)-x, 0);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.frame)-x, CGRectGetMaxY(self.frame)-y);
    if(self.isBoldBottomAndRight){
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.frame)-x-0.4, 0);
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.frame)-x-0.4, CGRectGetMaxY(self.frame)-y-0.4);
        CGContextAddLineToPoint(context, 0, CGRectGetMaxY(self.frame)-y-0.4);
    }
    CGContextAddLineToPoint(context, 0, CGRectGetMaxY(self.frame)-y);
    CGContextClosePath(context);
    [getRGB(0, 122, 255) setStroke];
    [[UIColor whiteColor]setFill];
    CGContextDrawPath(context, kCGPathFillStroke);
    UIFont *font=[UIFont systemFontOfSize:14];
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,w,h)];
    lbl.text=self.drawTxt;
    if (w>50) {
        font=[UIFont systemFontOfSize:28];
    }
    CGSize drawTxtSize=[Tool sizeWithText:self.drawTxt font:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    lbl.font=font;
    lbl.textColor=getRGB(0, 122, 255);
    [lbl drawTextInRect:CGRectMake(w/2-drawTxtSize.width/2, h/2-drawTxtSize.height/2, drawTxtSize.width, drawTxtSize.height)];
}

-(NSString *)drawTxt{
    if (_drawTxt==nil) {
        _drawTxt=@"微";
    }
    return _drawTxt;
}


@end
