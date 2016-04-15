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
#import "TerminateViewController.h"
#import "PersonInfo.h"
#import "ContractInfo.h"
#import "TerminateViewController.h"
#import "NewLawsViewController.h"//合约细则
#import "NewCashViewController.h"//申领押金
#import "MyTrafficViewController.h"
#import "MobClick.h"




#define kWidthX 20

@interface ContractViewController ()
{
    ContractInfo *_contractInfo;
    NSString *_imeiString;//IMEI号
    NSString *_phoneString;//手机号
    NSArray *_dataArray;
}
@property(nonatomic,copy)NSString *isThirdType;

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
    //刷新当前页面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView) name:refreshMyDeviceKey object:nil];
    [self jugdeIMEI];

    [self requstUserDepositInfo];
    //[self uiConfig];
}

/**
 *  刷新当前页面
 */
-(void)refreshView{
    
    [self uiConfig];
    [_tableView reloadData];
}

#pragma mark - 配置文件
- (void)uiConfig
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.isThirdType=[UserDefaults objectForKey:@"isThirdModel"];
    if ([self.isThirdType isEqualToString:@"1"]) {
//         _dataArray=@[@[@{@"我的IMEI":@"wode"},@{@"我的流量":@""}]];
        _dataArray=@[@[@{@"我的IMEI":@"wode"}]];
        
    }else{
    _dataArray = @[@[@{@"我的IMEI":@"wode"},@{@"申请押金":@"shenqing"}],@[@{@"合约细则":@"heyu"},@{@"WEME换货":@"huanhu"},@{@"退货解约":@"jieyu"}]];
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
//    _tableView.showsHorizontalScrollIndicator = NO;
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];//友盟统计
}

#pragma mark - 获取手机号和IMEI号
- (void)jugdeIMEI
{
    [MBProgressHUD showMessage:@"主人正在加载中..." view:self.view isShow:NO];
    __weak typeof(self) selfvc=self;
    [RequestEngine getIMEIAndPhone:^(NSString *imeiStr, NSString *phoneStr, NSString *errorCode) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if([errorCode isEqualToString:@"0"])
        {
            _imeiString = [NSString stringWithFormat:@"%@",imeiStr];
            _phoneString = [NSString stringWithFormat:@"%@",phoneStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfvc refreshView];
            });
        }
        else
        {
            _imeiString = @"";
            _phoneString = @"";
            [MBProgressHUD showError:@"主人加载失败，稍后试一试吧!"];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }];

}

- (void)requstUserDepositInfo
{
    
    if(_contractInfo==nil)
    {
        _contractInfo = [[ContractInfo alloc]init];//数据源
    }
    [RequestEngine getUserDepositInfoCompleted:^(NSString *errorCode, NSDictionary *resultDic)
     {
         if([errorCode isEqualToString:@"0"])
         {
             [_contractInfo setValuesForKeysWithDictionary:resultDic];
             _contractInfo.imeiString = [resultDic objectForKey:@"imei"];
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    cell.textLabel.text = [[dic allKeys] firstObject];
    
    cell.textLabel.font = kLevelTwoFont;
    
    cell.textLabel.textColor = kLevelTwoColor;
    
    cell.imageView.image = [UIImage imageNamed:[dic valueForKey:[[dic allKeys] firstObject]]];

    
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
//    if (self.isThirdType==nil) {
//        
//        self.isThirdType=[UserDefaults objectForKey:@"isThirdModel"];
//    }
    NSString *imeiString=[UserDefaults objectForKey:@"imeiString"];
    if (![imeiString isEqualToString:@""]) {
        
//    }
//    if ([self.isThirdType isEqualToString:@"0"]) {
        UIViewController * vc = nil;
        
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0) {
                
                //我的IMEI
//                NSString *imeiString = [PersonInfo sharePersonInfo].IMEIString;
                NSString *imeiString=[UserDefaults objectForKey:@"imeiString"];
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
            }
            else if(indexPath.row == 1)
            {
                if ([self.isThirdType isEqualToString:@"1"]) {
                    MyTrafficViewController *mytrafficViewController=[[MyTrafficViewController alloc]initWithNibName:@"MyTrafficViewController" bundle:nil];
                    [self.navigationController pushViewController:mytrafficViewController animated:YES];
                }else{
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
        }
        
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                
                //合约细则
                NewLawsViewController *newLaw = [[NewLawsViewController alloc] init];
                newLaw.depositType = _contractInfo.depositType;
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

    }else{
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
        }else{
            //我的流量
            MyTrafficViewController *MyTraffic = [[MyTrafficViewController alloc] init];
            [self.navigationController pushViewController:MyTraffic animated:YES];
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
