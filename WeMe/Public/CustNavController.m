//
//  CustNavController.m
//  微密
//
//  Created by mirrortalk on 15/9/7.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "CustNavController.h"

@interface CustNavController ()

@end

@implementation CustNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationBar.frame=CGRectMake(0, 20, ScreenWidth, 35);
//}
//

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.navigationBar.frame=CGRectMake(0, 20, ScreenWidth, 35);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
