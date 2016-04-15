//
//  BaseViewController.m
//  微密
//
//  Created by wemeDev on 15/3/10.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "MobClick.h"
@interface BasesViewController ()

@end

@implementation BasesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)refreshWithStatus:(BOOL)isLoding
{
    if (isLoding)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}
#pragma mark -- 返回上一层
- (void)goBacksActions
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
