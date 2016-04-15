//
//  PushMessageViewController.m
//  微密
//
//  Created by wemeDev on 15/3/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "PushMessageViewController.h"

@interface PushMessageViewController ()

@end

@implementation PushMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

@end
