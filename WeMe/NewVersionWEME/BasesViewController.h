//
//  BaseViewController.h
//  微密
//
//  Created by wemeDev on 15/3/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasesViewController : UIViewController

@property (nonatomic,assign) BOOL isHiddenLeftButton;

-(void)refreshWithStatus:(BOOL)isLoding;
@end
