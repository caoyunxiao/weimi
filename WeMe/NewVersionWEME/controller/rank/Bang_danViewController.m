//
//  Bang_danViewController.m
//  微密
//
//  Created by wemedev on 15/3/24.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "Bang_danViewController.h"
#import "MobClick.h"
#import "listModel.h"
#import "TemplateViewController.h"
#import "TaskSystemViewController.h"
#import "DayViewController.h"
#import "WeekViewController.h"
#import "MonthViewController.h"
#import "AchieveViewController.h"
#import "StarView.h"
#import "MyViewController.h"
#import "MoreWebViewController.h"
#import "FootTableViewController.h"
#import "ExpectedViewController.h"
#import "SetUserInfoViewController.h"
#import "LoginModel.h"
#import "myJumpButton.h"
#import "DetailWebViewController.h"
#import "AppDelegate.h"
#import "MyCustomAlertView.h"
#import "WEMECustomTableViewCell.h"
#import "PathTableViewController.h"


//static int getNotifyNum;
@interface Bang_danViewController ()<UIScrollViewDelegate,UMSocialUIDelegate,UMSocialDataDelegate,MyCustomAlertViewDelegate,UIAlertViewDelegate>
{
    listModel * _model;             //榜单获取到的数据
    NSDictionary * _picDic;         //存放图片的字典
    //NSDictionary * _dic;
    NSArray * _rankConfigArray;     //存放八个模块的数据源数组
    UIAlertView *_alertView;        //网络警告
    
    UIImageView * _oragneImageView; //进度条
    UIImageView * grayImageView;    //进度条灰色背景
    
    //UIAlertView * alertview;
    BOOL CustomUI;                  //判断是否需要调用customUI

}
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLable;//昵称
@property (weak, nonatomic) IBOutlet UILabel *rankLable;//LV8 道客车手
@property (weak, nonatomic) IBOutlet UIButton *allRankingButton;//全部排名
@property (weak, nonatomic) IBOutlet UIButton *monthRankingButton;//本月排名
@property (weak, nonatomic) IBOutlet UILabel *influenceIndexLable;//影响指数
@property (weak, nonatomic) IBOutlet UILabel *interactIndexLable;//参与指数
@property (weak, nonatomic) IBOutlet UILabel *closeIndexLable;//亲密指数
@property (weak, nonatomic) IBOutlet UILabel *meetIndexLable;//相遇指数
@property (weak, nonatomic) IBOutlet UILabel *footLable;//8个城市  12个热点  1000轨迹  237天  10000公里
@property (weak, nonatomic) IBOutlet UIView *backViews;
@property (weak, nonatomic) IBOutlet UIView *viewOne;//放进度条的view
@property (weak, nonatomic) IBOutlet UILabel *distanceShareLable;//距离下一等级多少share
@property (weak, nonatomic) IBOutlet UILabel *shareLable;//谢尔值
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;//等级说明
@property (nonatomic, strong) ModelView *modelView;
@property(nonatomic,assign)NSInteger scrollIndex;
/**
 *  提示更新的view
 */
@property(nonatomic,strong)UIAlertView *alertForNew;
@property(nonatomic,assign)NSInteger hideFunctionEnterCount;//隐藏广告方法进入次数

@end

@implementation Bang_danViewController

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    if([PersonInfo sharePersonInfo].isHaveShowFirstImage)
    {
        self.tabBarController.tabBar.hidden = NO;
    }
    if ([PersonInfo sharePersonInfo].needRefresh)
    {
        [self.scrollview headerBeginRefreshing];
        [PersonInfo sharePersonInfo].needRefresh = NO;
    }
    //获取版本号
    //NewRootViewController *rvc = [[NewRootViewController alloc]init];
    //[rvc GetEditionOfApp];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
    //getNotifyNum=0;
}

-(void)createCell{
    WEMECustomTableViewCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"WEMECustomTableViewCell" owner:self options:nil] firstObject];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    cell.frame=CGRectMake(0,240,self.view.frame.size.width, 45);
    cell.textLableContent.font = kLevelTwoFont;
    cell.textLableContent.textColor = kLevelTwoColor;
    cell.textLableContent.text =@"我的轨迹";
    cell.headImageView.image = [UIImage imageNamed:@"wm_one_traveling_track"];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toDetail)];
    tap.delegate=self;
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [cell addGestureRecognizer:tap];
    [self.scrollview addSubview:cell];


}
-(void)toDetail{
    //轨迹页面
    PathTableViewController * path = [[PathTableViewController alloc] init];
    [self.navigationController pushViewController:path animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createCell];
    self.scrollview.delegate=self;
    self.scrollview.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
     //[[UIDevice currentDevice] systemVersion]);
    //获取首页广告数据
    _adCountDownModels = [PersonInfo sharePersonInfo].adCountDownModels;
    if(_adCountDownModels.picUrl.length>0)
    {
        //设置广告界面
        [self setAdvertisementView];
    }
    else
    {
        [self getPushMessage];//获取头部消息
        BOOL isShow = [self getPersonInfo];//判断是否需要补充个人信息
        if(isShow)
        {
            [self dataRequestss];//判断是否绑定IMEI
        }
    }
    //#warning 请求数据 接口没有数据 封住--
    [self refreshList];
//    NSLog(@"[PersonInfo sharePersonInfo].senderUserHeadName:%@",[PersonInfo sharePersonInfo].senderUserHeadName);
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];//头像
    //通知刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshGetUserImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"refreshView" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkBind) name:CheckWeMeBind object:nil];
 
    [self uiConfigSystemMessageView];
//    self.scrollview.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);

    }

/**
 *  跳到appstore里更新
 */
-(void)goToAppStore{
    NSString *updateUrl=[UserDefaults objectForKey:appstoreUpdateUrlKey];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
}
#pragma mark 检测新版本
/**
 *  检查是否有新版本
 */
-(void)checkVersion{
    __weak typeof(self) selfvc=self;
    [Tool checkCurrentAPPIsLatestNew:^(BOOL isLatestNew,NSArray *releaseNote) {
        if (!isLatestNew) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MyCustomAlertView  *alert=[[MyCustomAlertView alloc]initWithXib];
                alert.delegate=selfvc;
                CGFloat w=selfvc.view.frame.size.width;
                CGFloat h=selfvc.view.frame.size.height;
                CGFloat tabeleViewHeight=[Tool getArrDataHeight:releaseNote font:[UIFont systemFontOfSize:12]];
                alert.frame=CGRectMake(w/2-w*0.8/2,h/2-(tabeleViewHeight+110)/2,w*0.8, tabeleViewHeight+110);
                alert.dataSource=releaseNote;
                
                [[[UIApplication sharedApplication].delegate window] addSubview:alert];
            });
        }
    }];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 头部系统消息界面
- (void)uiConfigSystemMessageView
{
    _systemMessageView = [[UIView alloc]init];
    _systemMessageView.alpha = 0.9;
    _systemMessageView.clipsToBounds = YES;
    [self.view addSubview:_systemMessageView];
    
    _systemMessageLabel = [[UILabel alloc]init];
    _systemMessageLabel.textAlignment = NSTextAlignmentCenter;
    [_systemMessageView addSubview:_systemMessageLabel];
}

#pragma mark - 设置广告界面
- (void)setAdvertisementView
{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    _advertisementView = [[UIView alloc]initWithFrame:self.view.frame];
    _advertisementView.clipsToBounds = YES;
    //**********************解决tabbar隐藏不了的情况***************开始
    [[[UIApplication sharedApplication].delegate window] addSubview:_advertisementView];
    //**********************解决tabbar隐藏不了的情况***************结束
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:_advertisementView.frame];
    
    [_advertisementView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    [imageView addGestureRecognizer:singleTap];
    [imageView setImageWithURLOfZFJ:_adCountDownModels.picUrl placeholderImage:nil];
    _myButton = [[[NSBundle mainBundle]loadNibNamed:@"myJumpButton" owner:self options:nil]lastObject];
    [_myButton addTarget:self action:@selector(hildAdvertisementView) forControlEvents:UIControlEventTouchUpInside];
    _myButton.frame = CGRectMake(ScreenWidth-58, 28, 50, 50);
    [_advertisementView addSubview:_myButton];
    
    _iTimer = [_adCountDownModels.seconds intValue];//设置广告显示时间
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimer) userInfo:nil repeats:YES];
    
}

#pragma mark - 大图点击事件
- (void)buttonpress:(UITapGestureRecognizer*)singleTap
{
    if(_adCountDownModels.markType==nil||_adCountDownModels.markType.length==0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_adCountDownModels.url]];
    }
    else if ([_adCountDownModels.markType isEqualToString:@"1"])//跳转到系统url
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_adCountDownModels.url]];
    }
    else if ([_adCountDownModels.markType isEqualToString:@"2"])//跳转到app的webview的url
    {
        DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
        dvc.titleName = _adCountDownModels.appName;
        dvc.urlStr = _adCountDownModels.url;
        [self.navigationController pushViewController:dvc animated:YES];
    }
    else if ([_adCountDownModels.markType isEqualToString:@"3"])//可分享
    {
        [self shareClickAction:_adCountDownModels];
    }
    else
    {
        //不做处理
    }
}

#pragma mark - 分享
- (void)shareClickAction:(MoreModely *)model
{
//    id<ISSContent> publishContent = [ShareSDK content:model.remark defaultContent:model.remark image:[ShareSDK imageWithUrl:model.picUrl] title:model.appName url:model.url description:model.remark mediaType:SSPublishContentMediaTypeNews];
//    
//    [ShareSDK showShareActionSheet:nil shareList:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions: nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
//     {
//         if (state == SSResponseStateSuccess)
//         {
//             //NSLog(@"分享成功");
//         }
//         else if (state == SSResponseStateFail)
//         {
//             //NSLog(@"分享失败,错误码:%d,错误描述:%@", (int)[error errorCode], [error errorDescription]);
//         }
//     }];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.picUrl]];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAPPKey
                                      shareText:[NSString stringWithFormat:@"分享内容  %@",model.remark]
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,nil]
                                       delegate:self];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        [MBProgressHUD showSuccess:@"主人分享成功!"];
//    }else{
//        [MBProgressHUD showError:@"主人分享失败!"];
//    }
}

#pragma mark - 隐藏广告视图显示主界面
- (void)hildAdvertisementView
{
    ++self.hideFunctionEnterCount;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
//    self.scrollview.frame=CGRectMake(0, 35, ScreenWidth, self.scrollview.frame.size.height);
//    self.navigationController.navigationBar.frame=CGRectMake(0, 20, ScreenWidth, 35);
    if(self.scrollview.bounds.origin.y<-64){
        self.scrollview.frame=CGRectMake(0, 35, ScreenWidth, self.scrollview.frame.size.height);
    }
    [UIView animateWithDuration:0.5 animations:^{
        _advertisementView.frame = CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0);
        [PersonInfo sharePersonInfo].isHaveShowFirstImage = YES;
    }];
    
    
    //检查是否有更新的版本
    if (self.hideFunctionEnterCount==1) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"checkAppVersion" object:nil];
        [self checkVersion];
    }
    
}

#pragma mark - 定时器事件
- (void)myTimer
{
    NSString *string = [NSString stringWithFormat:@"跳过%ds",_iTimer];
    _myButton.myJumpLabel.text = string;
    if (_iTimer == 0)
    {
        //进入主界面
        [self hildAdvertisementView];
    }
    else if(_iTimer == -1)
    {
        [_myTimer setFireDate:[NSDate distantFuture]];
        [self getPushMessage];//获取头部消息
        BOOL isShow = [self getPersonInfo];//判断是否需要补充个人信息
        if(isShow)
        {
            [self dataRequestss];//判断是否绑定IMEI
        }
    }
    _iTimer --;
}

#pragma mark -- 是否绑定微密
- (void)dataRequestss
{
    NSDictionary *dict = [LoginModel getIMEIAndPhone];
    BOOL isShow;
    if(dict!=nil)
    {
        NSString *imeiString= [dict objectForKey:@"imei"];
        NSString *phoneString= [dict objectForKey:@"phone"];
        if([imeiString isEqualToString:@"0"])
        {
            imeiString = @"";
        }
        [PersonInfo sharePersonInfo].IMEIString = imeiString;
        [PersonInfo sharePersonInfo].phoneString = phoneString;
        
        if([imeiString isEqualToString:@"0"]||imeiString.length!=15)
        {
           isShow = YES;
        }
        else
        {
            isShow = NO;
        }
    }
    else
    {
        isShow = YES;
    }
    if(isShow)
    {
        _alertBangDing = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主人,您还没有绑定微密哟,界面上的很多数据都是来自我们的微密终端,快快去绑定微密吧" delegate:self cancelButtonTitle:@"我要了解什么是微密" otherButtonTitles:@"带我去绑定吧",@"不了,我下次再去绑定吧",nil];
        [_alertBangDing show];
    }
}

#pragma mark - 获取用户信息
- (BOOL)getPersonInfo
{
    BOOL isShow = [LoginModel getUserInfo];
    if(!isShow)
    {
        SetUserInfoViewController *svc = [[SetUserInfoViewController alloc] init];
        svc.pressType = @"presentViewController";
        UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:svc];
        //[self presentViewController:nvc animated:YES completion:nil];
        [self.view.window.rootViewController presentViewController:nvc animated:YES completion:nil];

    }
    return isShow;
}

#pragma mark - 隐藏系统提示视图
- (void)hildView
{
    [UIView animateWithDuration:2.0 animations:^{
        _systemMessageView.frame = CGRectMake(0, 64, ScreenWidth, 0);
    }];
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - alertView代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //去更新
    if (alertView==self.alertForNew&&buttonIndex==1) {
        NSString *updateUrl=[UserDefaults objectForKey:appstoreUpdateUrlKey];
        if (updateUrl.length>0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
        }else{
            [MBProgressHUD showError:@"主人跳转到更新页面出错啦!"];
        }
        return;
    }else if(alertView==self.alertForNew&&buttonIndex==0){
        return;
    }
    
    if (buttonIndex ==1)
    {
        MyViewController * vc = [[MyViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (buttonIndex == 0&&alertView.tag!=999)
    {
        MoreWebViewController * vc = [[MoreWebViewController alloc]init];
         vc.Moretitle = @"微密";
        vc.url = @"http://item.m.jd.com/product/1553794.html";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}
#pragma mark --刷新控件--
- (void)refreshList
{
    [self.scrollview addHeaderWithTarget:self action:@selector(headerRefreshList)];//头部刷新
    [_scrollview headerBeginRefreshing];

}
#pragma mark --下拉刷新--
- (void)headerRefreshList
{
    
    //[_tableView  headerEndRefreshing];
    if (!CustomUI) {
        
        [self customUI];
    }else{
        [self getListData];
    }
}
#pragma mark -- 重新刷新名字
- (void)refreshView
{
    _nickNameLable.text = [PersonInfo sharePersonInfo].nicknameString;
}

#pragma mark -- 重新刷新头像
- (void)refreshData
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
}
//请求数据+定制UI
- (void)customUI
{
    ////请求数据
    if([PersonInfo sharePersonInfo].isHaveShowFirstImage)
    {
        if (!_modelView) {
            _modelView = [[ModelView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:_modelView];
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [RequestEngine getRankCofig:^(NSString *errorcode, NSArray *rankCofigArray) {
        if([PersonInfo sharePersonInfo].isHaveShowFirstImage)
        {
            [_modelView removeFromSuperview];
            _modelView = nil;
        }
        if ([errorcode isEqualToString:@"0"]) {
            CustomUI = YES;//8个固定模块不用刷新了
            _rankConfigArray = rankCofigArray;
            [defaults setObject:_rankConfigArray forKey:[NSString stringWithFormat:@"rank%@",[PersonInfo sharePersonInfo].accountIDString]];
            [defaults synchronize];
        }else{
            //Alert(@"主人,请检查一下您的网络");
            if (!_alertView) {
                _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"主人,请检查下网络" delegate:nil cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
                [_alertView show];
            }
            _rankConfigArray = [defaults objectForKey:[NSString stringWithFormat:@"rank%@",[PersonInfo sharePersonInfo].accountIDString]];
        }
        [self uiConfig];
        [self getListData];
    }];
}
#pragma  获取榜单数据
- (void)getListData
{
    if([PersonInfo sharePersonInfo].isHaveShowFirstImage)
    {
        if (!_modelView) {
            _modelView = [[ModelView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:_modelView];
        }
    }
    [RequestEngine getList:^(NSString *errorCode, listModel *model) {
        [self.scrollview headerEndRefreshing];
        //[MBProgressHUD hideHUDForView:self.scrollview animated:YES];
        if([PersonInfo sharePersonInfo].isHaveShowFirstImage)
        {
            [_modelView removeFromSuperview];
            _modelView = nil;
        }
        if ([errorCode isEqualToString:@"0"])
        {
            _model = model;
            [self updateViewWithModel:model];
        }else{
            if (!_alertView) {
                _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"主人,请检查下网络" delegate:nil cancelButtonTitle:@"已阅" otherButtonTitles:nil, nil];
                [_alertView show];
            }
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
            //NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/screenshot"];
            
            NSString *imagePath = [path stringByAppendingFormat:@"/%@",@"a.data"];
            NSData *adata = [NSData dataWithContentsOfFile:imagePath];
            
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:adata];
            NSDictionary *dic = [unarchiver decodeObjectForKey:[NSString stringWithFormat:@"dicData%@",[PersonInfo sharePersonInfo].accountIDString]];
            [unarchiver finishDecoding];
            _model = [listModel getModelWithDic:dic];
            [self updateViewWithModel:_model];
            
        }
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}
#pragma 请求数据成功后刷新UI

- (void)updateViewWithModel:(listModel *)model
{
    _nickNameLable.text = [PersonInfo sharePersonInfo].nicknameString;
    _rankLable.text = [NSString stringWithFormat:@"LV%@ %@",model.grade==nil?@"0":model.grade,model.gradeTitle== nil?@"微密新手":model.gradeTitle];
    [_allRankingButton setTitle:[NSString stringWithFormat:@"全部谢尔排名 %@",model.allRanking == nil?@"":model.allRanking] forState:UIControlStateNormal];
    [_monthRankingButton setTitle:[NSString stringWithFormat:@"本月谢尔排名 %@",model.monthRanking == nil?@"":model.monthRanking] forState:UIControlStateNormal];
    _influenceIndexLable.text = [NSString stringWithFormat:@"%@",model.influenceIndex == nil?@"0":model.influenceIndex];
    
    _closeIndexLable.text = [NSString stringWithFormat:@"%@",model.closeIndex == nil?@"0":model.closeIndex];
    _meetIndexLable.text = [NSString stringWithFormat:@"%@",model.meetIndex == nil?@"0":model.meetIndex];
    _interactIndexLable.text = [NSString stringWithFormat:@"%@",model.interactIndex == nil?@"0":model.interactIndex];
    _footLable.text = [NSString stringWithFormat:@"%@个城市 %@个热点 %@条轨迹 %@天 %@公里",model.driverCityNum==nil?@"0":model.driverCityNum,model.driverHotNum==nil?@"0":model.driverHotNum,model.driverLocusNum==nil?@"0":model.driverLocusNum,model.driverDays==nil?@"0":model.driverDays,model.driverMileageSum==nil?@"0":model.driverMileageSum];
    _shareLable.text = [NSString stringWithFormat:@"%@",model.rochelle==nil?@"0":model.rochelle];
    _distanceShareLable.text = [NSString stringWithFormat:@"距离下一等级%@谢尔",model.nextGradeRochelle==nil?@"0":model.nextGradeRochelle];
    NSArray * dataArr = [NSArray arrayWithObjects:model.mileageCostTimeStar==nil?@"0":model.mileageCostTimeStar,model.mePointStar==nil?@"0":model.mePointStar,model.driverDaysMonthStar==nil?@"0":model.driverDaysMonthStar,model.addMileageSumStar==nil?@"0":model.addMileageSumStar,model.driverGradeStar==nil?@"0":model.driverGradeStar,model.environmentalIndexStar==nil?@"0":model.environmentalIndexStar,model.taskIndexStar==nil?@"0":model.taskIndexStar,@"3",nil];
    int i = 0;
    for (UIView *view in _backViews.subviews) {
        
        if (view.tag == 110+i) {
            StarView *starView = (StarView *)view;
            NSNumber * strNum = [dataArr objectAtIndex:i];
            float kStar = strNum.floatValue;
            
            [starView setStar:kStar];
            i++;
            if (i>=8) {
                break;
            }
        }
    }
    CGRect rect = _oragneImageView.frame;
    if (model.rochelle == nil||model.nextGradeRochelle == nil) {
        rect.size.width = 0;
    }else{
        rect.size.width = (230/([model.rochelle floatValue]+[model.nextGradeRochelle floatValue]))*([model.rochelle floatValue]);
        //rect.size.height = 14;

    }
    _oragneImageView.frame = rect;
}
#pragma mark - 设置UI界面
- (void)uiConfig
{
    self.title = @"榜单";
    ImageViewCorner(self.bottomView);
    ImageViewCorner(_headImageView);
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;

    self.scrollview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.scrollview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
    for (int i = 0; i<2; i++)
    {
        for (int j = 0; j<4; j++)
        {
            NSInteger num = i==0?j:j+4;
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(80*j, 71*i, 79, 70)];
            button.tag = num+30;
            [button addTarget:self action:@selector(templatebtnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            [_backViews addSubview:button];
            [_backViews sendSubviewToBack:button];
            UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(79*j+16, 41+i*72, 49, 21)];
            titleLable.textAlignment = NSTextAlignmentCenter;
            titleLable.font = [UIFont systemFontOfSize:12];
            //titleLable.text = [_dic objectForKey:[NSString stringWithFormat:@"%ld",num]];
            titleLable.text = _rankConfigArray[num][@"title"];
            [_backViews addSubview:titleLable];
            StarView * strView = [[StarView alloc]initWithFrame:CGRectMake(10+80*j, 20+68*i, 60, 20)];
            [strView setStar:0];
            strView.tag = num +110;
            strView.userInteractionEnabled = NO;
            [_backViews addSubview:strView];
            
        }
    }
    grayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 56, 230, 14)];
    grayImageView.layer.cornerRadius = 5;
    grayImageView.clipsToBounds = YES;
    grayImageView.backgroundColor = [UIColor grayColor];
    [_viewOne addSubview:grayImageView];
    /////进度条
    _oragneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 56, 0, 14)];
    _oragneImageView.layer.cornerRadius = 5;
    _oragneImageView.clipsToBounds = YES;
    _oragneImageView.image = [UIImage imageNamed:@"buttonone_normal.png"];
    [_viewOne addSubview:_oragneImageView];
}
#pragma 影响力 参与度
- (IBAction)buttonClick:(UIButton *)sender {
    UIAlertView *alert=nil;
    switch (sender.tag) {
        case 100:
            alert=[[UIAlertView alloc]initWithTitle:@"影响力" message:@"我分享的速度数据帮助的道客数" delegate:self cancelButtonTitle:@"秒懂" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case 101:
            alert=[[UIAlertView alloc]initWithTitle:@"参与度" message:@"我在微(主播)频道与主播互动的次数" delegate:self cancelButtonTitle:@"秒懂" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case 102:
            alert=[[UIAlertView alloc]initWithTitle:@"活跃度" message:@"我每天行驶大于10km的行程数" delegate:self cancelButtonTitle:@"秒懂" otherButtonTitles:nil, nil];
            [alert show];
            break;
        case 103:
            alert=[[UIAlertView alloc]initWithTitle:@"话唠值" message:@"我在+键、++键吐槽的总次数" delegate:self cancelButtonTitle:@"秒懂" otherButtonTitles:nil, nil];
            [alert show];
            break;
            
        default:
            break;
    }
    alert.tag=999;
}


#pragma mark -- 右侧点击函数-->分享
- (NSString *)screenshot
{
    if (&UIGraphicsBeginImageContextWithOptions != nil)
    {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    UIView *view = [[UIApplication sharedApplication].delegate window];
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/screenshot"];
    
    NSString *imagePath = [path stringByAppendingFormat:@"/%d.png",0];
    
    BOOL isDir= NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES])
    {
        return imagePath;   
    }
    return nil;
}
#pragma mark - 分享
-(void)rightButtonClick
{
    NSString *imagePath = [self screenshot];
//    id<ISSContent> publishContent = [ShareSDK content:@"主人,微密等你好久了,快点带我走吧,你就可以成为一名有身份的道客路况志愿者,还能获得免费的路况信息噢!" defaultContent:@"微密WEME-路上吐槽神器" image:[ShareSDK imageWithPath:imagePath] title:@"微密WEME-路上吐槽神器" url:@"http://open.daoke.me/shareLink" description:@"微密WEME-路上吐槽神器" mediaType:SSPublishContentMediaTypeNews];
//    [shareParams SSDKSetupShareParamsByText:@"主人,微密等你好久了,快点带我走吧,你就可以成为一名有身份的道客路况志愿者,还能获得免费的路况信息噢!" images:@[[UIImage imageWithContentsOfFile:imagePath]] url:[NSURL URLWithString:@"http://open.daoke.me/shareLink"] title:@"微密WEME-路上吐槽神器" type:SSDKContentTypeImage];
//    
//    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        if (state == SSDKResponseStateSuccess)
//        {
//            NSLog(@"分享成功");
//        }
//        else if (state == SSDKResponseStateFail)
//        {
//            NSLog(@"分享失败,错误描述:%@",error);
//        }
//    }];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAPPKey
                                      shareText:@"道客们，快来看看我去过的城市、热点和我的轨迹吧，是不是比你们多啊？哈哈"
                                     shareImage:[UIImage imageWithContentsOfFile:imagePath]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,nil]
                                       delegate:self];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];

//    [ShareSDK showShareActionSheet:nil shareList:nil content:shareParams statusBarTips:YES authOptions:nil shareOptions: nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        if (state == SSResponseStateSuccess)
//        {
//            //NSLog(@"分享成功");
//        }
//        else if (state == SSResponseStateFail)
//        {
//            //NSLog(@"分享失败,错误码:%d,错误描述:%@", (int)[error errorCode], [error errorDescription]);
//        }
//    }];
}

#pragma mark - 任务系统
- (IBAction)wemeTaskButton:(UIButton *)sender
{
    DayViewController *dayVc = [[DayViewController alloc] init];
    dayVc.taskInfoType = @"1";
    WeekViewController *weekVc = [[WeekViewController alloc] init];
    MonthViewController *monthVc = [[MonthViewController alloc] init];
    AchieveViewController *achieveVc = [[AchieveViewController alloc] init];
    weekVc.taskInfoType = @"2";
    monthVc.taskInfoType = @"3";
    achieveVc.taskInfoType = @"4";
    TaskSystemViewController *taskVc = [[TaskSystemViewController alloc] init];
    taskVc.viewControllers = @[dayVc,weekVc,monthVc,achieveVc];
    [self.navigationController pushViewController:taskVc animated:YES];
}
#pragma mark --全部排名,本月排名--
- (IBAction)rankButtonClick:(UIButton *)sender
{
    TemplateViewController *vc = [[TemplateViewController alloc] init];
    vc.titleName = sender.tag==600?@"全部谢尔排名":@"本月谢尔排名";
    vc.titleNum = sender.tag == 600?20:21;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark --达标用时,捐赠密点...--
- (void)templatebtnClick:(UIButton *)btn
{
    TemplateViewController * vc = [[TemplateViewController alloc]init];
    if ([_rankConfigArray[btn.tag-30][@"directionType"] isEqualToString:@"1"]) {
        vc.titleName = _rankConfigArray[btn.tag-30][@"title"];
        vc.titleNum = [_rankConfigArray[btn.tag-30][@"type"] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //NSLog(@"跳转到网址");
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:]];
        
//        ExpectedViewController *vc = [[ExpectedViewController alloc] init];
//        vc.strUrl =_rankConfigArray[btn.tag-30][@"url"];
//        vc.text = _rankConfigArray[btn.tag-30][@"title"];
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark --跳到我的足迹页面--
- (IBAction)footPrintClick:(UIButton *)sender
{
    FootTableViewController *vc = [[FootTableViewController alloc] init];
    vc.cityAndPointText = _footLable.text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取一条系统消息
- (void)getPushMessage
{
    NSDictionary * dateDic = @{@"accountID":[PersonInfo sharePersonInfo].accountIDString,@"messageType":@"systemMessage",@"pageNo":@"1",@"pageCount":@"1"};
    [RequestEngine getPushMessage:dateDic completed:^(NSString *errorCode, NSMutableArray *modelArr) {
        if([errorCode isEqualToString:@"0"])
        {
            NSDictionary *dict = [modelArr firstObject];
            NSString *colorType = [dict objectForKey:@"colorType"];
            NSString *textColor = [dict objectForKey:@"textColor"];
            NSString *content = [dict objectForKey:@"content"];
            if(content.length>0)
            {
                [self showSystemMessageWith:content colorType:colorType textColor:textColor];
                _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(hildView) userInfo:nil repeats:YES];
            }
        }
        else
        {
            //Alert(@"");
        }
    }];
}

#pragma mark - 展示系统提示消息
- (void)showSystemMessageWith:(NSString *)systemMessage colorType:(NSString *)colorType textColor:(NSString *)textColor
{
    NSArray *colorArr = [colorType componentsSeparatedByString:@"#"];
    NSArray *textColorArr = [textColor componentsSeparatedByString:@"#"];
    if(colorType==nil||colorArr.count!=3)
    {
        _systemMessageView.backgroundColor = [UIColor colorWithRed:250/255.0 green:179/255.0 blue:207/255.0 alpha:0.9];
    }
    else
    {
        float red = [colorArr[0] integerValue]/255.0;
        float green = [colorArr[1] integerValue]/255.0;
        float blue = [colorArr[2] integerValue]/255.0;
        _systemMessageView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.9];
    }
    if(textColor==nil||textColorArr.count!=3)
    {
        _systemMessageLabel.textColor = [UIColor blackColor];
    }
    else
    {
        float red = [textColorArr[0] integerValue]/255.0;
        float green = [textColorArr[1] integerValue]/255.0;
        float blue = [textColorArr[2] integerValue]/255.0;
        _systemMessageLabel.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }
    _systemMessageLabel.text = systemMessage;
    CGRect rect = [self dynamicHeight:systemMessage];
    _systemMessageLabel.frame = CGRectMake(0, 15, ScreenWidth, rect.size.height);
    _systemMessageView.frame = CGRectMake(0, 64, ScreenWidth, rect.size.height+30);
}

#pragma mark - 动态获取文本高度
- (CGRect)dynamicHeight:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(ScreenWidth-36, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 解决下拉出现ui上移的bug
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.scrollview.contentInset=UIEdgeInsetsMake(45, 0, 0, 0);

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //self.scrollview.contentInset=UIEdgeInsetsMake(45, 0, 0, 0);
}

#pragma mark 解决点击影响力、参与度、活跃度、话唠值出现的ui上移bug。
-(void)willPresentAlertView:(UIAlertView *)alertView{
    [self.scrollview setContentOffset:CGPointMake(0, -44) animated:NO];
}
/*
 红包界面去掉
- (IBAction)moneyRed:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"ReceiveRedMoneyViewController" bundle:nil];
    ReceiveRedMoneyViewController *receiveVc = [story instantiateInitialViewController];
    
    [self.navigationController pushViewController:receiveVc animated:YES];
    
}
 */
@end
