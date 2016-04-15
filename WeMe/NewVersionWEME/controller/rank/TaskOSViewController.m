//
//  TaskOSViewController.m
//  微密
//
//  Created by mirrtalk on 15/5/14.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TaskOSViewController.h"
#import "ContinuousDayTableViewCell.h"
#import "taskDetailTableViewCell.h"
#import "MobClick.h"

@interface TaskOSViewController ()
{
    UIAlertView *_alert;
}
@end

@implementation TaskOSViewController
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
    self.title = @"任务系统";
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] init];
    //self.tableView.tableFooterView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    //self.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:229.0/255.0 blue:230.0/255.0 alpha:1];
    [self getUserTaskInfo];
}
#pragma mark 数据请求
- (void)getUserTaskInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine getUserTaskInfoWithtaskInfoType:self.taskInfoType complete:^(NSString *errorcode, NSString *resultInfo, NSArray *dataArr) {
        if ([errorcode isEqualToString:@"0"]) {
            //请求成功
            _resultInfoString = resultInfo;
            _taskInfoArray = dataArr;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView reloadData];
        }else{
            //Alert(@"主人,网络不给力啊,请检查一下网络吧");
            if (!_alert) {
               _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"主人,网络不给力啊,请检查一下网络吧" delegate:nil cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
            }
        }
    }];
}
#pragma UITableView Create or Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _taskInfoArray.count+1;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        return 100;
        
    }
    return 44;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *iden = @"buttonCell";
    static  NSString *identif = @"detailCell";
    
    if (indexPath.row == 0) {
        ContinuousDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ContinuousDayTableViewCell" owner:self options:nil] firstObject];
        }
        cell.dayLabel.text = _resultInfoString;
        if([self.taskInfoType isEqualToString:@"2"]){
            cell.xieerLabel.text = @"获取的谢尔奖励需在本周内领取";
        }else if ([self.taskInfoType isEqualToString:@"3"]){
            cell.xieerLabel.text = @"获取的谢尔奖励需在本月内领取";
        }else if([self.taskInfoType isEqualToString:@"4"]){
            cell.xieerLabel.text = @"获取的谢尔奖励记得领取噢";
        }
        
        //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return  cell;
    }
    taskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    NSString *status = [NSString stringWithFormat:@"%@",_taskInfoArray[indexPath.row-1][@"receiveStatus"]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"taskDetailTableViewCell" owner:self options:nil] firstObject];
    }
    UIButton * prizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    prizeButton.tag = 100+indexPath.row-1;
    prizeButton.tintColor = [UIColor whiteColor];
    prizeButton.titleLabel.font = [UIFont systemFontOfSize:10];
    //[prizeButton setFont:[UIFont systemFontOfSize:10]];
    prizeButton.frame = CGRectMake(250, 7, 60, 30);
    [prizeButton addTarget:self action:@selector(prizeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([status isEqualToString:@"-1"]) {//待完成
        prizeButton.enabled = NO;
        prizeButton.backgroundColor = [UIColor lightGrayColor];
        [prizeButton setTitle:@"待完成" forState:UIControlStateNormal];
    }else if([status isEqualToString:@"0"]){//未领取
        prizeButton.enabled = YES;
        [prizeButton setTintColor:[UIColor whiteColor]];
        prizeButton.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:196.0/255 blue:87.0/255 alpha:1];//绿色
        [prizeButton setTitle:@"领取" forState:UIControlStateNormal];
    }else{//已领取
        prizeButton.enabled = NO;
        [prizeButton setTintColor:[UIColor whiteColor]];
        prizeButton.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:120.0/255.0 blue:209.0/255.0 alpha:1];//蓝色
        [prizeButton setTitle:@"已领取" forState:UIControlStateNormal];
    }
    [cell addSubview:prizeButton];
    cell.leftLabel.text = _taskInfoArray[indexPath.row-1][@"ruleName"];
    cell.middleLabel.text = [NSString stringWithFormat:@"%@谢尔值",_taskInfoArray[indexPath.row-1][@"rochell"]];
    cell.receiveStatus = [NSString stringWithFormat:@"%@",_taskInfoArray[indexPath.row-1][@"receiveStatus"]];
    
    return cell;
}

- (void)prizeButtonClick:(UIButton *)sender
{
    //sender.backgroundColor = [UIColor redColor];
    //改变状态 为1 并向服务器发送数据
    //NSLog(@"tag = %ld",sender.tag);
    //NSLog(@"%@",[NSString stringWithFormat:@"%@",_taskInfoArray[sender.tag-100][@"rewardID"]]);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [RequestEngine getRochelleWithRewardID:[NSString stringWithFormat:@"%@",_taskInfoArray[sender.tag-100][@"rewardID"]] completed:^(NSString *errorCode) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([errorCode isEqualToString:@"0"]) {
            sender.enabled = NO;
            sender.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:120.0/255.0 blue:209.0/255.0 alpha:1];
            [sender setTitle:@"已领取" forState:UIControlStateNormal];
            //[sender setTintColor:[UIColor whiteColor]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_taskInfoArray[sender.tag-100]];
            [dic setValue:@"1" forKey:@"receiveStatus"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:_taskInfoArray];
            [array replaceObjectAtIndex:sender.tag-100 withObject:dic];
            _taskInfoArray = array;
            [PersonInfo sharePersonInfo].needRefresh = YES;//榜单需要刷新谢尔值
            Alert(@"主人,领取成功了哦");
        }else{
            //sender.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:196.0/255 blue:87.0/255 alpha:1];
            Alert(@"主人,领取失败了呀");
        }
    }];
}
@end
