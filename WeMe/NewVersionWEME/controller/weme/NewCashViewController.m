//
//  NewCashViewController.m
//  微密
//
//  Created by mirrtalk on 15/3/12.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "NewCashViewController.h"
#import "ContractInfo.h"
#import "MyViewController.h"
#import "HistoryDepositViewController.h"
#import "MobClick.h"

@interface NewCashViewController ()
{
    ContractInfo *_contractInfo;
    NSString *_imeiString;//IMEI号
    NSString *_phoneString;//手机号
    NSArray *_dataArray;
}

@property(nonatomic,strong) UITextField *secretCodeText;

@end

@implementation NewCashViewController

-(UITextField *)secretCodeText{
    if (_secretCodeText==nil) {
        _secretCodeText = [[UITextField alloc]init];
        _secretCodeText.textColor = kLevelThreeColor;
        _secretCodeText.font = kLevelThreeFont;
        _secretCodeText.delegate = self;
    }
    return _secretCodeText;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requstUserDepositInfo];
    
    [self uiConfig];
}
#pragma mark --初始化视图
- (void)uiConfig
{
    self.title = @"申领押金";
    
    
    _tiShiView = [[UILabel alloc]init];
    _tishiLabel = [[UILabel alloc]init];
    
    _isVoluntarySwitch = [[UISwitch alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = @[@[@{@"可领押金(元)":self.withdrawDepositAmountString},@{@"押金密码":@"123456"}],@[@{@"自动转账":@"0.00"}],@[@{@"我要转账":@"0.00"}]];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
    //rightButton.backgroundColor = [UIColor lightGrayColor];
    rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:16];
    [rightButton setTitle:@"历史反押" forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(historyDeposit:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if([self.withdrawDepositAmountString isEqualToString:@"0.00"])
    {
        _isVoluntarySwitch.on = NO;
        _isVoluntarySwitch.enabled = NO;
    }
    else
    {
        _isVoluntarySwitch.enabled = YES;
    }
    
}

#pragma mark - 跳转历史反押页面
- (void)historyDeposit:(UIButton *)button
{
    HistoryDepositViewController *dvc = [[HistoryDepositViewController alloc]init];
    dvc.totalDepositAmount = _contractInfo.totalDepositAmount;
    dvc.frozenDepositAmount =_contractInfo.frozenDepositAmount;
    dvc.depositType = self.depositType;
    [self.navigationController pushViewController:dvc animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [MobClick beginLogPageView:@"PageOne"];//友盟统计
    [self jugdeIMEI];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];//友盟统计
}

- (void)jugdeIMEI
{
    NSString *pImeiString = [PersonInfo sharePersonInfo].IMEIString;
    
    if ([pImeiString isEqualToString:@"0"])
    {
        pImeiString = @"";
        [PersonInfo sharePersonInfo].IMEIString = @"";
    }
    
    if ([pImeiString isEqualToString:@""] || pImeiString == nil)
    {
        [self dataRequest];
    }
    else
    {
        _imeiString = pImeiString;
    }
}
#pragma mark - 数据请求
- (void)dataRequest
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
#pragma mark - 请求个人信息
- (void)requstUserDepositInfo
{
    if(_contractInfo==nil)
    {
        _contractInfo = [[ContractInfo alloc]init];
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
#pragma mark - UITableViewCell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    NSDictionary * dic  = [[_dataArray  objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if(indexPath.section==0||indexPath.section==1)
    {
        cell.textLabel.text = [[dic allKeys] firstObject];
        cell.textLabel.font = kLevelTwoFont;
        cell.textLabel.textColor = kLevelTwoColor;
        if(indexPath.section==0&&indexPath.row==0)
        {
            cell.detailTextLabel.text = [dic valueForKey:[[dic allKeys] firstObject]];
            cell.detailTextLabel.font = kLevelThreeFont;
            cell.detailTextLabel.textColor = kLevelThreeColor;
        }
        else if(indexPath.section==0&&indexPath.row==1)
        {
            self.secretCodeText.frame = CGRectMake(ScreenWidth-160, 5, 150, 30);
            self.secretCodeText.textAlignment = NSTextAlignmentRight;
            self.secretCodeText.placeholder = @"请输入押金密码";
            self.secretCodeText.secureTextEntry = YES;
            [cell addSubview:self.secretCodeText];
        }
        else if(indexPath.section==1&&indexPath.row==0)
        {
            _tiShiView.frame = CGRectMake(15, 30, 200, 10);
            _tiShiView.text = @"解绑IMEI将无法自动转账";
            _tiShiView.font = kLevelFourFont;
            _tiShiView.textColor = [UIColor redColor];
            [cell addSubview:_tiShiView];
            
            _tishiLabel.frame = CGRectMake(ScreenWidth-_isVoluntarySwitch.frame.size.width-95, 15, 80, 10);
            _tishiLabel.text = @"下月将自动转账";
            _tishiLabel.textAlignment = NSTextAlignmentRight;
            _tishiLabel.font = kLevelFourFont;
            _tishiLabel.textColor = kLevelFourColor;
            [cell addSubview:_tishiLabel];
            
            _isVoluntarySwitch.frame = CGRectMake(ScreenWidth-_isVoluntarySwitch.frame.size.width-10, (40-_isVoluntarySwitch.frame.size.height)/2, 0, 0);
            //取
            _defaults = [NSUserDefaults standardUserDefaults];
            NSString * _adate = [_defaults objectForKey:kAutoDraw];
            _isVoluntarySwitch.on = [_adate boolValue];
            
            [_isVoluntarySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:_isVoluntarySwitch];
        }
    }
    else
    {
        
        UIButton *buttonTransfer = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        
        [buttonTransfer setTitle:[[dic allKeys] firstObject] forState:UIControlStateNormal];
        
        [buttonTransfer.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold"  size:18]];
        
        [cell addSubview:buttonTransfer];
        // 合约 申领押金 我要转账
        [buttonTransfer setBackgroundImage:[UIImage imageNamed:@"buttonone_normal"]forState:UIControlStateNormal];
        [buttonTransfer setBackgroundImage:[UIImage imageNamed:@"buttonone_select"]forState:UIControlStateHighlighted];
        [buttonTransfer addTarget:self action:@selector(buttonTransferClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
#pragma mark - 选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        if([self.withdrawDepositAmountString isEqualToString:@"0.00"])
        {
            Alert(@"主人,你还没有可领的押金哦");
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        return 40;
    }
    else
        return 44;
}

#pragma mark -开关事件
- (void)switchAction:(UISwitch *)autoValueSwitch
{
    NSString * iAuto = @"0";
    
    if (autoValueSwitch.isOn)
    {
        iAuto = @"1";
    }
    //存
    [_defaults setObject:iAuto forKey:kAutoDraw];
    [_defaults synchronize];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [RequestEngine applyWithdrawDepositApplyWithdrawAmount:iAuto depositPassword:self.secretCodeText.text completed:^(NSString *errorCode) {
        NSString *massage;
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSInteger isStation = [errorCode integerValue];
        
        if (isStation == 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:iAuto forKey:kAutoDraw];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if (iAuto == 0)
            {
                massage = @"主人,已修改为手动转账了哦";
            }else
            {
                massage = @"主人,已修改为自动转账了哦";
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kAutoDraw];
            [[NSUserDefaults standardUserDefaults] synchronize];
            autoValueSwitch.on = ! autoValueSwitch.on;
            if (isStation == 1)
            {
                massage = @"主人,押金密码有误,请检查一下吧";
            }
            else if (isStation == 2)
            {
                massage = @"主人,你的余额不足哦";
            }
            else if (isStation == 3)
            {
                massage = @"主人,提现时间过早了呢";
            }
            else
            {
                massage = @"主人,网络不给力啊,请检查一下网络吧";
            }
            
        }
        Alert(massage);
    }];
}

#pragma mark - 我要转账按钮事件
- (void)buttonTransferClick:(UIButton *)btn
{
    if(![self.withdrawDepositAmountString isEqualToString:@"0.00"])
    {
        [self transferBetweenAccounts];
    }
    else
    {
        Alert(@"主人,你还没有可领的押金哦");
    }
}
#pragma mark - 转账函数
- (void)transferBetweenAccounts
{
    if (_modelView == nil) {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }
    [self.view addSubview:_modelView];
    [RequestEngine applyWithdrawDepositApplyWithdrawAmount:self.withdrawDepositAmountString depositPassword:self.secretCodeText.text completed:^(NSString *errorCode)
     {
         NSInteger isStation = [errorCode intValue];
         _isSucceed = NO;
         NSString *massage;
         if (isStation == 0)
         {
             massage = @"主人,申领成功了哦";
             _isSucceed = YES;
         }
         else if (isStation == 1)
         {
             massage = @"主人,押金密码有误,请检查一下吧";
         }
         else if (isStation == 2)
         {
             massage = @"主人,你的余额不足哦";
         }
         else if (isStation == 3)
         {
             massage = @"主人,提现时间过早了呢";
         }
         else if (isStation == 4)
         {
             massage = @"主人,网络不给力啊,请检查一下网络吧";
         }
         [_modelView removeFromSuperview];
         Alert(massage);
         
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - 结束编辑状态
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - 开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if([self.withdrawDepositAmountString isEqualToString:@"0.00"])
    {
        //[textField resignFirstResponder];
        Alert(@"主人,你还没有可领的押金哦");
        return NO;
    }
    else
    {
        return YES;
    }
    
}

#pragma mark -Return结束编辑状态
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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
