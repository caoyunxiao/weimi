//
//  DefindContractViewController.m
//  微密
//
//  Created by iOS Dev on 14-9-13.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "DefindContractViewController.h"
#import "CompanyContractView.h"


@interface DefindContractViewController ()

@end

@implementation DefindContractViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"道客里程合约";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addView];
}

- (void)addView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 1436);
    [self.view addSubview:scrollView];
    
    CompanyContractView *companyContractView = (CompanyContractView *)[[[NSBundle mainBundle]loadNibNamed:@"CompanyContractView" owner:self options:nil]lastObject];
    [scrollView addSubview:companyContractView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
