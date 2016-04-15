//
//  FamilyViewController.m
//  微密
//
//  Created by iOS Dev on 14-8-11.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "FamilyViewController.h"
#import "ApplyFamilyModel.h"
#import "ChatFamilyViewController.h"
#import "ModelView.h"




@interface FamilyViewController ()
{
    ZBarReaderViewController *_reader;
    ApplyFamilyModel *_model;
    ChatFamilyViewController *_chatViewController;
    
    NSString *_familyStation;
}
@property (weak, nonatomic) IBOutlet UIButton *lianxianButton;

@end

@implementation FamilyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)leftClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CLOSE_JIAREN" object:nil userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)addNavBack
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 40);
    [leftBtn setImage:[UIImage imageNamed:@"BarItemBack"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, -10, 1, 10);
    [leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

#pragma mark -- 视图加载

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBack];
    [_applyButton setBackgroundImage:[UIImage imageNamed:@"buttonone_select"] forState:UIControlStateHighlighted];
    [_lianxianButton setBackgroundImage:[UIImage imageNamed:@"buttontwo_select"] forState:UIControlStateHighlighted];
    self.title = @"申请家人连线";
    
    self.phoneTextFeild.delegate = self;
    self.accountIDTextFeild.delegate = self;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _familyStation = [defaults objectForKey:kAppStation];
    
    if (_familyStation != nil)
    {
        if ([_familyStation isEqualToString:@"1"])
        {
            self.stationLabel.text = @"连接状态:等待对方确认";
            
            [self.applyButton setTitle:@"重新申请家人连线" forState:UIControlStateNormal];
        }
    }
    
    NSNotificationCenter *ncCenter = [NSNotificationCenter defaultCenter];
    
    [ncCenter addObserver:self selector:@selector(jPushMassage:) name:PushMassageObserver object:nil];
}

#pragma mark -- 收到确认

- (void)jPushMassage:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[userInfo objectForKey:@"title"] isEqualToString:@"startOnline_success"])
    {
        NSString *jPushMassageString = [userInfo objectForKey:@"content"];
        NSData *data = [jPushMassageString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jPushDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
       [FamilyInfo shareFamilyInfo].receiveNicknameString = [[jPushDict objectForKey:@"msgContent"] objectForKey:@"nickname"];
        
        NSString *recvAccountID = [[jPushDict objectForKey:@"msgContent"] objectForKey:@"senderAccountID"];

        [FamilyInfo shareFamilyInfo].accountID = recvAccountID;
        
        [defaults setObject:recvAccountID forKey:kFamilyRecAcID];
        
        [defaults setObject:@"1" forKey:kAppStation];
        
        [defaults synchronize];
        
        [self gotoChat:YES];
    }
    else if ([[userInfo objectForKey:@"title"] isEqualToString:@"startOnline_refuse"])
    {
        self.stationLabel.text = @"连接状态:对方拒绝";
        Alert(@"主人,对方拒绝了哦");
        
        [defaults setObject:nil forKey:kAppStation];
    }
    else if ([[userInfo objectForKey:@"title"] isEqualToString:@"startOnline_close"])
    {
        self.stationLabel.text = @"连接状态:对方已关机";
        Alert(@"主人,对方关机了,快点通知家人开机吧");
        
        [defaults setObject:nil forKey:kAppStation];
    }
    [defaults synchronize];
}

#pragma mark -- 去往家人连线

- (void)gotoChat:(BOOL)animated
{
    [self dismissViewControllerAnimated:animated completion:nil];
    return;

    ChatFamilyViewController *chat = [[ChatFamilyViewController alloc]init];
    
    [self.navigationController pushViewController:chat animated:animated];
}

#pragma mark -- 家人连线请求
- (void)applyFamilyConnection:(NSString *)accountID
{
    // 1、未设置+键功能  2、手机号不正确 3、帐号未绑定IMEI 4、服务器错误 5、网络错误
    
    int type = 2;
    
    if ([accountID length] == 15)
    {
        type = 3;
    }
    else if([accountID length] == 11)
    {
        type = 2;
    }
    else
    {
        Alert(@"主人,请输入合法的手机号或者IMEI号");
        return;
    }
    
    if (_model == nil)
    {
        _model = [[ApplyFamilyModel alloc]init];
    }
    _model = [[ApplyFamilyModel alloc]init];
    
    self.stationLabel.text = @"连接状态:正在建立连接……";
    
    [FamilyInfo shareFamilyInfo].locationNicknameString = self.phoneTextFeild.text;
    
    [_model applyFamilyConnection:accountID parameterType:type name:self.phoneTextFeild.text  applyFamil:^(int isApplySucceed)
     {
         self.applyButton.enabled = YES;
         
         switch (isApplySucceed)
         {
             case 0:
             {
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:self.phoneTextFeild.text forKey:kPhoneNickname];
                 [defaults setObject:@"1" forKey:kAppStation];
                 [defaults synchronize];
                 
                  self.stationLabel.text = @"连接状态:连接成功,等待对方确认";
             }
                 break;
             case 1:
             {
                 self.stationLabel.text = @"您申请连线的道客用户尚未将吐槽键关联到家人连线的功能上，对方需要在APP上的服务频道-家人连线-关联吐槽键，方可进行连线。";
                 //Alert(@"主人,对方未设置+键功能哟");
             }
                 break;
             case 2:
             {
                 self.stationLabel.text = @"连接状态:手机号不正确";
                 Alert(@"主人,请输入正确的手机号码");
             }
                 break;
             case 3:
             {
                 self.stationLabel.text = @"连接状态:对方帐号未绑定IMEI";
                 Alert(@"主人,对方未绑定IMEI哦");
             }
                 break;
             case 4:
             {
                 self.stationLabel.text = @"连接状态:服务器错误";
                 Alert(@"主人,网络不给力啊,请检查一下网络吧");
             }
                 break;
             case 5:
             {
                 self.stationLabel.text = @"连接状态:网络错误";
                 Alert(@"主人,网络好像不给力啊,检查一下网络吧");
             }
                 break;
             case 100:
             {
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark -- 申请家人连线

- (IBAction)applyFamilyButton:(id)sender
{
    if ([_accountIDTextFeild.text isEqualToString:@""]||[_phoneTextFeild.text isEqualToString:@""])
    {
        Alert(@"主人,你还没有把信息填写完整呢");
        return;
    }
    [self.view endEditing:YES];
    
    [self applyFamilyConnection:self.accountIDTextFeild.text];
}

#pragma mark -- 二维码扫描

- (IBAction)codeButtonClick:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton * btns = (UIButton*)sender;
    
    [btns setBackgroundImage:[UIImage imageNamed:@"buttontwo_select"] forState:UIControlStateHighlighted];
    
    _reader = [[ZBarReaderViewController alloc]init];
    _reader.readerDelegate = self;
    
    _reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    _reader.showsHelpOnFail = NO;
    
    _reader.showsZBarControls = NO;
    
    _reader.readerView.torchMode = NO;
    
    ZBarImageScanner *scanner = _reader.scanner;
    
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    
    view.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);

    view.backgroundColor = [UIColor clearColor];
    _reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 380, 280, 40);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self presentViewController:_reader animated:YES completion:nil];
    
}

#pragma mark -- 二维码扫描点击取消
- (void)btnClick
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [_reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 扫到二维码

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
  
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        
        break;
    
    [_reader dismissViewControllerAnimated:YES completion:^{
        
        [self codeBunld:symbol.data];
        
    }];    
   
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}

#pragma mark -- 二维码 横条动画
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

#pragma mark -- 二维码连线消息

- (void)codeBunld:(NSString *)imeiString
{
    ModelView *modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:modelView];
    
    if(_model == nil)
    {
        _model = [[ApplyFamilyModel alloc]init];
    }
    
    [_model applyCodeConnection:imeiString codeBlock:^(int isSucceed)
    {
        [modelView removeFromSuperview];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (isSucceed == 0)
        {
            [defaults setObject:@"0" forKey:kAppStation];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if (isSucceed == 1)
        {
            Alert(@"主人,请请扫描正确的家人连线的二维码哦");
            [defaults setObject:nil forKey:kAppStation];
        }
        else if (isSucceed == 2)
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
            [defaults setObject:nil forKey:kAppStation];
        }
        else
        {
            Alert(@"主人,网络好像不给力啊,检查一下网络吧");
            [defaults setObject:nil forKey:kAppStation];
        }
        [defaults synchronize];
    }];
}

#pragma mark -- 收起键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accountIDTextFeild resignFirstResponder];
    [self.phoneTextFeild resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
