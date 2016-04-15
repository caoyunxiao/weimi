//
//  GroupChatView.m
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "GroupChatView.h"
#import "GroupChatViewCell.h"
#import "SetModelZFJ.h"
#import "TestViewController.h"
#import "httpTool.h"

@interface GroupChatView()<selectClassCellDelgate>

/**
 *  当前选中的关联按钮
 */
@property(nonatomic,strong)UIButton *currentBtn;

/**
 *  关联+上一个按钮
 */
@property(nonatomic,strong)UIButton *preAddBtn;
/**
 *  关联++上一个按钮
 */
@property(nonatomic,strong)UIButton *preAddAddBtn;

@property(nonatomic,assign)NSInteger singleActionType;



@end

@implementation GroupChatView

- (void)awakeFromNib
{
    _indexRequest = 0;
    [self refreshData];   //加载刷新控件
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addEmpty) name:refreshDeviceNotificationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];   //通知刷新界面
    
    //置空通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEmpty) name:emptyNotificationName object:nil];
    
    //设置+键通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEmpty) name:refreshNotificationName object:nil];
    
    //刷新热门频道
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTogeTher) name:togetherTalkNofitificationName object:nil];
    
    self.GroupChatTableView.dataSource = self;
    self.GroupChatTableView.delegate = self;
    
    _settingArr = [[NSMutableArray alloc]init];
    _hotArray = [[NSMutableArray alloc]init];
    _classArray = [[NSMutableArray alloc]init];
    
    [self getDataFromDataCache];                       //从本地读取设置缓存信息
    [self prepareDataFromDataCache];                   //获取热门推荐数据缓存
    [self getFenleiDataFromDataCache];                 //得到分类数据缓存
    
    [self getUserkeyInfoCompleted];                    //获取频道设置数据
    [self prepareDataWithDic];                         //获取热门推荐数据
    [self getFenleiData];                              //得到分类数据
    [self headerRefresh];//刷新数据
}

/**
 *  刷新群聊
 */
-(void)refreshTogeTher{
    [self headerRefresh];
}

/**
 *  +键置空
 */
-(void)addEmpty{
    NSLog(@"刷新刷新刷新刷新刷新刷新刷新刷新刷新");
    [self headerRefresh];
}
#pragma mark - 顶部cell跳转到我的频道管理界面的代理
-(void)topCellRedict:(UIGestureRecognizer*)recognizer{
    if ([self.delegate respondsToSelector:@selector(homePageRedict:)]) {
        [self.delegate homePageRedict:recognizer];
    }
}

#pragma mark - 得到分类数据缓存
- (void)getFenleiDataFromDataCache
{
    [_classArray removeAllObjects];
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"getFenleiData"];
    if(resultDic != nil)
    {
        NSArray * resultArr = [resultDic objectForKey:@"list"];
        if (resultArr.count>0)
        {
            NSMutableArray * dataArr = [NSMutableArray array];
            for (NSDictionary * dic in resultArr)
            {
                [dataArr addObject:[NewChannelModel getModelWithDic:dic]];
            }
            if (dataArr.count>0)
            {
                _classArray = dataArr;
                [self.GroupChatTableView reloadData];
            }
        }
    }
}

#pragma mark - 从本地读取设置缓存信息
- (void)getDataFromDataCache
{
    [_settingArr removeAllObjects];
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"getUserkeyInfoCompleted"];
    if(resultDic != nil)
    {
        NSArray *list = [resultDic objectForKey:@"list"];
        for (NSDictionary *dict in list)
        {
            SetModelZFJ *model = [[SetModelZFJ alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [_settingArr addObject:model];
        }
        if(_settingArr.count>0)
        {
            [self.GroupChatTableView reloadData];
        }
    }
}
#pragma mark - 获取热门推荐数据缓存
- (void)prepareDataFromDataCache
{
    [_hotArray removeAllObjects];
    NSDictionary *resultDic = [self getNSDictionaryWithName:@"prepareDataWithDic"];
    if(resultDic != nil)
    {
        NSArray * listArr = [resultDic objectForKey:@"list"];
        if ([listArr isKindOfClass:[NSArray class]])
        {
            if (listArr.count>0)
            {
                NSMutableArray * dataArr = [[NSMutableArray alloc]init];
                for (NSDictionary * infoDic in listArr)
                {
                    [dataArr addObject:[NewChannelModel getModelWithDic:infoDic]];
                }
                if(dataArr.count>0)
                {
                    _hotArray = dataArr;
                    [self.GroupChatTableView reloadData];
                }
            }
            else
            {
                //
            }
        }
    }
}





#pragma mark - 刷新界面
- (void)reloadData
{
    [self getUserkeyInfoCompleted];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (self.frame.size.width - 1) / 2;
    if(indexPath.row == 0)
    {
        return 160;
    }
    else if(indexPath.row == 1||indexPath.row == 8)
    {
        return 30;
    }
    else if(indexPath.row == 9)
    {
        if(_classArray.count>0)
        {
            NSInteger num = _classArray.count/2;
            if(_classArray.count%2!=0)
            {
                num ++;
            }
            return (width)*num;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 65;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:nil object:nil];
}
#pragma mark - 获取频道设置数据
- (void)getUserkeyInfoCompleted
{
    _endRefreshTimers ++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showModelView" object:nil userInfo:nil];
    _indexRequest ++;
    [RequestEngine getUserkeyInfo:@"" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
//        NSLog(@"resudic===============%@",resultDic);
        _indexRequest --;
        _endRefreshTimers --;
        if(_indexRequest==0)
        {
            //移除
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
        }
        if(_endRefreshTimers==0)
        {
            [self endRefresh];
        }
        if([errorCode isEqualToString:@"0"])
        {
            [_settingArr removeAllObjects];
            //本地缓存
            [self putNSDictionary:resultDic withKey:@"getUserkeyInfoCompleted"];
            NSArray *list = [resultDic objectForKey:@"list"];
            [list writeToFile:userKeyInfoDataPath atomically:YES];
            
            for (NSDictionary *dict in list)
            {
                SetModelZFJ *model = [[SetModelZFJ alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_settingArr addObject:model];
            }

            if(_settingArr.count>0)
            {
               
                [self.GroupChatTableView reloadData];
            }
        }
        else
        {
            //Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        static NSString * indentifer = @"GroupChatOne";
        GroupChatViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        cell.delegate=self;
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatViewCell" owner:self options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;  
        }
//        if(_settingArr.count>0)
//        {
//            //[cell setGroupChatOneValue:_settingArr];
//            
//        }
        [cell setGroupChatOneValueNew:_settingArr];
        return cell;
    }
    else if(indexPath.row == 1||indexPath.row == 8)
    {
        static NSString * indentifer = @"GroupChatTwo";
        GroupChatViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatViewCell" owner:self options:nil]objectAtIndex:1];
        }
        if(indexPath.row == 1)
        {
            cell.nameLabel.text = @"热门推荐";
        }
        else
        {
            cell.nameLabel.text = @"分类推荐";
        }
        cell.moreButton.tag = indexPath.row + 200;
        [cell.moreButton addTarget:self action:@selector(cellMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(indexPath.row == 9)
    {
        static NSString * indentifer = @"GroupChatFour";
        GroupChatViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatViewCell" owner:self options:nil]objectAtIndex:3];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(_classArray.count>0)
        {
            [cell setGroupChatFourValue:_classArray];
        }
        return cell;
    }
    else
    {
        static NSString * indentifer = @"GroupChatThree";
        GroupChatViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupChatViewCell" owner:self options:nil]objectAtIndex:2];
        }
        if(_hotArray.count>0)
        {
            NewChannelModel *model=[_hotArray objectAtIndex:indexPath.row-2];
            [cell setGroupChatThreeValue:model classArray:_settingArr];
            [cell.GCJoinButton addTarget:self action:@selector(startTalkButton:) forControlEvents:UIControlEventTouchUpInside];
            cell.GCJoinButton.tag = 10+indexPath.row;
            
            NSString *title=[self AssignValueToBtn:model arr:_settingArr];
            [cell.GCJoinButton setTitle:title forState:UIControlStateNormal];
        }
        return cell;
    }
}

/**
 *得到GCJoinButton的title
 */
-(NSString*)AssignValueToBtn:(NewChannelModel*)model arr:(NSArray*)arr{

    NSMutableArray *numberArr = [NSMutableArray array];
    if(arr.count>0)
    {
        for (int i=0; i<arr.count; i++)
        {
            SetModelZFJ *modelClass = [arr objectAtIndex:i];
            NSString *number = modelClass.customParameter;
            if(number==nil){
            number=@"";
            }
            [numberArr addObject:number];
        }
    }
    if ([numberArr indexOfObject:model.number] != NSNotFound)
    {
        
        NSInteger arrIndex=[numberArr indexOfObject:model.number];//关联键的数组下标
        SetModelZFJ *model=[arr objectAtIndex:arrIndex];//得到关联键的信息
        
        //..............
        NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
        if ([isThirdModel isEqualToString:@"1"]) {
            if([model.actionType isEqualToString:@"5"]){
                if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
                    return @"等待验证";
                }

                return @"主聊频道";
            }
        }else{
            if ([model.actionType isEqualToString:@"0"]) {
                return @"开始聊天";
            }else if([model.actionType isEqualToString:@"4"]){
                //审核未通过
                if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
                    return @"等待验证";
                }
                return @"关联+键中";
            }else if([model.actionType isEqualToString:@"5"]){
                if ([[NSString stringWithFormat:@"%@",model.talkStatus] isEqualToString:@"4"]) {
                    return @"等待验证";
                }
                return @"关联++键中";
            }
        }
    };
    return @"开始聊天";
}

#pragma mark - 分类推荐和热门推荐更多
- (void)cellMoreButton:(UIButton *)button
{
    NSInteger index = button.tag - 200;
    if([self.delegate respondsToSelector:@selector(moreButton:)])
    {
        [self.delegate moreButton:index];
    }
}


#pragma mark - 开始聊天
- (void)startTalkButton:(UIButton *)button
{

    //isThirdModel 0 是微密终端 1 是第三方
    _buttonTag = button.tag - 12;
    self.currentBtn=button;
     NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
    if ([isThirdModel isEqualToString:@"1"]) {
        NSString *messageStr= @"主人,关联新的频道后之前的频道会被覆盖掉,你将在新的频道里聊天噢";
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"主聊频道", nil];
       
    }else{
        NSString *messageStr= @"主人,关联新的频道后之前的频道会被覆盖掉,你将在新的频道里聊天噢";
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关联+键",@"关联++键", nil];
    }
     [_alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [MBProgressHUD showMessage:@"主人,关联键设置中请稍后" view:self isShow:YES];

    NSString *actionType = nil;
    if(alertView == _alert)
    {
        NSString *isThirdModel=[UserDefaults objectForKey:@"isThirdModel"];
        if ([isThirdModel isEqualToString:@"1"])
      {
          if (buttonIndex == 1)
          {
              //++键设置
              actionType = @"5";
              [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
          }

      }else{
         if (buttonIndex == 1)
          {
              //+键设置
              actionType = @"4";
              [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
          }
          else if(buttonIndex==2)
          {
              //++键设置
              actionType = @"5";
              [MBProgressHUD showMessage:@"主人正在设置中,请稍后噢" view:nil isShow:NO];
          }
      }
        if([actionType isEqualToString:@"4"]||[actionType isEqualToString:@"5"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showModelView" object:nil userInfo:nil];
            NewChannelModel * model = [_hotArray objectAtIndex:_buttonTag];
            
            NSString *isAble=[UserDefaults objectForKey:@"netWork"];
            if ([isAble isEqualToString:@"0"]) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
            }
            
            
//            [RequestEngine setOnlyOneUserkeyInfocustomType:<#(NSString *)#> actionType:<#(NSString *)#> customParameter:<#(NSString *)#> completed:<#^(NSString *errorCode, NSDictionary *resultDic)completed#>]
            //applyJoinChannel
            [RequestEngine applyJoinChannel:@""
 actionType:actionType customParameter:model.InviteUniqueCode completed:^(NSString *errorCode, NSDictionary *resultDic) {
    

     if([errorCode isEqualToString:@"0"])
     {
         [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
         BOOL isVertify=[resultDic[@"isVertify"]boolValue];
         NSString *applyIdx=resultDic[@"applyIdx"];
         if (isVertify) {
             if ([self.delegate respondsToSelector:@selector(pushToTestViewController:applyIdx:actionType:)]) {
                 [self.delegate pushToTestViewController:model applyIdx:applyIdx actionType:actionType];
             }
         }
         else{
             
            [self setUserKey:model actionType:actionType];
         }
        
         [self getUserkeyInfoCompleted];
     }
     else
     {
         [self setUserKey:model actionType:actionType];
         
         //[MBProgressHUD showError:@"主人,设置失败了，稍后再试试哟"];
     }
                [self.GroupChatTableView reloadData];
            }];
           
        }

    }
}

/**
 *  关联
 *
 *  @param model      NewChannelModel
 *  @param actionType
 */
-(void)setUserKey:(NewChannelModel*)model actionType:(NSString*)actionType{
    [RequestEngine setOnlyOneUserkeyInfocustomType:@"" actionType:actionType customParameter:model.InviteUniqueCode completed:^(NSString *errorCode, NSDictionary *resultDic) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
        if([errorCode isEqualToString:@"0"]){
            [MBProgressHUD showSuccess:@"主人设置成功了噢"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
            
            //-----------------------关联键改变了，更改数据源的信息   开始
            NSString *channelNumber=[resultDic objectForKey:@"channelNumber"];
            for (int i=0; i<_settingArr.count; i++) {
                SetModelZFJ *model=_settingArr[i];
                if ([model.actionType isEqualToString:actionType]) {
                    model.customParameter=channelNumber;
                    [_settingArr removeObjectAtIndex:i];
                    [_settingArr addObject:model];
                    
                }
                
            }
        }else{
            Alert(@"主人,设置失败了，稍后再试试哟");
        }
        [self.GroupChatTableView reloadData];
    }];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row>=2&&indexPath.row<=7)
    {
        NewChannelModel *model = [_hotArray objectAtIndex:indexPath.row-2];
        if([self.delegate respondsToSelector:@selector(selectHotChannelCell:)])
        {
            [self.delegate selectHotChannelCell:model];
        }
    }
//    else if(indexPath.row == 1||indexPath.row == 8)
//    {
//        if([self.delegate respondsToSelector:@selector(moreButton:)])
//        {
//            [self.delegate moreButton:indexPath.row];
//        }
//    }
}

#pragma mark - 获取热门推荐数据
- (void)prepareDataWithDic
{
    _indexRequest ++;
    _endRefreshTimers ++;
    NSDictionary * dic = @{@"appKey":@"iOS",@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"infoType":@"1",@"startPage":@"1",@"pageCount":@"6",@"cityCode":@"",@"channelNumber":@"",@"catalogID":@"",@"channelName":@"",@"channelKeyWords":@""};
    [RequestEngine fetchSecretChannelWithDic:dic completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *resultDict){
        _indexRequest--;
        _endRefreshTimers --;
        
        
        if(_indexRequest==0)
        {
            //移除
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
        }
        if(_endRefreshTimers==0)
        {
            [self endRefresh];
        }
        if([errorCode isEqualToString:@"0"])
        {
            //本地缓存
            [self putNSDictionary:resultDict withKey:@"prepareDataWithDic"];
            [_hotArray removeAllObjects];
            [_hotArray addObjectsFromArray:dataArray];
        }
        else
        {
            //
        }
        [self.GroupChatTableView reloadData];
    }];
}

#pragma mark - 得到分类
- (void)getFenleiData
{
    _indexRequest ++; 
    _endRefreshTimers ++;
    [RequestEngine getCatalogInfoWithType:@"2" startPg:1 pageSize:6 completed:^(NSString *errorCode, NSMutableArray *dataArray,NSDictionary *result) {
        _indexRequest --;
        _endRefreshTimers --;
        NSLog(@"current*******************************:%@",[NSThread currentThread]);
        if(_indexRequest==0)
        {
            //移除
            [[NSNotificationCenter defaultCenter] postNotificationName:@"removeModelView" object:nil userInfo:nil];
        }
        if(_endRefreshTimers==0)
        {
            [self endRefresh];
        }
        if ([errorCode isEqualToString:@"0"])
        {
            //本地缓存
            [self putNSDictionary:result withKey:@"getFenleiData"];
            [_classArray removeAllObjects];
            _classArray = dataArray;
        }
        [self.GroupChatTableView reloadData];
    }];
}
#pragma mark - 选择分类
- (void)selectClassChannelCell:(NewChannelModel *)model
{
    if([self.delegate respondsToSelector:@selector(selectClassChannelView:)])
    {
        [self.delegate selectClassChannelView:model];
    }
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
    [self.GroupChatTableView addHeaderWithTarget:self action:@selector(headerRefresh)];//头部刷新
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    _endRefreshTimers = 0;
    [self getUserkeyInfoCompleted];                    //获取频道设置数据
    [self prepareDataWithDic];                         //获取热门推荐数据
    [self getFenleiData];                              //得到分类数据
}

#pragma mark - 头部尾部停止刷新
- (void)endRefresh
{
    [self.GroupChatTableView  headerEndRefreshing];
}


-(void)clickStartChat{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
