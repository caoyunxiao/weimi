//
//  PathHeaderButton.h
//  微密
//
//  Created by longlz on 14-7-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PathHeaderButton : UIButton
{
    UILabel *_rightLabel ;
}
@property(copy,nonatomic)NSString *numberString;

@property(assign,nonatomic)BOOL   isUnfold;



@end
