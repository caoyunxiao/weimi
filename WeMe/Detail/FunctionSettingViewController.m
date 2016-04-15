//
//  FunctionSettingViewController.m
//  微密
//
//  Created by longlz on 14-7-15.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "FunctionSettingViewController.h"
#import "FunctionInfo.h"
#import "FunctionModel.h"
#import "FunctionHeaderInfo.h"



#define kFunctionArray @"kFunctionArray"

#define kFunctionInfo @"kFunctionInfo"
#import "MobClick.h"

@interface FunctionSettingViewController ()
{
    FunctionModel *_model;
    UISwitch *_switchChange;
    
    NSMutableArray  *_backupArray;
    NSMutableArray  *_catelogArray;
    
    ModelView *_modelView;
    FunctionSettingHeaderButton *_headerButtons;
}

@end

@implementation FunctionSettingViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"安驾提醒";
    }
    return self;
}

#pragma mark -- 视图加载
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 55) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
   
    [self.view addSubview:_tableView];
     _tableView.tableFooterView = [[UIView alloc]init];
    [self prepareData];
    //[self addRightnav];
    
    
}

- (void)addRightnav
{
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick:)];
}


#pragma mark --
#pragma mark -- 订阅
- (void)saveClick:(id)sender
{
    if (_modelView == nil)
    {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }
    [self.view addSubview:_modelView];
    int cCount = (int)[_catelogArray count];
    for (int i = 0; i < cCount; i++)
    {
        NSMutableArray  *array = [[_dataArray objectAtIndex:i]objectForKey:kFunctionArray];
        int aCount = (int)[array count];
        
        for (int j = 0; j <aCount; j++)
        {
            [_backupArray addObject:[array objectAtIndex:j]];
        }
    }
    __weak ModelView *pModel = _modelView;
    //__weak FunctionSettingViewController *pThis = self;
    [_model setListFunction:_backupArray setFunction:^(BOOL BSucceeed)
     {
         [pModel removeFromSuperview];
         
         if (BSucceeed)
         {
             //Alert(@"主人,设置成功哦");
             [MBProgressHUD showSuccess:@"主人,设置成功哦"];
             //[pThis.navigationController popViewControllerAnimated:YES];
         }else
         {
             //Alert(@"主人,设置失败,请稍后再试吧");
             [MBProgressHUD showError:@"主人,设置失败,请稍后再试吧"];
         }
     }];
}


#pragma mark --
#pragma mark -- 视图加载
- (void)prepareData
{
    _dataArray = [[NSMutableArray alloc]init];
    _catelogArray = [[NSMutableArray alloc]init];
    _backupArray = [[NSMutableArray alloc]init];
    
    if (_modelView == nil)
    {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }
    
    [self.view addSubview:_modelView];
    _model = [[FunctionModel alloc]init];
    
    [_model getListFunction:^(NSMutableArray *listArray)
     {
         [_modelView removeFromSuperview];
         
         if ([listArray count] > 0)
         {
             _dataArray = [listArray mutableCopy];
             
             int dCount = (int)[_dataArray count];
             
             for (int i = 0; i < dCount; i++)
             {
                 [_catelogArray addObject:[[_dataArray objectAtIndex:i] objectForKey:kFunctionInfo]];
             }
             [_tableView reloadData];
             //[self addQuanXun];
         }else
         {
             [self showNetWorkView];
         }
     }];
   
}
#pragma mark -- 改版后调整的 --
- (void)addQuanXun
{
   _headerButtons  = (FunctionSettingHeaderButton *)[[[NSBundle mainBundle]loadNibNamed:@"FunctionSettingHeaderButton" owner:self options:nil]lastObject] ;
    _headerButtons.frame = CGRectMake(0, ScreenHeight-50, ScreenWidth, 50);
    _headerButtons.tishiLable.text = @"全选/取消";
    _headerButtons.allLabel.text = [NSString stringWithFormat:@"%d",[self allOrderNumber]];
    int number = [self judgeSelectdNumber:0];
    if (number < 0)
    {
        _headerButtons.actualLabel.text = [NSString stringWithFormat:@"0"];
    }else
    {
        _headerButtons.actualLabel.text = [NSString stringWithFormat:@"%d",number];
    }
    _headerButtons.isSelected = [self judgeIsAllSelected:0];
    _headerButtons.tag = 0;
    _headerButtons.delegate = self;
    _headerButtons.actualLabel.textColor = [UIColor whiteColor];
    _headerButtons.allLabel.textColor = [UIColor whiteColor];
    _headerButtons.xiegangLable.textColor = [UIColor whiteColor];
    [_headerButtons addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _headerButtons.backgroundColor = [UIColor colorWithRed:252/255.0 green:135/255.0 blue:9/255.0 alpha:1];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(valueChanged) name:@"switch" object:nil];
    [self.view addSubview:_headerButtons];
}
- (void)valueChanged
{
    NSLog(@"收到通知了");
    int number = [self judgeSelectdNumber:0];
    if (number < 0)
    {
        _headerButtons.actualLabel.text = [NSString stringWithFormat:@"0"];
    }else
    {
        _headerButtons.actualLabel.text = [NSString stringWithFormat:@"%d",number];
    }
    _headerButtons.isSelected = [self judgeIsAllSelected:0];
    _headerButtons.allLabel.text = [NSString stringWithFormat:@"%d",[self allOrderNumber]];
    
}
#pragma mark--
#pragma mark-- 网络错误或者无数据

- (void)showNetWorkView
{
    NetworkErrorView *errorView = (NetworkErrorView *)[[[NSBundle mainBundle]loadNibNamed:@"NetworkErrorView" owner:self options:nil]lastObject];
    
    errorView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
    
    [self.view addSubview:errorView];
}


#pragma mark --
#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_catelogArray count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArray count] > 0 )
    {
        FunctionHeaderInfo *headerInfo = [_catelogArray objectAtIndex:section];
        
        if ([headerInfo.isSelectd intValue] == 1)
        {
            return [[[_dataArray objectAtIndex:section] objectForKey:kFunctionArray] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_dataArray count] == 0) {
        return nil;
    }
    
    static NSString *cellID = @"cellID";
    
    FunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = (FunctionTableViewCell *)[[[NSBundle mainBundle]loadNibNamed:@"FunctionTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.delegate = self;
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    FunctionInfo *info = [[[_dataArray objectAtIndex:section] objectForKey:kFunctionArray] objectAtIndex:row];
    cell.titleLabel.text = info.subName;
    cell.detailLabel.text = info.intro;
    
    cell.section = (int)section;
    cell.row = (int)row;
    
    if ([info.selected intValue] == 1)
    {
        cell.orderSwitch.on = YES;
    }
    else
    {
        cell.orderSwitch.on = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect rect = [info.intro boundingRectWithSize:CGSizeMake(248, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.detailLabel.font} context:nil];
    cell.detailLabel.frame = CGRectMake(15, 31, 248, rect.size.height);
    return cell;

}

- (CGFloat)getHeight:(NSIndexPath *)indexPath
{
    FunctionInfo *info = [[[_dataArray objectAtIndex:indexPath.section] objectForKey:kFunctionArray] objectAtIndex:indexPath.row];
    UIFont * font = [UIFont systemFontOfSize:11];
    CGRect rect = [info.intro boundingRectWithSize:CGSizeMake(248, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getHeight:indexPath]+36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 50;
    }
}


#pragma mark--
#pragma mark-- 全部订阅列表

- (int)allOrderNumber
{
    int sCount = 0;
    int allCount = (int)[_dataArray count];
    
    for (int i = 0; i < allCount; i++)
    {
        NSArray *array = [[_dataArray objectAtIndex:i]objectForKey:kFunctionArray];
        int aCount = (int)[array count];
        sCount += aCount;
    }
    return --sCount;
}


#pragma mark--
#pragma mark-- 订阅数目
- (int)judgeSelectdNumber:(int)section
{
    int sCount = 0;
    
    if (section == 0)
    {
        int allCount = (int)[_dataArray count];
        
        for (int i = 0; i < allCount; i++)
        {
            NSArray *array = [[_dataArray objectAtIndex:i]objectForKey:kFunctionArray];
            int aCount = (int)[array count];
            for (int j = 0; j < aCount; j++)
            {
                FunctionInfo *info = [array objectAtIndex:j];
                if ([info.selected intValue] == 1)
                {
                    sCount++;
                }
            }
        }
        
        return --sCount;
    }
    
    NSArray *array = [[_dataArray objectAtIndex:section]objectForKey:kFunctionArray];
    int aCount = (int)[array count];
    
    for (int i = 0; i < aCount; i++)
    {
        FunctionInfo *info = [array objectAtIndex:i];
        
        if ([info.selected intValue] == 1)
        {
            sCount++;
        }
    }
    return sCount;
}

#pragma mark--
#pragma mark-- tableView  Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FunctionSettingHeaderButton *headerButton = (FunctionSettingHeaderButton *)[[[NSBundle mainBundle]loadNibNamed:@"FunctionSettingHeaderButton" owner:self options:nil]lastObject] ;
    
    headerButton.tag = section;
    headerButton.section = (int)section;
    
    FunctionHeaderInfo *info = [_catelogArray objectAtIndex:section];
    
    [headerButton setTitle:info.catalogName forState:UIControlStateNormal];
    headerButton.titleLabel.font = kLevelTwoFont;
    [headerButton setTitleColor:kLevelTwoColor forState:UIControlStateNormal];
    if (section != 0)
    {
        headerButton.allLabel.text = [NSString stringWithFormat:@"%d",(int)[[[_dataArray objectAtIndex:section] objectForKey:kFunctionArray] count]];
        
        if ([info.isSelectd isEqualToString:@"1"])
        {
            [headerButton setImage:[UIImage imageNamed:@"icon_sort_show.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            [headerButton setImage:[UIImage imageNamed:@"icon_sort_hiden.png"] forState:UIControlStateNormal];
            
        }
    }else
    {
        [headerButton setTitle:@"一键订阅" forState:UIControlStateNormal];
        headerButton.allLabel.text = [NSString stringWithFormat:@"%d",[self allOrderNumber]];
    }
    
    
    int number = [self judgeSelectdNumber:(int)section];
    //NSLog(@"number == %d",number);
    if (number < 0)
    {
        headerButton.actualLabel.text = [NSString stringWithFormat:@"0"];
    }else
    {
        headerButton.actualLabel.text = [NSString stringWithFormat:@"%d",number];
    }
    
    
    headerButton.isSelected = [self judgeIsAllSelected:(int)section];
    
    
    headerButton.backgroundColor = [UIColor whiteColor];
    [headerButton addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    headerButton.delegate = self;
    
    return headerButton;
}

#pragma mark--
#pragma mark-- cell delegate

- (void)functionCallback:(int)section  row:(int)row isSelected:(BOOL)isSelected
{
    FunctionInfo *info = [[[_dataArray objectAtIndex:section]objectForKey:kFunctionArray] objectAtIndex:row];
    
    if (isSelected)
    {
        info.selected = @"1";
    }
    else
    {
        info.selected = @"0";
    }
    __weak typeof(self) selfVc=self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(0.5);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"switch" object:self];
            [_tableView reloadData];
            //修改保存的
            [selfVc saveClick:nil];
        });
    });
}

#pragma mark --
#pragma mark --  折叠函数

- (void)headerBtnClick:(FunctionSettingHeaderButton *)headerBtn
{
    if (headerBtn.tag == 0)
    {
        return;
    }
    FunctionHeaderInfo *info = [_catelogArray objectAtIndex:headerBtn.tag];
    
    if ([info.isSelectd intValue]== 0)
    {
        [headerBtn setImage:[UIImage imageNamed:@"icon_sort_show.png"] forState:UIControlStateNormal];
        info.isSelectd = @"1";
    }
    else
    {
        [headerBtn setImage:[UIImage imageNamed:@"icon_sort_hiden.png"] forState:UIControlStateNormal];
        info.isSelectd = @"0";
    }
    [_tableView reloadData];
}

#pragma mark --
#pragma mark --  判断每块是否全部选中

- (BOOL)judgeIsAllSelected:(int)section
{
    if (section == 0)
    {
        int cCount = (int)[_catelogArray count];
        
        for (int i = 0; i < cCount; i++)
        {
            NSMutableArray  *array = [[_dataArray objectAtIndex:i]objectForKey:kFunctionArray];
            
            int aCount = (int)[array count];
            
            for (int j = 0; j < aCount; j++)
            {
                FunctionInfo *info = [array objectAtIndex:j];
                if ([info.selected intValue] == 0)
                {
                    return NO;
                }
            }
        }
        //        return YES;
    }
    
    NSMutableArray *array = [[_dataArray objectAtIndex:section]objectForKey:kFunctionArray];
    int aCount = (int)[array count];
    
    for (int i = 0; i < aCount; i++)
    {
        FunctionInfo *info = [array objectAtIndex:i];
        if ([info.selected intValue] == 0) {
            return NO;
        }
    }
    return YES;
}


#pragma mark --
#pragma mark --  section 头部 UISwitch 触发事件

- (void)functionValueChanage:(int)section isSeleted:(BOOL)isSeleted;
{
    __weak typeof(self) selfVc=self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       sleep(0.5);
                       
                       if (section == 0)
                       {
                           if (isSeleted)
                           {
                               int cCount = (int)[_catelogArray count];
                               
                               for (int i = 0; i < cCount; i++)
                               {
                                   NSMutableArray  *array = [[_dataArray objectAtIndex:i]objectForKey:kFunctionArray];
                                   int aCount = (int)[array count];
                                   
                                   for (int j = 0; j <aCount; j++)
                                   {
                                       FunctionInfo *info = [array objectAtIndex:j];
                                       
                                       info.selected = @"1";
                                       
                                   }
                               }
                           }
                           else
                           {
                               int cCount = (int)[_catelogArray count];
                               
                               for (int i = 0; i < cCount; i++)
                               {
                                   NSMutableArray  *array = [[_dataArray objectAtIndex:i]objectForKey:kFunctionArray];
                                   int aCount = (int)[array count];
                                   
                                   for (int j = 0; j < aCount; j++)
                                   {
                                       FunctionInfo *info = [array objectAtIndex:j];
                                       info.selected = @"0";
                                   }
                               }
                           }
                       }
                       else
                       {
                           if (isSeleted)
                           {
                               NSMutableArray  *array = [[_dataArray objectAtIndex:section]objectForKey:kFunctionArray];
                               
                               int aCount = (int)[array count];
                               for (int j = 0; j < aCount; j++)
                               {
                                   FunctionInfo *info = [array objectAtIndex:j];
                                   info.selected = @"1";
                               }
                           }
                           else
                           {
                               
                               NSMutableArray  *array = [[_dataArray objectAtIndex:section]objectForKey:kFunctionArray];
                               
                               int aCount = (int)[array count];
                               
                               for (int j = 0; j < aCount; j++)
                               {
                                   FunctionInfo *info = [array objectAtIndex:j];
                                   info.selected = @"0";
                               }
                           }
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"switch" object:self];
                           [_tableView reloadData];
                           //修改保存的
                           [selfVc saveClick:nil];
                       });
                       
                   });
    
}


#pragma mark --
#pragma mark --  Cell uiswitch 触发事件

- (void)switchChange:(UISwitch *)change
{
    int section = (int)change.tag / 1000;
    
    int row = change.tag % 1000;
    
    FunctionInfo *info = [[[_dataArray objectAtIndex:section]objectForKey:kFunctionArray] objectAtIndex:row];
    
    if (change.isOn)
    {
        info.selected = @"1";
    }
    else
    {
        info.selected = @"0";
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
