//
//  ChatInfoViewController.m
//  HiChat
//
//  Copyright (c) 2015年 why. All rights reserved.
//

#import "ChatInfoViewController.h"
@interface ChatInfoViewController ()
{
    NSUInteger _nums;///推送次数
    NSInteger _refreshCount;//刷新的次数
    NSMutableArray * _dbArray;//从数据库中读取的数据
    NSInteger _benginCount ;//开始
    NSInteger _endCount;//结束
    BOOL _isDB;//是否是从数据库中读取
    BOOL _isSendMessageToYourself;//是否是给自己发消息
}
@property(nonatomic,assign)BOOL isWeMeFriendRedirect;//是否是微密好友列表跳转过来
@end

@implementation ChatInfoViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([_user.accountID isEqualToString:[PersonInfo sharePersonInfo].accountIDString])
    {
        _isSendMessageToYourself = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    _isSendMessageToYourself = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _dbArray = [[NSMutableArray alloc]init];
    self.title = [NSString stringWithFormat:@"%@",self.user.accountNickName.length==0?@"无昵称":self.user.accountNickName];
    _chatArray = [[NSMutableArray alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasMoreMessages:) name:PushMassageObserver object:nil];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self searchDataBaseWithRefreshCount:_refreshCount];
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    if (!self.isWeMeFriendRedirect) {
        if (![self checkHadInserted:self.user]) {
            [self reloadTableWithInfo:self.user isMyself:NO];
        }
    }

}
- (void)searchDataBaseWithRefreshCount:(NSInteger)refCount
{
    DBOperation * db = [[DBOperation alloc]init];
    if (db)
    {
        NSInteger count = [db countOfTable:[NSString stringWithFormat:@"A%@",_user.accountID]];
        
        if (count>8)
        {//[NSString stringWithFormat:@"A%@",_user.accountID]
            _dbArray = [db getDataArrFromDbWithbeginAccount:count-7 endAccount:count withTableName:[NSString stringWithFormat:@"A%@",_user.accountID]];
            [self getUIWithArray:_dbArray];
            _endCount = count-8;
        }
        else
        {
            _dbArray = [db getDataArrFromDbWithbeginAccount:1 endAccount:count withTableName:[NSString stringWithFormat:@"A%@",_user.accountID]];
            [self getUIWithArray:_dbArray];
            _endCount = 0;
        }
    }
}
- (void)getUIWithArray:(NSMutableArray *)array
{
    for (chatDBModel * model in array)
    {
        BOOL flag = [model.remarks isEqualToString:@"1"]?YES:NO;
        [self reloadTableWithInfo:model isMyself:flag];
    }
}
- (void)headerRefresh
{
    _isDB = YES;
    DBOperation * db = [[DBOperation alloc]init];
    if (db)
    {
        if (_endCount == 0)
        {
            [_tableView headerEndRefreshing];
            return;
        }
        if (_endCount<8&&_endCount!=0)
        {
            if (_dbArray.count>0)
            {
                [_dbArray removeAllObjects];
                //[_chatArray removeAllObjects];
                _dbArray = [db getDataArrFromDbWithbeginAccount:1 endAccount:[db countOfTable:_user.accountID] withTableName:_user.accountID];
                [self getUIWithArray:_dbArray];
            }
            
            _endCount = 0;
        }
        else
        {
            NSInteger count = [db countOfTable:[NSString stringWithFormat:@"A%@",_user.accountID]]-8-_refreshCount*8;
            if (_dbArray.count>0)
            {
                //[_chatArray removeAllObjects];
                [_dbArray removeAllObjects];
            }
            _dbArray = [db getDataArrFromDbWithbeginAccount:_endCount-7 endAccount:[db countOfTable:_user.accountID] withTableName:_user.accountID];
            [self getUIWithArray:_dbArray];
            _endCount = count-8;
            _refreshCount++;
        }
        [_tableView headerEndRefreshing];
    }
}

#pragma mark --推送消息--
-(void)hasMoreMessages:(NSNotification *)notification
{
    NSLog(@"chatinfoview  接收到聊天推送了  /n  %@",notification);
    NSDictionary *userInfo = notification.userInfo;
    NSData *jsonData = [[userInfo objectForKey:@"content"] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    NSString * messageId = [dic objectForKey:@"id"];
    [self markReadingMessage:messageId];
    NSData *jsonDatas = [[dic objectForKey:@"param"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *errs;
    NSDictionary *dics = [NSJSONSerialization JSONObjectWithData:jsonDatas
                                                         options:NSJSONReadingMutableContainers
                                                           error:&errs];
    
    //NSLog(@"+++ %@",dics);
    _nums++;
    chatDBModel * model = [chatDBModel getModelWithDic:dics];
    model.pushTime = [self getTimewith:[dics objectForKey:@"pushTime"]];
    model.remarks = @"2";
    [self reloadTableWithInfo:model isMyself:NO];
    ///存入数据库
    [self saveInDBWithModel:model];
}
#pragma mark - 标记已读消息
- (void) markReadingMessage:(NSString *)messageID{
    
    [RequestEngine markReadMessage:@{
                                     @"messageID":messageID
                                     }
                         completed:^(NSString *errorCode, NSDictionary *resultDic) {
                             if ([errorCode isEqualToString:@"0"]) {
                                 NSLog(@"%@小消息已读",messageID);
                             }
                         }];
    
}
- (NSString *)getTimewith:(NSString *)time {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *startTime = [dateFormatter stringFromDate:startDate];
    return startTime;
    
}
#pragma mark --存入数据库--
- (void)saveInDBWithModel:(chatDBModel *)dbModel
{
    DBOperation * db = [[DBOperation alloc]init];
    BOOL ret = [db createChatStrTable:[NSString stringWithFormat:@"A%@",dbModel.accountID]];
    if (ret)
    {//[NSString stringWithFormat:@"A%@",dbModel.accountID]
        if([db addOneDataBaseWithModel:dbModel withTableName:[NSString stringWithFormat:@"A%@",dbModel.accountID]])//插入数据
        {
            NSLog(@"插入数据成功!");
        }
    }
}

/**
 *  检查是否已经插入数据
 *
 *  @param dbModel <#dbModel description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)checkHadInserted:(chatDBModel*)dbModel{
    DBOperation * db = [[DBOperation alloc]init];
    BOOL ret = [db createChatStrTable:[NSString stringWithFormat:@"A%@",dbModel.accountID]];
    if (ret){
        return ![db addOneDataBaseWithModel:dbModel withTableName:[NSString stringWithFormat:@"A%@",dbModel.accountID]];
    }else{
        return NO;
    }

    return YES;
}
-(void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    _textView.frame = CGRectMake(0, ScreenHeight - kbSize.height - 44, ScreenWidth, 44);
    
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-kbSize.height-44);
    [UIView commitAnimations];
}
-(void)keyboardDidShow:(NSNotification*)notif
{
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-kbSize.height-44);
    [UIView commitAnimations];
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:7];
    _textView.frame = CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44);
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 44);
    [UIView commitAnimations];
}
-(void)createTextView
{
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    _textView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_textView];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    imageView.image = [UIImage imageNamed:@"chatinputbg.png"];
    [_textView addSubview:imageView];
    
    
    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, (220.0/320.0)*ScreenWidth, 30)];
    _textFiled.borderStyle = UITextBorderStyleRoundedRect;
    _textFiled.delegate = self;
    [_textView addSubview:_textFiled];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(20+(220.0/320.0)*ScreenWidth, 7, (70.0/320.0)*ScreenWidth, 30);
    [btn setTitle:@"私信" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:btn];
}
-(void)keyDown
{
    NSLog(@"keyDown");
    [UIView animateWithDuration:0.35 animations:^{
        _textView.frame = CGRectMake(0, ScreenHeight-44, ScreenWidth, 44);
        _tableView.frame =CGRectMake(0, 20, ScreenWidth, ScreenHeight-20) ;
    } completion:nil];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark --发送按钮--
-(void)sendMessageClick:(UIButton *)button
{
    NSLog(@"点击发送按钮");
    if ([_textFiled.text isEqualToString:@""])
    {
        Alert(@"主人,发送的内容不能为空呀");
        return;
    }
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString * dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString * chatInfo = [NSString stringWithFormat:@"%@",dateString];
    NSString * gender = _user.gender.length==0?@"1":_user.gender;
    NSString * senderHeaderUrl = ([PersonInfo sharePersonInfo].senderUserHeadName.length>0)?[PersonInfo sharePersonInfo].senderUserHeadName: @"";
    NSString * accountNickName = (_user.accountNickName.length>0)?_user.accountNickName:@"";
    NSString * sendNickName = ([PersonInfo sharePersonInfo].nicknameString.length>0)?[PersonInfo sharePersonInfo].nicknameString: @"";
    NSString * accountId = ([PersonInfo sharePersonInfo].accountIDString.length>0)?[PersonInfo sharePersonInfo].accountIDString: @"";
    NSString * userAccountId = (_user.accountID.length>0)?_user.accountID:@"";
    NSDictionary * dic = @{@"accountID":accountId,@"friendAccountID":userAccountId,@"friendNickName":accountNickName,@"msgContent":_textFiled.text,@"accountNickName":sendNickName,@"gender":gender,@"senderUserHeadName":senderHeaderUrl};
    [self refreshWithStatus:YES];
    
    
    [RequestEngine talkPushMessageWithDic:dic completed:^(NSString *errorCode) {
        [self refreshWithStatus:NO];
        if ([errorCode isEqualToString:@"0"])
        {
            chatDBModel * model = [[chatDBModel alloc]init];
            model.accountID = _user.accountID;
            model.pushTime = chatInfo;
            model.talkContent = _textFiled.text;
            model.remarks = @"1";
            if (!_isSendMessageToYourself)
            {
                [self saveInDBWithModel:model];
                [self reloadTableWithInfo:model isMyself:YES];
            }
        }
        else
        {
            Alert(@"主人,这条消息没有发送成功哟，再试试吧");
        }
    }];///////////////////
}
- (void)reloadTableWithInfo:(chatDBModel *)model isMyself:(BOOL)flag
{
    UIView *bubble = [self createBubbleWithString:model flag:flag];
    [_chatArray addObject:bubble];
    // NSLog(@"数量  %lu",(unsigned long)_chatArray.count);
    [_tableView reloadData];
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//滚到末端
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.chatArray.count - 1) inSection:0];
    if (!_isDB)
    {
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    _textFiled.text = nil;
}
- (UIView *)createBubbleWithString:(chatDBModel *)model flag:(BOOL)flag
{
    NSString * str = [NSString stringWithFormat:@"在 %@      说     %@",model.talkContent,model.talkContent];
    CGSize size = STRING_SIZE(190, str);
    UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(flag?(ScreenWidth-200):0, 0, 200, size.height + 20)];
    bubbleView.tag = 1;
    //NSLog(@" 头像  %@",[PersonInfo sharePersonInfo].senderUserHeadName);
    NSString *image_url = flag ? [PersonInfo sharePersonInfo].senderUserHeadName: _user.senderUserHeadName;
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(flag?160:0, (size.height-5.0)/2.0, 40, 40)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    headImageView.backgroundColor = [UIColor orangeColor];
    headImageView.layer.cornerRadius = 20;
    headImageView.clipsToBounds = YES;
    //////昵称
    UILabel *nickLable = [[UILabel alloc] initWithFrame:CGRectMake(flag?60:55, 0, 80, 20)];
    nickLable.textAlignment = flag?NSTextAlignmentRight:NSTextAlignmentLeft;
    nickLable.text = flag?[PersonInfo sharePersonInfo].nicknameString:_user.accountNickName==nil?@"微密":_user.accountNickName;
    nickLable.font = [UIFont systemFontOfSize:13];
    //nickLable.backgroundColor = [UIColor orangeColor];
    
    
    ////时间
    CGSize timeSize=[Tool sizeWithText:model.pushTime font:[UIFont systemFontOfSize:10] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UILabel * timelabel = [[UILabel alloc] initWithFrame:CGRectMake(flag?20:85, 0, timeSize.width, 20)];
    timelabel.text = model.pushTime;
    timelabel.textAlignment = flag?NSTextAlignmentLeft:NSTextAlignmentRight;
    timelabel.font = [UIFont systemFontOfSize:10];
    //timelabel.backgroundColor = [UIColor redColor];
    timelabel.numberOfLines = 0;
    
    ///////说的话
    UILabel * talklabel = [[UILabel alloc] initWithFrame:CGRectMake(flag?38:40, 8, 116, size.height-5)];
    talklabel.text = model.talkContent;
    talklabel.font = [UIFont systemFontOfSize:12];
    talklabel.numberOfLines = 0;
    //talklabel.backgroundColor = [UIColor redColor];
    
    UIImage *oldImage = flag?[UIImage imageNamed:@"duihua2"]:[UIImage imageNamed:@"duihua1"];
    UIImage *newImage = [oldImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(flag?-10:15, 13, 180, size.height + 10)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    imageView.image = newImage;
    //imageView.backgroundColor = [UIColor blackColor];
    // NSLog(@"___- %f",size.height);
    
    
    [bubbleView addSubview:imageView];
    
    
    
    [bubbleView addSubview:nickLable];
    [bubbleView addSubview:timelabel];
    
    [bubbleView addSubview:headImageView];
    [imageView addSubview:talklabel];
    
    return bubbleView;
    //bubbleView.backgroundColor = [UIColor grayColor];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *view = [cell viewWithTag:1];
    [view removeFromSuperview];
    view = [self.chatArray objectAtIndex:indexPath.row];
    [cell addSubview:view];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [self.chatArray objectAtIndex:indexPath.row];
    return view.frame.size.height + 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end