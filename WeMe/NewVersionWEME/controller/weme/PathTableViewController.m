//
//  PathTableViewController.m
//  微密
//
//  Created by longlz on 14-7-16.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "PathTableViewController.h"
#import "MJRefresh.h"
#import "PathTableViewCell.h"
#import "PathHeaderButton.h"
#import "PathTravelInfo.h"
#import "PathDetailInfo.h"
#import "MapDetailViewController.h"
#import "MobClick.h"

@interface PathTableViewController ()
{
    NSMutableArray *_dataArray;
    MapDetailViewController *_mapDetailViewController;
    
    
    ModelView *_modelView;
}
@end

@implementation PathTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"轨迹";
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _sectionArray = [[NSMutableArray alloc]init];
    
    _pathModel = [[PathModel alloc]init];
    
    [self setupRefresh];

}
- (void)viewWillAppear:(BOOL)animated 
{
    //[self.tableView headerBeginRefreshing];
    [super viewWillAppear:animated];
     [MobClick beginLogPageView:@"轨迹--主界面"];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"轨迹--主界面"];
}
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.tableView headerBeginRefreshing];
    
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}


- (void)headerRereshing
{
    [_pathModel pathTravelRefrsh:^(NSMutableArray *travelBlock)
    {
        [_modelView removeFromSuperview];
        
        if ([travelBlock count] >0)
        {
            [_dataArray removeAllObjects];
            
            [_sectionArray removeAllObjects];
            
            _dataArray = [travelBlock mutableCopy];
            
            for (int i = 0; i < [travelBlock count]; i++)
            {
                if (i == 0)
                {
                    [_sectionArray addObject:@"0"];
                }
                else
                {
                    [_sectionArray addObject:@"0"];
                }
            }
            [self.tableView reloadData];
        }
        else
        {
            
            if ([_dataArray count] == 0)
            {
                [_errorView removeFromSuperview];
                [self showNetWorkView];
            }
        }
        
        [self.tableView headerEndRefreshing];
    }];
    
}


- (void)footerRereshing
{
    if (_modelView == nil)
    {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }
    
    [self.view addSubview:_modelView];
    
    [_pathModel pathTravelLoadMore:^(NSMutableArray *travelBlock)
     {
         [_modelView removeFromSuperview];
         
         if ([travelBlock count] >0)
         {
             [_dataArray removeAllObjects];
             
             [_sectionArray removeAllObjects];
             
             _dataArray = [travelBlock mutableCopy];
             
             for (int i = 0; i < [_dataArray count]; i++)
             {
                 if (i == 0)
                 {
                     [_sectionArray addObject:@"0"];
                 }else
                 {
                     [_sectionArray addObject:@"0"];
                 }
             }
             [self.tableView reloadData];
         }
         else
         {
             if ([_dataArray count] == 0)
             {
                 [self showNetWorkView];
             }
         }
         
         [self.tableView footerEndRefreshing];
     }];

    
}

#pragma mark-- 无网络显示错误信息

- (void)showNetWorkView
{
    _errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    _errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5-64);
    
    [self.tableView addSubview:_errorView];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_dataArray count] > 0)
    {
        return [_sectionArray count];
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[_sectionArray objectAtIndex:section] intValue] == 0)
    {
        return 0;
    }
    else
    {
        return [[[_dataArray objectAtIndex:section] objectForKey:kTravelString] count];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    PathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PathTableViewCell" owner:self options:nil]lastObject];
    }
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if ([_dataArray count]  > 0)
    {
        if ([[[_dataArray objectAtIndex:section] objectForKey:kTravelString] count] > 0)
        {
            PathTravelInfo *info = [[[_dataArray objectAtIndex:section] objectForKey:kTravelString] objectAtIndex:row];
            [cell fillData:info];
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_dataArray count] > 0)
    {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_dataArray  count] > 0)
    {
        if ([_dataArray  count] - 1 >= section)
        {
            PathHeaderButton *headerBtn = [[PathHeaderButton alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
            
            headerBtn.numberString = [NSString stringWithFormat:@"%d",(int)[[[_dataArray objectAtIndex:section] objectForKey:kTravelString] count]];
            
            headerBtn.backgroundColor = [UIColor whiteColor];
            [headerBtn setTitle:[[_dataArray objectAtIndex:section] objectForKey:kDateString] forState:UIControlStateNormal];
            
            int string = [[_sectionArray objectAtIndex:section] intValue];
            
            if (string == 0)
            {
                [headerBtn setImage:[UIImage imageNamed:@"icon_sort_hiden.png"] forState:UIControlStateNormal];
            }
            else
            {
                [headerBtn setImage:[UIImage imageNamed:@"icon_sort_show.png"] forState:UIControlStateNormal];
            }
            [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            headerBtn.titleLabel.font = kLevelTwoFont;
            headerBtn.tag = section;
            [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            return headerBtn;
        }
        else
        {
            return nil;
        }
    }
    return nil;
}

- (void)headerBtnClick:(PathHeaderButton *)sender
{
    int string = [[_sectionArray objectAtIndex:sender.tag] intValue];
    if (string == 0)
    {
        [sender setImage:[UIImage imageNamed:@"icon_sort_show.png"] forState:UIControlStateNormal];
        string = 1;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"icon_sort_hiden.png"] forState:UIControlStateNormal];
        string = 0;
    }
    
    [_sectionArray replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%d",string]];
    
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PathDetailInfo *info =  [[[[_dataArray objectAtIndex:indexPath.section] objectForKey:kTravelString] objectAtIndex:indexPath.row] detailInfo];
    
    if (_mapDetailViewController == nil)
    {
        _mapDetailViewController = [[MapDetailViewController alloc]init];
    }
    
    [self.navigationController pushViewController:_mapDetailViewController animated:YES];
    
    _mapDetailViewController.detailInfo = info;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
