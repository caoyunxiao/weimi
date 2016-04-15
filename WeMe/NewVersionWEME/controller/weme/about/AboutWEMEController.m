//
//  AboutWEMEController.m
//  微密
//
//  Created by wemeDev on 15/3/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "AboutWEMEController.h"
#import "UseWayViewController.h"
#import "MobClick.h"
#import "VersionsModel.h"
#import "DefindTextViewController.h"
#import "ServiceProtocolViewController.h"
#import "MobClick.h"
#import "Tool.h"



@interface AboutWEMEController (){
    NSString * _banben;//以前的版本
}
/**
 *  版本号
 */
@property (weak, nonatomic) IBOutlet UILabel *versionNumber;

@end

@implementation AboutWEMEController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关于微密";
    self.versionNumber.text=[NSString stringWithFormat:@"v%@",[Tool getCurrentAPPVersion]];
}
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
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)serViceAgreementClick:(UIButton *)sender
{
    //UseWayViewController * vc = [[UseWayViewController alloc]init];
    ServiceProtocolViewController *vc = [[ServiceProtocolViewController alloc]init];
    //DefindTextViewController * vc = [[DefindTextViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
