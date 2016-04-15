//
//  ChatFamilyViewController.m
//  微密
//
//  Created by iOS Dev on 14-8-18.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "ChatFamilyViewController.h"
#import "ChatCell.h"
#import "ChatModel.h"
#import "NSString+Time.h"
#import "VolumeImageView.h"
#import "MJRefresh.h"
#import "VoiceConverter.h"
#import "MobClick.h"
#import "NewLoginViewController.h"

#define kChatCell @"ChatCell"


@interface ChatFamilyViewController ()
{
    ChatModel *_chatModel;
    
    NSString *_filePath;
    NSString *_wavFilePath;
    NSString *_armFilePath;
    NSString *_phoneOrImeiString;
    
    NSMutableArray *_dataArray;
    VolumeImageView *_volumeimageView;
    
    
    NSTimer  *_myTimer;
    NSTimer  *_volumeTimer;
    
    SUserDB *_userDB;
    
    
    NSString *_loactionNicknameString;
    
    NSString *_accountID;
    
    int _iTimeLength;
    NSUInteger _currentPage;
}

@property(strong ,nonatomic)SUserDB *userDB;


@end

@implementation ChatFamilyViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _userDB = [[SUserDB alloc]init];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        //张福杰
    }
    return self;
}


#pragma mark -- 视图将要加载

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:@"家人连线"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"家人连线"];
   
    _currentPage = 5;
    
    if (_userDB == nil)
    {
        _userDB = [[SUserDB alloc]init];
    }
    
    [_userDB createDataBase];
    
    NSString *accountID = [[NSUserDefaults standardUserDefaults] objectForKey:kFamilyPhoneOrIMEI];
    
    _recvIDString = [[NSUserDefaults standardUserDefaults]objectForKey:kFamilyRecAcID];
    
    [FamilyInfo shareFamilyInfo].accountID = _recvIDString;
    
    NSString *titleString = [[NSUserDefaults standardUserDefaults] objectForKey:kFamilyRecNickname];
    
    if (titleString == nil)
    {
        titleString = @"聊天";
    }
    
    self.title = titleString;
    
    if ([accountID length] == 15)
    {
        [FamilyInfo shareFamilyInfo].parameterType = 3;
    }
    [FamilyInfo shareFamilyInfo].receiceID = accountID;
}

#pragma mark -- 视图加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     _chatModel = [[ChatModel alloc]init];

    //设置导航栏
    [self setRightNav];
    
    //布局
    [self uiConfig];
    
    //初始化录音
    [self initRecording];
    
    //初始化数据;
    [self initData];
    
    //添加下拉刷新
    [self.tableView registerClass:[ChatCell class] forCellReuseIdentifier:kChatCell];
    [self setupRefresh];

    //接收推送
    NSNotificationCenter *ncCenter = [NSNotificationCenter defaultCenter];
    [ncCenter addObserver:self selector:@selector(jPushMassage:) name:PushMassageObserver object:nil];
    
    //判断推送状态
    [self judgeIsConnection];
    
    //获取一次网络信息
    [self netWorkRequest];
    
    //取消连线
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:@"NOTIFICATION_CLOSE_JIAREN" object:nil];
}
#pragma mark - 返回到上一个页面 取消家人连线
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^(){
        //关掉注册controller
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CLOSE_JIAREN" object:nil userInfo:nil];
    }];
}
#pragma mark - 初始化数据
- (void)initData
{
    _loactionNicknameString = [[NSUserDefaults standardUserDefaults]objectForKey:kPhoneNickname];
    
    _phoneOrImeiString = [[NSUserDefaults standardUserDefaults] objectForKey:kFamilyPhoneOrIMEI];
    
    _appStation = [[NSUserDefaults standardUserDefaults]objectForKey:kAppStation];
}

#pragma mark --判断连线状态

- (void)judgeIsConnection
{
    if (_appStation == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,当前你还没有建立连线,快去连线吧" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
    }else if([_appStation isEqualToString:@"0"])
    {
        _recvIDString = [[NSUserDefaults standardUserDefaults]objectForKey:kFamilyRecAcID];

        [_chatModel validationConnection:_recvIDString phoneImei:[FamilyInfo shareFamilyInfo].uuidString isConnection:^(BOOL isConnection)
        {
            if (!isConnection)
            {
                [self againConnection];
            }
            
        }];
    }
}
#pragma mark - 家人连线失败
- (void)againConnection
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"主人,当前你连接已经失效,快去重新连线吧" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    [alertView show];
}

#pragma mark -- 添加头部刷新
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView headerBeginRefreshing];
}

- (void)headerRereshing
{
    if (_dataArray == nil)
    {
        _dataArray = [[NSMutableArray alloc]initWithArray:[_userDB findWithlimit:(int)_currentPage]];
    }
    else
    {
        _currentPage = [_dataArray count] + 5;
        
        NSArray *array = [[NSArray alloc]initWithArray:[_userDB findWithlimit:(int)_currentPage]];
        
        [_dataArray removeAllObjects];
        
        NSUInteger aCount = [array count];
        
        for (int i = 0; i < aCount; i++)
        {
            [_dataArray addObject:[array objectAtIndex:i]];
        }
    }
    [self.tableView reloadData];
    [self.tableView headerEndRefreshing];
}
#pragma mark -- 接收到消息

- (void)jPushMassage:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    if ([[dict objectForKey:@"title"]isEqualToString:@"receiveMessage_online"])
    {
        NSString *jPushMassageString = [dict objectForKey:@"content"];
        
        NSData *data = [jPushMassageString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jPushDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        [FamilyInfo shareFamilyInfo].receiveNicknameString = [[jPushDict objectForKey:@"msgContent"] objectForKey:@"nickname"];
        
        [FamilyInfo shareFamilyInfo].accountID = [[jPushDict objectForKey:@"msgContent"] objectForKey:@"senderAccountID"];
        
        [self netWorkRequest];
        
    }
}

#pragma mark -- 网络请求

- (void)netWorkRequest
{
    if (_chatModel == nil)
    {
        _chatModel = [[ChatModel alloc]init];
    }
    
    [_chatModel getChatMessage:^(NSMutableArray *array)
     {
         if ([array count] == 0){
             ////////张福杰
         }
         else
         {
             NSUInteger aCount = [array count];
             
             for (int i = 0; i < aCount; i++)
             {
                 [_dataArray addObject:[array objectAtIndex:i]];
             }
             [self.tableView reloadData];
             [self currentOffset];
         }
     }];

}
#pragma mark -- 设置导航栏
- (void)setRightNav
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 38);
    [rightBtn setTitle:@"重连" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(gotoApplyConnection) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 38);
    [leftBtn setTitle:@"登录" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLogInView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}
#pragma mark - 返回登陆页
- (void)backLogInView
{
    if(self.backType==nil)
    {
        NewLoginViewController *lvc = [[NewLoginViewController alloc] init];
        lvc.isJiaRenLine = @"YES";
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:lvc];
        [self presentViewController:nvc animated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- 布局
-  (void)uiConfig
{
    self.title = @"家人聊天";
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.view.bounds = rect;
    
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    self.recordingButton.frame = CGRectMake(40, self.view.bounds.size.height - 45, 240, 40);
    
    [self.recordingButton setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.recordingButton setBackgroundImage:[UIImage imageNamed:@"buttonone_normal"] forState:UIControlStateNormal];
    [self.recordingButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"] forState:UIControlStateHighlighted];
    self.recordingButton.delegate = self;
}

#pragma mark -- 录音初始化

- (void)initRecording
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
    {
        //NSLog(@"Error creating session: %@", [sessionError description]);
    }
    else
    {
        [session setActive:YES error:nil];
    }
}

#pragma mark -- tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    static NSString *cellID = @"cellID";
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChatCell" owner:self options:nil]lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ChatInfo *rowInfo = [_dataArray objectAtIndex:row];
    
    int messageType = [rowInfo.iMessageType intValue];
    
    cell.uid = rowInfo.uid;
    
    NSURL *pathURL = [NSURL URLWithString:rowInfo.mediaUrl];
    
    cell.pathUrl = pathURL;
    cell.netWorkUrl = rowInfo.networkUrl;
    
    if (messageType == 1)
    {
        cell.leftView.hidden = NO;
        
        cell.rightView.hidden = YES;
        cell.leftTime.text = [NSString stringWithFormat:@"%@\"",rowInfo.mediaTimeLength];
        cell.leftnickNameLable.text = rowInfo.receiveNickname;
        cell.leftnickNameLable.textColor = kLevelThreeColor;
        cell.leftnickNameLable.font = kLevelThreeFont;
    }
    else
    {
        cell.leftView.hidden = YES;
        cell.rightView.hidden = NO;
        cell.rightTime.text = [NSString stringWithFormat:@"%@\"",rowInfo.mediaTimeLength];
        
        [cell.rightVoiceButton setImage:[UIImage imageNamed:@"right_voice3.png"] forState:UIControlStateNormal];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

#pragma mark -- 录音开始
- (void)addVolumImageView
{
    if (_volumeimageView == nil)
    {
        _volumeimageView = [[VolumeImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * 0.5 - 90,self.view.bounds.size.height - 300, 180, 180)];
    }
    _volumeimageView.backgroundColor = [UIColor grayColor];
    _volumeimageView.layer.cornerRadius = 6;
    [self.view addSubview:_volumeimageView];
}

#pragma mark -- 开始录音
- (void)touchBegin
{
    [self.recordingButton setTitle:@"松开发送" forState:UIControlStateNormal];
     [self.recordingButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"] forState:UIControlStateNormal];
    
    //添加volume
    [self addVolumImageView];
    
    NSString *date = [NSString currentDetailDate];
    
    _filePath = [NSString stringWithFormat:@"/tmp/%@.%@",date,@"wav"];
    
    _armFilePath = [NSString stringWithFormat:@"%@/tmp/%@.%@",NSHomeDirectory(),date,@"amr"];
    
    _wavFilePath = [NSString stringWithFormat:@"%@/tmp/%@.%@",NSHomeDirectory(),date,@"wav"];
    
    recordedFile = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:_filePath]];
    
    NSDictionary *setting = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey, [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey, [NSNumber numberWithInt: 1], AVNumberOfChannelsKey, [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey, [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,nil];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:setting error:nil];
    
    recorder.meteringEnabled = YES;
    
    [recorder prepareToRecord];
    [recorder record];
    
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer) userInfo:nil repeats:YES];
    
    _iTimeLength = 10;
    
    _volumeTimer  = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(volumeTimer) userInfo:nil repeats:YES];
}

#pragma mark -- 录音动画
- (void)recorderVoulme
{
    [recorder updateMeters];
    
    double lowPassResults = pow(10, ((0.05 * [recorder peakPowerForChannel:0])));
    
    if (0 < lowPassResults <= 0.06)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback003.png";
    }else if (0.06<lowPassResults<=0.13)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback004.png";
    }else if (0.13<lowPassResults<=0.20)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback005.png";
    }else if (0.20<lowPassResults<=0.27)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback006.png";
    }else if (0.27<lowPassResults<=0.34)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback007.png";
    }else if (0.34<lowPassResults<=0.41)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback008.png";
    }else if (0.41<lowPassResults<=0.48)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback009.png";
    }else if (0.34<lowPassResults<=0.41)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback010.png";
    }else if (0.41<lowPassResults<=0.48)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback011.png";
    }else if (0.48<lowPassResults<=0.55)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback012.png";
    }
    else if (0.55<lowPassResults<=0.62)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback013.png";
    }
    else if (0.62<lowPassResults<=0.69)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback014.png";
    }
    else if (0.69<lowPassResults<=0.76)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback015.png";
    }
    else if (0.76<lowPassResults<=0.83)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback016.png";
    }
    else if (0.83<lowPassResults<=0.9)
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback017.png";
    }
    else
    {
        _volumeimageView.volumeString = @"VoiceSearchFeedback017.png";
    }
}

- (void)volumeTimer
{
    [self recorderVoulme];
}

- (void)myTimer
{
    if (_iTimeLength == 0)
    {
        [self stopRecording];
    }
    _iTimeLength--;
}

#pragma mark - 停止录音
- (void)stopRecording
{
    [_volumeimageView removeFromSuperview];
    
    [_volumeTimer invalidate];
    [_myTimer invalidate];
    
    [self.recordingButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.recordingButton setBackgroundImage:[UIImage imageNamed:@"buttonone_normal"] forState:UIControlStateNormal];
    [recorder stop];
    recorder = nil;
}

#pragma mark -- 音频发送
- (void)sendAudio
{
    [self stopRecording];
    
    if (_chatModel == nil)
    {
        _chatModel = [[ChatModel alloc]init];
    }
    
    //保存语音文件
    [VoiceConverter wavToAmr:_wavFilePath amrSavePath:_armFilePath];
        
    [_chatModel upVoice:_armFilePath isChat:^(int isChat)
     {
         //0、发送成功  1、对方未设置+键功能 2、手机号不正确 3、未绑定IMEI 4、服务器错误 5、网络错误
     }];
    
    ChatInfo  *chatInfo = [[ChatInfo alloc]init];
    
    if (_loactionNicknameString == nil || [_loactionNicknameString isEqualToString:@""])
    {
        chatInfo.locationNickname = @"我";
    }
    else
    {
        chatInfo.locationNickname = _loactionNicknameString;
    }
    
    chatInfo.iMessageType = @"0";
    
    chatInfo.receiveAccount = _phoneOrImeiString;
    
    chatInfo.createTime = [NSString currentDetailDate];
    
    chatInfo.mediaUrl = [NSString stringWithFormat:@"%@",recordedFile];
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:recordedFile options:nil];
    
    CMTime audioDuration = asset.duration;
    int audioDurationSeconds = (int)CMTimeGetSeconds(audioDuration);
    
    chatInfo.mediaTimeLength = [NSString stringWithFormat:@"%d",audioDurationSeconds];
    
    if (audioDurationSeconds > 0)
    {
        [self saveDB:chatInfo];
    }
}
#pragma mark - 代理方法
- (void)touchEnd
{
    [self sendAudio];
}

#pragma mark -- 数据存储

- (void)saveDB:(ChatInfo *)chat
{
    [_userDB addUser:chat];
    
    [_dataArray addObject:chat];
    
    [self.tableView reloadData];
}

#pragma mark -- alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000)
    {
        if (buttonIndex == 1)
        {
            [self gotoApplyConnection];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else if (alertView.tag == 1001)
    {
        if (buttonIndex == 1)
        {
            [self gotoApplyConnection];
        }
    }
}

#pragma mark - 家人连线
- (void)gotoApplyConnection
{
    FamilyViewController *familyViewController = [[FamilyViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:familyViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 偏移量
- (void)currentOffset
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_dataArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}











@end
