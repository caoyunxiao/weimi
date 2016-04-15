//
//  MyAccountViewController.h
//  微密
//
//  Created by mirrtalk on 15/5/18.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
@interface MyAccountViewController : BasesViewController



- (IBAction)AccountButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *daokeShop;

@property (weak, nonatomic) IBOutlet UIImageView *daokeBill;

@end
