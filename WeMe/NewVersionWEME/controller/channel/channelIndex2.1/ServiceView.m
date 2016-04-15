//
//  ServiceView.m
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ServiceView.h"
#import "ServiceViewCell.h"
#import "ServerZFJModel.h"

@interface ServiceView()

@property(nonatomic,strong)UIButton  *currentBtn;//当前选中的btn
@property(nonatomic,assign)NSInteger cutBtnTag;
@property(nonatomic,strong)UIAlertView *alert;

@end

@implementation ServiceView

- (void)awakeFromNib
{
    _startPage = 1;
    _pageCount = 20;
    [self refreshData];//刷新加载数据
    self.ServiceViewTableView.dataSource = self;
    self.ServiceViewTableView.delegate = self;
    
    _dataArray = [[NSMutableArray alloc]init];    //数据源数组
    
    [self getUserkeyInfoCompletedFromDataCache];  //获取该频道是否关联吐槽键缓存
    [self getServerChannelArrayFromDataCache];    //获取服务频道数据列表缓存
    
    [self getUserkeyInfoCompleted];               //获取该频道是否关联吐槽键
    [self getServerChannelArray];                 //获取服务频道数据列表
    
    [self setExtraCellLineHidden:self.ServiceViewTableView];
}

#pragma mark - 获取该频道是否关联吐槽键缓存
- (void)getUserkeyInfoCompletedFromDataCache
{
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"prepareDataWithDicAboutAnchor"];
    if(resultDic != nil)
    {
        NSArray *list = [resultDic objectForKey:@"list"];
        
        NSDictionary *dict = [list firstObject];
        _customType = [dict objectForKey:@"customType"];
        [self.ServiceViewTableView reloadData];
    }
}

#pragma mark - 获取服务频道数据列表缓存
- (void)getServerChannelArrayFromDataCache
{
    _isLoadDataCache = YES;
    [_dataArray removeAllObjects];
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"getServerChannelArray"];
    if(resultDic != nil)
    {
        NSArray *list = [resultDic objectForKey:@"list"];
        for (NSDictionary *dict in list)
        {
            ServerZFJModel *model = [[ServerZFJModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArray addObject:model];
        }
        if(_dataArray.count>0)
        {
            [self.ServiceViewTableView reloadData];
        }
    }
}

#pragma mark - 隐藏多余的cell分界面
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifer = @"ServiceViewCell";
    ServiceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ServiceViewCell" owner:self options:nil]objectAtIndex:0];
    }
    if(_dataArray.count>0 && _customType != nil)
    {
        [cell setUIViewWithMOdel:[_dataArray objectAtIndex:indexPath.row] customType:_customType];
        [cell.ImmediatelyUseButton addTarget:self action:@selector(relationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma mark - 关联吐槽键
- (void)relationButtonClick:(UIButton *)button
{
    
    self.currentBtn=button;
    self.cutBtnTag=button.tag - 1250;
    if ([button.titleLabel.text isEqualToString:@"已关联吐槽键"]) {
        
        static NSString *msg=@"主人，您当前已关注此吐槽键哦，关联其他吐槽键看看";
        self.alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [self.alert show];
        
    }else
    {
        static NSString *msg=@"主人，点击确认后，您的吐槽键将使用新的服务频道功能噢 ";
        self.alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [self.alert show];
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==self.alert) {
        if (buttonIndex==1) {

            //确认
            if ([self.currentBtn.titleLabel.text isEqualToString:@"已关联吐槽键"]) {
                return;
            }else
            {
                [RequestEngine setOnlyOneUserkeyInfoActionType:@"3" customType:[NSString stringWithFormat:@"%ld",self.cutBtnTag] completed:^(NSString *errorCode, NSDictionary *resultDic) {
                    if([errorCode isEqualToString:@"0"])
                    {
                        [self.currentBtn setTitle:@"已关联吐槽键" forState:UIControlStateNormal];
                        [self.currentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        [self getUserkeyInfoCompleted];
                    }
                    
                }];
                
            }
        }
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ServerZFJModel *model = [_dataArray objectAtIndex:indexPath.row];
    if([self.delegate respondsToSelector:@selector(selectServiceChannelCell:)])
    {
        [self.delegate selectServiceChannelCell:model];
    }
}
#pragma mark - 获取服务频道数据列表
- (void)getServerChannelArray
{
    if(_isLoadDataCache)
    {
        [_dataArray removeAllObjects];
        _isLoadDataCache = NO;
    }
    NSString *startPageStr = [NSString stringWithFormat:@"%ld",_startPage];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",_pageCount];
    [Request1617 getCustomDefineInfo:startPageStr pageCount:pageCountStr longitude:@"" latitude:@"" defineName:@"" actionType:@"" completed:^(NSString *errorCode, NSDictionary *resultDict) {
        [self endRefresh];
        if([errorCode isEqualToString:@"0"])
        {
            //缓存数据
            [self putNSDictionary:resultDict withKey:@"getServerChannelArray"];
            NSArray *list = [resultDict objectForKey:@"list"];
            // NSLog(@"==================%@",list);
            for (NSDictionary *dict in list)
            {
                ServerZFJModel *model = [[ServerZFJModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_dataArray addObject:model];
            }
            if(_dataArray.count>0)
            {
                [self.ServiceViewTableView reloadData];
            }
        }
        else
        {
            //Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}

#pragma mark - 获取该频道是否关联吐槽键
- (void)getUserkeyInfoCompleted
{
    //    NSString *actionType=nil;
    [RequestEngine getUserkeyInfo:@"3" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
        //NSLog(@"yonghu============%@",resultDic);
        
        if([errorCode isEqualToString:@"0"])
        {
            if([errorCode isEqualToString:@"0"])
            {
                [self putNSDictionary:resultDic withKey:@"getUserkeyInfoCompleted"];
                NSArray *list = [resultDic objectForKey:@"list"];
                NSDictionary *dict = [list firstObject];
                _customType = [dict objectForKey:@"customType"];
                [self.ServiceViewTableView reloadData];
            }
            else
            {
                //Alert(@"主人,网络不给力啊,请检查一下网络吧");
            }
        }
    }];
}

#pragma mark - 把字典存在本地
- (void)putNSDictionary:(NSDictionary *)dict withKey:(NSString *)keyName
{
    NSString *pathStr = [self filePath:keyName];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:keyName];
    [archiver finishEncoding];
    [data writeToFile:pathStr atomically:YES];
}

#pragma mark - 从本地读取字典
- (NSDictionary *)getNSDictionaryWithName:(NSString *)keyName
{
    NSString *pathStr = [self filePath:keyName];
    NSData *data= [[NSMutableData alloc]initWithContentsOfFile:pathStr];
    NSKeyedUnarchiver *unarchiver= [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dict = [unarchiver decodeObjectForKey:keyName];
    [unarchiver finishDecoding];
    return dict;
}

#pragma mark - 缓存路径
- (NSString *)filePath:(NSString *)fileName
{
    NSString *homePath = NSHomeDirectory();
    homePath = [homePath stringByAppendingPathComponent:@"Documents/DataCache"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:homePath])
    {
        [fm createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(fileName && fileName.length !=0)
    {
        homePath = [homePath stringByAppendingPathComponent:fileName];
    }
    return homePath;
}
#pragma mark - 刷新控件
- (void)refreshData
{
    [self.ServiceViewTableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [self.ServiceViewTableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    _startPage = 1;
    [_dataArray removeAllObjects];
    [self getServerChannelArray];
}
#pragma mark - 上拉加载
- (void)footerRefresh
{
    _startPage ++;
    [self getServerChannelArray];
}
#pragma mark - 头部尾部停止刷新
- (void)endRefresh
{
    [self.ServiceViewTableView  headerEndRefreshing];
    [self.ServiceViewTableView footerEndRefreshing];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
