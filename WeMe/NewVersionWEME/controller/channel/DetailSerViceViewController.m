//
//  DetailSerViceViewController.m
//  微密
//
//  Created by wemeDev on 15/5/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "DetailSerViceViewController.h"
#import "MenuListModel.h"
#import "DetailWebViewController.h"
#import "RecordsModel.h"
#import "DetailSerViceCell.h"
#import "ShowBigImageViewController.h"
#import "ShowVideoViewController.h"

@interface DetailSerViceViewController ()

@end

@implementation DetailSerViceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUserkeyInfoCompleted];
    [self setUIView];
    //上拉下拉刷新
    [self refreshData];
    NSData *jsonData = [self.dict dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = (NSDictionary *)[self toArrayOrNSDictionary:jsonData];
    NSArray *buttonArr = [dict objectForKey:@"button"];
    [self setDownTitleUIVIewWith:buttonArr];
}
#pragma mark - 设置UI
- (void)setUIView
{
//    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
//    _button.titleLabel.font = [UIFont systemFontOfSize:15];
//    _button.titleLabel.textAlignment = NSTextAlignmentRight;
//    [_button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:_button];
//    self.navigationItem.rightBarButtonItem = buttonItem;
    
    self.title = self.name;
    _isClick = YES;
    _indexButton = 0;
    _startPage = 1;
    _pageCount = 20;
    self.DetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.DetailTableView.showsVerticalScrollIndicator = NO;
    self.DetailTableView.delegate = self;
    self.DetailTableView.dataSource = self;
    _firstArray = [[NSMutableArray alloc]init];
    _secondArray = [[NSMutableArray alloc]init];
    _UIViewArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    [self getServerChannel:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount] serverChannelID:self.serverChannelID];
    //[self getServerMenuWithserverChannelID];
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
}
#pragma mark - 关联吐槽键
//- (void)rightButtonClick
//{
//    if([_button.currentTitle isEqualToString:@"已关联吐槽键"])
//    {
//        Alert(@"主人,你已经关联吐槽键了,你可以关联其它服务频道来取消该频道");
//    }
//    else
//    {
//        NSString *messageStr= @"主人,你如果重新设置了吐槽键,之前关联的服务频道将要被覆盖掉哦";
//        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"重设" otherButtonTitles:@"取消", nil];
//        [_alert show];
//    }
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView == _alert)
//    {
//        if (buttonIndex == 0)
//        {
//            //重设
//            [RequestEngine setOnlyOneUserkeyInfocustomType:self.serverChannelID actionType:@"3" customParameter:@"" completed:^(NSString *errorCode, NSDictionary *resultDic) {
//                if([errorCode isEqualToString:@"0"])
//                {
//                    [_button setTitle:@"已关联吐槽键" forState:UIControlStateNormal];
//                }
//            }];
//        }
//        else
//        {
//        }
//    }
//}
#pragma mark - 获取该频道是否关联吐槽键
- (void)getUserkeyInfoCompleted
{
    [RequestEngine getUserkeyInfo:@"3" Completed:^(NSString *errorCode, NSDictionary *resultDic) {
        if([errorCode isEqualToString:@"0"])
        {
            if([errorCode isEqualToString:@"0"])
            {
                NSArray *list = [resultDic objectForKey:@"list"];
                NSDictionary *dict = [list firstObject];
                NSString *customType = [dict objectForKey:@"customType"];
                if([_serverChannelID isEqualToString:customType])
                {
                    [_button setTitle:@"已关联吐槽键" forState:UIControlStateNormal];
                }
                else
                {
                    [_button setTitle:@"关联吐槽键" forState:UIControlStateNormal];
                }
            }
            else
            {
                Alert(@"主人,网络不给力啊,请检查一下网络吧");
            }
        }
    }];
}


- (id)toArrayOrNSDictionary:(NSData *)jsonData
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

//#pragma mark - 请求分级标题
//- (void)getServerMenuWithserverChannelID
//{
//    [self refreshWithStatus:YES];
//    [Request1617 getServerMenuWithserverChannelID:self.serverChannelID completed:^(NSString *errorCode, NSArray *resultArr) {
//        [self refreshWithStatus:NO];
//        if([errorCode isEqualToString:@"0"])
//        {
//            if(resultArr.count>0)
//            {
//                [self setDownTitleUIVIewWith:resultArr];
//            }
//            else
//            {
//                //NSLog(@"没有数据");
//            }
//        }
//    }];
//}
#pragma mark - 设置分类标题UI
- (void)setDownTitleUIVIewWith:(NSArray *)array
{
    for(NSDictionary *dict in array)
    {
        MenuListModel *model = [[MenuListModel alloc]init];
        model.childMenuList = [dict objectForKey:@"sub_button"];
        model.name = [dict objectForKey:@"name"];
        model.url = [dict objectForKey:@"url"];
        model.type = [dict objectForKey:@"type"];
        [_firstArray addObject:model];
    }
    if(_firstArray.count>0)
    {
        widthBtn = self.DetailView.frame.size.width/_firstArray.count;
        for(int i=0;i<_firstArray.count;i++)
        {
            UIButton *buttonTitle = [[UIButton alloc]init];
            if(_firstArray.count==1)
            {
                buttonTitle.frame = CGRectMake((ScreenWidth-widthBtn/2)/2, -1, widthBtn/2, self.DetailView.frame.size.height+1);
            }
            else
            {
                buttonTitle.frame = CGRectMake(widthBtn*i+1, 0, widthBtn, self.DetailView.frame.size.height);
            }
            buttonTitle.backgroundColor = [UIColor whiteColor];
            [buttonTitle setTitleColor:[UIColor colorWithRed:163/255.0 green:163 /255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            buttonTitle.titleLabel.font = [UIFont systemFontOfSize:16];
            buttonTitle.layer.borderColor = [UIColor colorWithRed:163/255.0 green:163 /255.0 blue:163/255.0 alpha:1].CGColor;
            buttonTitle.layer.borderWidth = 1.0;
            MenuListModel *model = [_firstArray objectAtIndex:i];
            [buttonTitle setTitle:model.name forState:UIControlStateNormal];
            buttonTitle.tag = 130+i;
            if(model.childMenuList.count>0)
            {
                [self createSecondTitleUIViewWith:model.childMenuList index:i];
                [buttonTitle addTarget:self action:@selector(buttonTitleSecond:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [buttonTitle addTarget:self action:@selector(buttonTitleURL:) forControlEvents:UIControlEventTouchUpInside];
            }
            _arrayCount = model.childMenuList.count;
            [self.DetailView addSubview:buttonTitle];
        }
    }
    for(int j=0;j<2;j++)
    {
        UIView *view = [[UIView alloc]init];
        if(j==0)
        {
            view.frame = CGRectMake(0, 0, ScreenWidth, 8);
        }
        else
        {
            view.frame = CGRectMake(0, self.DetailView.frame.size.height-8, ScreenWidth, 8);
        }
        view.backgroundColor = [UIColor whiteColor];
        [self.DetailView addSubview:view];
    }
}
#pragma mark - 一级标题点击事件
- (void)buttonTitleURL:(UIButton *)button
{
    NSInteger index = button.tag - 130;
    MenuListModel *model = [_firstArray objectAtIndex:index];
    DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@&longitude=%@&latitude=%@",model.url,[PersonInfo sharePersonInfo].accountIDString,self.longitude,self.latitude];
    dvc.urlStr = urlStr;
    dvc.titleName = model.name;
    [self.navigationController pushViewController:dvc animated:YES];
    if(_UIViewArray.count>0)
    {
        for (UIView *view in _UIViewArray)
        {
            view.frame = CGRectMake(view.frame.origin.x, ScreenHeight, view.frame.size.width, view.frame.size.height);
        }
    }
    [self.DetailTableView addGestureRecognizer:_singleTap];
}
#pragma mark - 一级标题点击事件-二级标题
- (void)buttonTitleSecond:(UIButton *)button
{
    NSInteger index = button.tag - 130;
    
    if(_indexButton != index)
    {
        _isClick = YES;
    }
    UIView *secondView = (UIView *)[self.view viewWithTag:140+index];
    if(_isClick)
    {
        if(_UIViewArray.count>0)
        {
            for (UIView *view in _UIViewArray)
            {
                view.frame = CGRectMake(view.frame.origin.x, ScreenHeight, view.frame.size.width, view.frame.size.height);
            }
        }
        [UIView animateWithDuration:0.3 animations:^{
            if(_firstArray.count==1)
            {
                secondView.frame = CGRectMake((ScreenWidth-widthBtn/2)/2,  ScreenHeight-53-31*_arrayCount, widthBtn/2, 31*_arrayCount+9);
            }
            else
            {
                secondView.frame = CGRectMake(widthBtn*index, ScreenHeight-53-31*_arrayCount, widthBtn, 31*_arrayCount+9);
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            if(_firstArray.count==1)
            {
                secondView.frame = CGRectMake((ScreenWidth-widthBtn/2)/2,  ScreenHeight, widthBtn/2, 31*_arrayCount+9);
            }
            else
            {
                secondView.frame = CGRectMake(widthBtn*index, ScreenHeight, widthBtn, 31*_arrayCount+9);
            }
        }];
    }
    _isClick = !_isClick;
    _indexButton = index;
    [self.DetailTableView addGestureRecognizer:_singleTap];
}
#pragma mark - 设置二级分类标题UI
- (void)createSecondTitleUIViewWith:(NSArray *)array index:(NSInteger)index
{
    if(array.count>0)
    {
        for (NSDictionary *dict in array)
        {
            MenuListModel *model = [[MenuListModel alloc]init];
            model.childMenuList = [dict objectForKey:@"sub_button"];
            model.name = [dict objectForKey:@"name"];
            model.url = [dict objectForKey:@"url"];
            model.type = [dict objectForKey:@"type"];
            [_secondArray addObject:model];
        }
        UIView *secondView = [[UIView alloc]init];
        if(_firstArray.count==1)
        {
            secondView.frame = CGRectMake((ScreenWidth-widthBtn/2)/2, ScreenHeight, widthBtn/2, 31*array.count+9);
        }
        else
        {
            secondView.frame = CGRectMake(widthBtn*index, ScreenHeight, widthBtn, 31*array.count+9);
        }
        secondView.backgroundColor = [UIColor clearColor];
        secondView.tag = 140+index;
        [self.view addSubview:secondView];
        [_UIViewArray addObject:secondView];
        
        UIView *topSecondView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, secondView.frame.size.width-20, secondView.frame.size.height-13)];
        topSecondView.backgroundColor = [UIColor lightGrayColor];
        topSecondView.layer.borderColor = [UIColor colorWithRed:163/255.0 green:163 /255.0 blue:163/255.0 alpha:1].CGColor;
        topSecondView.layer.borderWidth = 1.0;
        topSecondView.layer.masksToBounds = YES;
        topSecondView.layer.cornerRadius = 5;
        [secondView addSubview:topSecondView];
        
        UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake((secondView.frame.size.width-20)/2, secondView.frame.size.height-20, 20, 20)];
        downImage.image = [UIImage imageNamed:@"downImage"];
        [secondView addSubview:downImage];
        
        for(int i=0;i<_secondArray.count;i++)
        {
            MenuListModel *model = [_secondArray objectAtIndex:i];
            UIButton *secondTitle = [[UIButton alloc]init];
            if(_firstArray.count==1)
            {
                secondTitle.frame = CGRectMake(0, 30*i, widthBtn/2-20, 29);
            }
            else
            {
                secondTitle.frame = CGRectMake(0, 30*i, widthBtn-20, 29);
            }
            [secondTitle setTitleColor:[UIColor colorWithRed:163/255.0 green:163 /255.0 blue:163/255.0 alpha:1] forState:UIControlStateNormal];
            secondTitle.backgroundColor = [UIColor whiteColor];
            [secondTitle setTitle:model.name forState:UIControlStateNormal];
            [topSecondView addSubview:secondTitle];
            secondTitle.titleLabel.font = [UIFont systemFontOfSize:16];
            [secondTitle addTarget:self action:@selector(secondTitleClick:) forControlEvents:UIControlEventTouchUpInside];
            secondTitle.tag = 150+i;
        }
    }
}
#pragma mark - 二级小标题点击事件
- (void)secondTitleClick:(UIButton *)button
{
    NSInteger index = button.tag - 150;
    MenuListModel *model = [_secondArray objectAtIndex:index];
    DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@&longitude=%@&latitude=%@",model.url,[PersonInfo sharePersonInfo].accountIDString,self.longitude,self.latitude];
    dvc.urlStr = urlStr;
    dvc.titleName = model.name;
    [self.navigationController pushViewController:dvc animated:YES];
    if(_UIViewArray.count>0)
    {
        for (UIView *view in _UIViewArray)
        {
            view.frame = CGRectMake(view.frame.origin.x, ScreenHeight, view.frame.size.width, view.frame.size.height);
        }
    }
}
#pragma mark - 获取服务频道内容
- (void)getServerChannel:(NSString *)startPage pageCount:(NSString *)pageCount serverChannelID:(NSString *)serverChannelID
{
    [self refreshWithStatus:YES];
    [Request1617 getServiceContent:startPage pageCount:pageCount serverID:serverChannelID completed:^(NSString *errorCode, NSDictionary *resultDict) {
        [self refreshWithStatus:NO];
        [self endRefresh];
        if([errorCode isEqualToString:@"0"])
        {
            NSArray *recordsArr = [resultDict objectForKey:@"list"];
            for (NSDictionary *dict in recordsArr)
            {
                RecordsModel *model = [[RecordsModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                NSMutableArray *array = [[NSMutableArray alloc]init];
                [array addObject:model];
                [_dataArray addObject:array];
            }
            if(_dataArray.count>0)
            {
                [self.DetailTableView reloadData];
            }
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
    }];
}
#pragma mark-设置分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}
#pragma mark-设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
#pragma mark-创建tableView的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageType = nil;
    NSInteger count;
    RecordsModel *model = nil;
    if(_dataArray.count>0)
    {
        model = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        messageType = model.msgtype;
        NSArray *articles = [model.news objectForKey:@"articles"];
        count = articles.count;
        
    }
    else
    {
        messageType = @"11";
        count = 1;
    }
    if([messageType isEqualToString:@"text"])//文本
    {
        NSDictionary *text = model.text;
        CGRect rect = [self dynamicHeight:[text objectForKey:@"content"] fontSize:14 widthSize:300];
        if(rect.size.height>34)
        {
            return rect.size.height+16;
        }
        return 50;
    }
    else if([messageType isEqualToString:@"image"])//图片
    {
        return 190;
    }
    else if([messageType isEqualToString:@"news"])//图文
    {
        return 60*count;
    }
    else if([messageType isEqualToString:@"video"])//视频
    {
        return 190;
    }
    else if([messageType isEqualToString:@"voice"])//语音
    {
        return 65;
    }
    else
    {
        return 65;
    }
    //1.文本 2.视频 3.图片 4. 图文

}
#pragma mark-创建tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageType = nil;
    RecordsModel *model = nil;
    if(_dataArray.count>0)
    {
        model = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        messageType = model.msgtype;
    }
    else
    {
        messageType = @"11";
    }
    if([messageType isEqualToString:@"text"])//1:文本
    {
        DetailSerViceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSerViceOne"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailSerViceCell" owner:self options:nil]objectAtIndex:0];
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 2.0;
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(model!=nil)
        {
            [cell ShowUIViewWithModel:model];
        }
        return cell;
    }
    else if([messageType isEqualToString:@"image"])//图片
    {
        DetailSerViceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSerViceTwo"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailSerViceCell" owner:self options:nil]objectAtIndex:1];
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 2.0;
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(model!=nil)
        {
            [cell ShowUIViewWithModel:model];
        }
        return cell;
    }
    else if([messageType isEqualToString:@"news"])//3:图文
    {
        DetailSerViceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSerViceThree"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailSerViceCell" owner:self options:nil]objectAtIndex:2];
            cell.delegate = self;
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 2.0;
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;
            cell.SerViceThreeLabel.hidden = YES;
            cell.SerViceThreeImageView.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(model!=nil)
        {
            [cell ShowUIViewWithModel:model];
        }
        return cell;
    }
    else if([messageType isEqualToString:@"video"])//4:视频
    {
        DetailSerViceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSerViceFour"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailSerViceCell" owner:self options:nil]objectAtIndex:3];
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 2.0;
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(model!=nil)
        {
            [cell ShowUIViewWithModel:model];
        }
        return cell;
    }
    else if([messageType isEqualToString:@"voice"])//5:语音
    {
        DetailSerViceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSerViceFive"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailSerViceCell" owner:self options:nil]objectAtIndex:4];
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 2.0;
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(model!=nil)
        {
            [cell ShowUIViewWithModel:model];
        }
        return cell;
    }
    else
    {
        DetailSerViceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSerViceSix"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DetailSerViceCell" owner:self options:nil]objectAtIndex:5];
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 2.0;
            cell.layer.masksToBounds = YES;
            cell.layer.cornerRadius = 5;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(model!=nil)
        {
            [cell ShowUIViewWithModel:model];
        }
        return cell;
    }
    //1.文本 2.视频 3.图片 4. 图文
}
#pragma mark-选中tableView的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *messageType = nil;
    RecordsModel *model = nil;
    if(_dataArray.count>0)
    {
        model = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        messageType = model.msgtype;
    }
    else
    {
        messageType = @"11";
    }
    //图片
    if([messageType isEqualToString:@"image"])
    {
        ShowBigImageViewController *svc = [[ShowBigImageViewController alloc]init];
        svc.title = self.title;
        svc.media_url = [model.image objectForKey:@"media_url"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    //视频消息
    else if ([messageType isEqualToString:@"video"])
    {
        ShowVideoViewController *svc = [[ShowVideoViewController alloc]init];
        svc.title = self.title;
        svc.videoUrl = [model.media_url objectForKey:@"media_url"];
        [self.navigationController pushViewController:svc animated:YES];
    }
    //文本消息
    else if ([messageType isEqualToString:@"text"])
    {
    }
    //音频消息
    else if ([messageType isEqualToString:@"voice"])
    {
        Alert(@"暂未开放!");
    }

    DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
    //dvc.urlStr = model.url;
    dvc.titleName = self.title;
    [self.navigationController pushViewController:dvc animated:YES];
}
//图文点击事件
- (void)oneNewsCellClick:(NSString *)title url:(NSString *)url
{
    if(url.length>0)
    {
        DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
        dvc.urlStr = url;
        dvc.titleName = title;
        [self.navigationController pushViewController:dvc animated:YES];
    }
}

-(CGRect)dynamicHeight:(NSString *)str fontSize:(NSInteger)fontSize widthSize:(NSInteger)widthSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(widthSize, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_UIViewArray.count>0)
    {
        for (UIView *view in _UIViewArray)
        {
            view.frame = CGRectMake(view.frame.origin.x, ScreenHeight, view.frame.size.width, view.frame.size.height);
        }
        _isClick = YES;
    }
}
- (void)buttonpress:(UITapGestureRecognizer*)singleTap
{
    if(_UIViewArray.count>0)
    {
        for (UIView *view in _UIViewArray)
        {
            view.frame = CGRectMake(view.frame.origin.x, ScreenHeight, view.frame.size.width, view.frame.size.height);
        }
        _isClick = YES;
    }
    [self.DetailTableView removeGestureRecognizer:_singleTap];
}

#pragma mark - 刷新控件
- (void)refreshData
{
    [self.DetailTableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.DetailTableView addFooterWithTarget:self action:@selector(footerRefresh)];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    _startPage = 1;
    [_dataArray removeAllObjects];
    [self getServerChannel:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount] serverChannelID:self.serverChannelID];
}
#pragma mark - 上拉加载
- (void)footerRefresh
{
    _startPage ++;
    if (_dataArray.count < 10)
    {
        [self endRefresh];
        return;
    }
    [self getServerChannel:[NSString stringWithFormat:@"%ld",_startPage] pageCount:[NSString stringWithFormat:@"%ld",_pageCount] serverChannelID:self.serverChannelID];
}
#pragma mark - 头部尾部停止刷新
- (void)endRefresh
{
    [self.DetailTableView  headerEndRefreshing];
    [self.DetailTableView footerEndRefreshing];
}
- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //[self.DetailTableView headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    _isClick = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
