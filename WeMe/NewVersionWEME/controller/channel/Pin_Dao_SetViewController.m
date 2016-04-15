//
//  Pin_Dao_SetViewController.m
//  微密
//
//  Created by MacDev on 15/4/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "Pin_Dao_SetViewController.h"
#import "MobClick.h"
#import "AddSettingViewController.h"
#import "FunctionSettingViewController.h"
#import "SetModelZFJ.h"

@interface Pin_Dao_SetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _dataArr;
    NSMutableArray *_arrayData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation Pin_Dao_SetViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"微密终端设置";
    _dataArr = @[@[@"+键设置",@"++键设置"],@[@"功能设置"]];
    _arrayData = [[NSMutableArray alloc]init];
    [self getUserkeyInfoCompleted];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSettingViewController:) name:@"AddSettingViewController" object:nil];
}
#pragma mark - 通知接收函数
-(void)AddSettingViewController:(NSNotification *)notifi
{
    NSString *modelName = [notifi.userInfo objectForKey:@"modelName"];
    NSString *actionType = [notifi.userInfo objectForKey:@"actionType"];
    for (SetModelZFJ *model in _arrayData)
    {
        if([model.actionType isEqualToString:actionType])
        {
            model.parameterName = modelName;
            [self.tableView reloadData];
        }
    }
}
#pragma mark -- 表的代理实现 --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArr objectAtIndex:section]count];  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * indentifer = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifer];
    }
    cell.textLabel.font = kLevelTwoFont;
    cell.textLabel.textColor = kLevelTwoColor;
    cell.detailTextLabel.font = kLevelThreeFont;
    cell.detailTextLabel.textColor = kLevelThreeColor;
    cell.textLabel.text = [[_dataArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    if(indexPath.section==0)
    {
        if(_arrayData.count>0)
        {
            for (SetModelZFJ *model in _arrayData)
            {
                if([model.actionType isEqualToString:@"4"]&&indexPath.row==0)
                {
                    cell.detailTextLabel.text = model.parameterName;
                }
                else if ([model.actionType isEqualToString:@"5"]&&indexPath.row==1)
                {
                    cell.detailTextLabel.text = model.parameterName;
                }
            }
            
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if(indexPath.section == 1)
    {
        //功能设置
        FunctionSettingViewController *function = [[FunctionSettingViewController alloc]init];
        [self.navigationController pushViewController:function animated:YES];
    
    }
    //+键设置,++键设置
    else
    {
        [self alertShowWithIndexPathRow:indexPath.row];
        _indexPathRow = indexPath.row;
    }
}
- (void)getUserkeyInfoCompleted
{
    [RequestEngine getUserkeyInfo:@"" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"0"])
        {
            NSArray *list = [resultDic objectForKey:@"list"];
            for (NSDictionary *dict in list)
            {
                SetModelZFJ *model = [[SetModelZFJ alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_arrayData addObject:model];
            }
            if(_arrayData.count>0)
            {
                [self.tableView reloadData];
            }
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}


- (void)alertShowWithIndexPathRow:(NSInteger)indexPathRow
{
    NSString *messageStr;
    if(indexPathRow==0)
    {
        messageStr = @"主人,你如果重新设置了+键,之前关联的频道将要被覆盖掉哦";
    }
    else if (indexPathRow==1)
    {
        messageStr = @"主人,你如果重新设置了++键,之前关联的频道将要被覆盖掉哦";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重设" otherButtonTitles:@"取消", nil];
    alert.tag = 1101;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1101)
    {
        if (buttonIndex == 0)
        {
            AddSettingViewController * vc = [[AddSettingViewController alloc]init];
            if(_indexPathRow==0)
            {
                vc.titleStr = @"+键设置";
            }
            else if (_indexPathRow==1)
            {
                vc.titleStr = @"++键设置";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (buttonIndex == 1)
        {
            //NSLog(@"1111111");//取消
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
