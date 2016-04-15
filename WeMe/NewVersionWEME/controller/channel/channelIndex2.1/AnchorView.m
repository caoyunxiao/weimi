//
//  AnchorView.m
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "AnchorView.h"
#import "AnchorViewCell.h"
#import "httpTool.h"

@implementation AnchorView

- (void)awakeFromNib
{
    
    
    _startPage = 1;
    _pageCount = 30;
    
    self.AnchorViewTableView.dataSource = self;
    self.AnchorViewTableView.delegate = self;
    
    _fenleiArray = [[NSMutableArray alloc]init];        //分类数据源
    _anchorArr = [[NSMutableArray alloc]init];          //主播数据源
    
    [self getFenLeiWithTypeFromDataCache];              //得到搜索类别标签缓存
    [self prepareDataWithDicFromDataCache];             //获取主播数据缓存
    
    [self getFenLeiWithType];                           //得到搜索类别标签
    [self prepareDataWithDicAboutAnchor];               //获取主播数据
    
    [self refreshData];//刷新加载数据
}

#pragma mark - 得到搜索类别标签缓存
- (void)getFenLeiWithTypeFromDataCache
{
    [_fenleiArray removeAllObjects];
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"getFenLeiWithType"];
    if(resultDic != nil)
    {
        NSArray * resultArr = [resultDic objectForKey:@"list"];
        if (resultArr.count>0)
        {
            NSMutableArray * dataArr = [NSMutableArray array];
            for (NSDictionary * dic in resultArr) {
                [dataArr addObject:[NewChannelModel getModelWithDic:dic]];
            }
            if (dataArr.count>0)
            {
                _fenleiArray = dataArr;
                [self.AnchorViewTableView reloadData];
            }
        }
    }
}

#pragma mark - 获取主播数据缓存
- (void)prepareDataWithDicFromDataCache
{
    _isLoadDataCache = YES;
    [_anchorArr removeAllObjects];
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"prepareDataWithDicAboutAnchor"];
    if(resultDic != nil)
    {
        if ([[resultDic objectForKey:@"list"]isKindOfClass:[NSArray class]])
        {
            NSArray * listArr = [resultDic objectForKey:@"list"];
            if (listArr.count>0)
            {
                NSMutableArray * dataArr = [[NSMutableArray alloc]init];
                for (NSDictionary * infoDic in listArr)
                {
                    [dataArr addObject:[NewChannelModel getModelWithDic:infoDic]];
                }
                if (dataArr.count>0)
                {
                    _anchorArr = dataArr;
                    [self.AnchorViewTableView reloadData];
                }
            }
            else
            {
                //
            }
        }

    }
}

#pragma mark--得到搜索类别标签--
- (void)getFenLeiWithType
{
    [RequestEngine getCatalogInfoWithType:@"1" startPg:1 pageSize:30 completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *result) {
        if ([errorCode isEqualToString:@"0"])
        {
            //本地缓存
            [self putNSDictionary:result withKey:@"getFenLeiWithType"];
            [_fenleiArray removeAllObjects];
            _fenleiArray = dataArray;
            if(_fenleiArray.count>0)
            {
                [self.AnchorViewTableView reloadData];
            }
        }
        else
        {
            //Alert(@"主人,获取类别失败,请稍后再试吧");
        }
    }];
}

#pragma mark - 获取主播数据
- (void)prepareDataWithDicAboutAnchor
{
    if(_isLoadDataCache)
    {
        [_anchorArr removeAllObjects];
        _isLoadDataCache = NO;
    }
    __weak typeof(self)selfvc=self;
    NSString *startPageStr = [NSString stringWithFormat:@"%ld",(long)_startPage];
    NSString *pageCountStr = [NSString stringWithFormat:@"%ld",(long)_pageCount];
    NSDictionary *dict = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"channelNumber":@"",@"infoType":@"2",@"channelStatus":@"2",@"startPage":startPageStr,@"pageCount":pageCountStr,@"cityCode":@"",@"channelName":@"",@"catalogID":@"",@"channelKeyWord":@"",@"sortField":@"userCount,popularity"};
    [RequestEngine getAnchorList:dict completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict) {
        [selfvc endRefresh];
      
        if([errorCode isEqualToString:@"0"])
        {
            //本地缓存
            [selfvc putNSDictionary:resultDict withKey:@"prepareDataWithDicAboutAnchor"];
            [_anchorArr addObjectsFromArray:dataArray];
        }
        else
        {
            //
        }
        [selfvc.AnchorViewTableView reloadData];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark-设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (self.frame.size.width - 1) / 2;
    if(indexPath.row == 0)
    {
        return 120;
    }
    else
    {
        if(_anchorArr.count>0)
        {
            NSInteger num = _anchorArr.count/2;
            if(_anchorArr.count%2!=0)
            {
                num ++;
            }
            return (width+1)*num;
        }
        else
        {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        static NSString * indentifer = @"AnchorViewOne";
        AnchorViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AnchorViewCell" owner:self options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if(_fenleiArray.count>0)
        {
            [cell setAnchorViewOneWithArray:_fenleiArray];
        }
        return cell;
    }
    else
    {
        static NSString * indentifer = @"AnchorViewTwo";
        AnchorViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"AnchorViewCell" owner:self options:nil]objectAtIndex:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        if(_anchorArr.count>0)
        {
            [cell setAnchorViewTwoWithArray:_anchorArr];
        }
        return cell;
    }
}
#pragma mark - 主播分类选择
- (void)selectAnchorCellClassButton:(NewChannelModel *)model
{
    if([self.delegate respondsToSelector:@selector(selectAnchorOneClassButton:)])
    {
        [self.delegate selectAnchorOneClassButton:model];
    }
}
#pragma mark - 点击查看主播详情
- (void)selectAnchorDetailInfor:(NewChannelModel *)model
{
    if([self.delegate respondsToSelector:@selector(selectAnchorDetailInforOfView:)])
    {
        [self.delegate selectAnchorDetailInforOfView:model];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [self.AnchorViewTableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
    [self.AnchorViewTableView addFooterWithTarget:self action:@selector(footerRefresh)];//尾部加载
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    _startPage = 1;
    [_anchorArr removeAllObjects];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self prepareDataWithDicAboutAnchor];
    });
    
}
#pragma mark - 上拉加载
- (void)footerRefresh
{
    _startPage ++;
    
    //延时主要是
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self prepareDataWithDicAboutAnchor];

    });
    
    
}
#pragma mark - 头部尾部停止刷新
- (void)endRefresh
{
    [self.AnchorViewTableView  headerEndRefreshing];
    [self.AnchorViewTableView footerEndRefreshing];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
