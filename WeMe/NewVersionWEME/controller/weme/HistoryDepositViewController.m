//
//  HistoryDepositViewController.m
//  微密
//
//  Created by Daoke Dev on 15/3/17.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "HistoryDepositViewController.h"
#import "HeaderView.h"
#import "LawsInfo.h"
#import "ReturnTableViewCell.h"
#import "MJRefresh.h"
#import "MobClick.h"

@interface HistoryDepositViewController ()

@end

@implementation HistoryDepositViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareData];
    [self initViewController];
    [self setupRefresh];       //刷新
    [self requstUserDepositInfo];
}

#pragma mark - 获取用户有没有套餐（合约细则）
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
    
    [Request1617 getDepositTypeInfoDepositType:self.depositType complete:^(NSString *errorCode, NSArray *dictRequest) {
        if([errorCode isEqualToString:@"0"])
        {
            LawsInfo *lawsInfo = [[LawsInfo alloc]init];
            for (NSDictionary *dict in dictRequest) {
                [lawsInfo setValuesForKeysWithDictionary:dict];
                
                if (lawsInfo != nil)
                {
                    if([lawsInfo.remark isEqualToString:@"WEME0元押金套餐"])
                    {
                        _isShow = NO;
                    }
                    else
                    {
                        _isShow = YES;
                    }
                }
                else
                {
                    _isShow = YES;
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


#pragma mark - 初始化视图 创建主要控件
- (void)initViewController
{
    self.title = @"历史反押";
    
    _dataArray  = [[NSMutableArray alloc]init];
    
    _pathModel = [[PathModel alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - 创建数据
- (void)prepareData
{
    if (_modelView == nil) {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }
    [self.view addSubview:_modelView];
    [self.view bringSubviewToFront:_modelView];
    
    [RequestEngine fetchDepositHisotry:^(NSString *errorCode, NSArray *resultArr)
     {
         [_modelView removeFromSuperview];
         if([errorCode isEqualToString:@"0"])
         {
             if ([resultArr count] > 0)
             {
                 if(_dataArray.count>0)
                 {
                     [_dataArray removeAllObjects];
                 }
                 _dataArray = [resultArr mutableCopy];
                 
                 if (_tableView != nil)
                 {
                     [_tableView reloadData];
                 }
             }else
             {
                 [_errorView removeFromSuperview];
                 [self showNetWorkView];
             }
         }
     }];
}

#pragma mark-- 网络错误或者无数据

- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.frame.origin.y + self.view.frame.size.height * 0.5-64);
    
    [_tableView addSubview:_errorView];
}

#pragma mark -返回数组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_dataArray.count>0)
    {
        return _dataArray.count;
    }
    else
        return 0;
}
#pragma mark -创建tableview的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ReturnCellID";
    
    ReturnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = (ReturnTableViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"ReturnTableViewCell" owner:self options:nil]lastObject];
    }
    
    if ([_dataArray count] > 0)
    {
        [cell fillData:[_dataArray objectAtIndex:indexPath.row]];
    }
    
//    if (indexPath.row % 2 == 0) {
//        
//        cell.backgroundColor = [UIColor whiteColor];
//        
//    }else
//    {
//        cell.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark -返回每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
#pragma mark -返回头部标题栏的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_isShow)
    {
        return 45;
    }
    else
    {
        return 0;
    }
}
#pragma mark -选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark -头部标题栏
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(_isShow)
    {
        _headView = (HeaderView*)[[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]lastObject];
        [_headView fillDataString:self.totalDepositAmount frozenDepositAmount:self.frozenDepositAmount];
        return _headView;
    }
    else
    {
        return nil;
    }
}

- (void)setupRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [_tableView headerBeginRefreshing];

}
#pragma mark -- 头部刷新
- (void)headerRereshing
{
    [self prepareData];
    [_tableView headerEndRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];//友盟统计
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];//友盟统计
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
