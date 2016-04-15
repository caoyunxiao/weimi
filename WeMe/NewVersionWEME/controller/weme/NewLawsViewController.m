//
//  NewLawsViewController.m
//  微密
//
//  Created by mirrtalk on 15/3/12.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewLawsViewController.h"
#import "ContractInfo.h"
#import "MyViewController.h"
#import "MobClick.h"
#import "LawsInfo.h"

@interface NewLawsViewController ()
{
    NSArray *_dataArray;
}

@end

@implementation NewLawsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requstUserDepositInfo];
    [self uiConfig];
}

#pragma mark -初始化视图
- (void)uiConfig
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.title = @"合约细则";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:self.title];//友盟统计
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];//友盟统计
}

- (void)requstUserDepositInfo
{
    
    [Request1617 getDepositTypeInfoDepositType:self.depositType complete:^(NSString *errorCode, NSArray *dictRequest) {
        if([errorCode isEqualToString:@"0"])
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            for (NSDictionary *dic in dictRequest) {
                LawsInfo *lawsInfo = [[LawsInfo alloc]init];
                [lawsInfo setValuesForKeysWithDictionary:dic];
                if (lawsInfo != nil)
                {
                    _dataArray = @[@[@{@"WEME套餐":lawsInfo.remark}],@[@{@"总押金(元)":lawsInfo.depositAmount},@{@"每月返还(元)":lawsInfo.monthReturnDepositAmount}],@[@{@"返还达标里程(公里)":[NSString stringWithFormat:@"%.2f",[lawsInfo.qualifiedMileage intValue]/1000.0]},@{@"返还期数(月)":lawsInfo.returnTotalMonth}]];
                }
                else
                {
                    _dataArray = @[@[@{@"WEME套餐":@"0"}],@[@{@"总押金(元)":@"0.00"},@{@"每月返还(元)":@"0.00"}],@[@{@"返还达标里程(公里)":@"0.00"},@{@"返还期数(月)":@"0"}]];
                }

            }
            [_tableView reloadData];
        }
        else
        {
            //
        }
        
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)_dataArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSDictionary * dic  = [[_dataArray  objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [[dic allKeys] firstObject];
    
    cell.textLabel.font = kLevelTwoFont;
    
    cell.textLabel.textColor = kLevelTwoColor;
    
    cell.detailTextLabel.text = [dic valueForKey:[[dic allKeys] firstObject]];
    
    cell.detailTextLabel.font = kLevelThreeFont;
    
    cell.detailTextLabel.textColor = kLevelThreeColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 20;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - 选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

