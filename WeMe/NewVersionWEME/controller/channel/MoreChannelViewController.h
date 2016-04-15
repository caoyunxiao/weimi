//
//  MoreChannelViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/25.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
@interface MoreChannelViewController : BasesViewController
- (IBAction)buttonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property(nonatomic,assign)BOOL isQunLiao;
@end
