//
//  ContractViewController.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ContractViewController.h"
#import "MyViewController.h"
#import "transferGoodsViewController.h"
#import "LawsViewController.h"
#import "ReturnTableViewController.h"
#import "TerminateViewController.h"
#import "PersonInfo.h"
#import "ContractModel.h"
#import "ContractInfo.h"
#import "TerminateViewController.h"
#import "NewLawsViewController.h"//合约细则
#import "NewCashViewController.h"//申领押金
#import "MobClick.h"



#define kWidthX 20

#define kStation  @"staionString"

@interface ContractViewController ()
{
    ContractInfo *_contractInfo;
    NSString *_imeiString;//IMEI号
    NSString *_phoneString;//手机号
    NSArray *_dataArray;
}
@end

@implementation ContractViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"我的设备";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self jugdeIMEI];
    [self requstUserDepositInfo];
    [self uiConfig];
}
#pragma mark - 配置文件
- (void)uiConfig
{
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = @[@[@{@"我的IMEI":@"wode"},@{@"申请押金":@"shenqing"}],@[@{@"合约细则":@"heyu"},@{@"WEME换货":@"huanhu"},@{@"退货解约":@"jieyu"}]];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
//    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"PageOne"];//友盟统计
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];//友盟统计
}

#pragma mark - 获取手机号和IMEI号
- (void)jugdeIMEI
{
    [RequestEngine getIMEIAndPhone:^(NSString *imeiStr, NSString *phoneStr, NSString *errorCode) {
        if([errorCode isEqualToString:@"0"])
        {
            _imeiString = [NSString stringWithFormat:@"%@",imeiStr];
            _phoneString = [NSString stringWithFormat:@"%@",phoneStr];
        }
        else
        {
            _imeiString = @"";
            _phoneString = @"";
        }
        
    }];
}

- (void)requstUserDepositInfo
{
    ContractModel *contractModel = [[ContractModel alloc]init];
    
    [contractModel getUserDepositInfo:^(NSDictionary *userDepositInfo)
     {
         if ([[userDepositInfo objectForKey:kStation] intValue] == 0)
         {
             _contractInfo = [userDepositInfo objectForKey:@"info"];
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
    
    cell.imageView.image = [UIImage imageNamed:[dic valueForKey:[[dic allKeys] firstObject]]];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self alertSection:indexPath];
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

- (void)alertSection:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
    
    UIViewController * vc = nil;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {

            //我的IMEI
            NSString *imeiString = [PersonInfo sharePersonInfo].IMEIString;
            MyViewController *my = [[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
            [self.navigationController pushViewController:my animated:YES];
            my.IMEIString = imeiString;
            if ([imeiString isEqualToString:@"未绑定"] || [imeiString isEqualToString:@""])
            {
                my.isBound = NO;
            }
            else
            {
                my.isBound = YES;
            }
        }else if(indexPath.row == 1){
            
            //申领押金
            NewCashViewController *cash = [[NewCashViewController alloc]init];
            [self.navigationController pushViewController:cash animated:YES];
            cash.depositType = _contractInfo.depositType;
            
            NSString *withAmountString = _contractInfo.withdrawDepositAmount;
            
            if (_contractInfo.withdrawDepositAmount == nil) {
                withAmountString = @"0.00";
            }
            
            cash.withdrawDepositAmountString = withAmountString;

        
        
        }
    }

    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            
            //合约细则
            NewLawsViewController *newLaw = [[NewLawsViewController alloc] init];
            [self.navigationController pushViewController:newLaw animated:YES];
        }
        else if (indexPath.row == 1)
        {
            //WEME换货
            vc = [[transferGoodsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            
            //退货解约
            vc = [[TerminateViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        
        
        }
    }
}

- (void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,你当前没有绑定IMEI,不能查看和访问相关数据,快去绑定吧" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        MyViewController *my = [[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
        my.isBound = NO;
        [self.navigationController pushViewController:my
                                             animated:YES];
    }
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
