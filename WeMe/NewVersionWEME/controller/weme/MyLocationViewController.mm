//
//  MyLocationViewController.m
//  微密
//
//  Created by APP on 15/7/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "MyLocationViewController.h"
#import "MobClick.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
#import "TakePhotoView.h"
#import "CLLocation+YCLocation.h"
#import "BaiduPanoramaView.h"
#import "BaiduPanoUtils.h"

#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)

@interface MyLocationViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKPoiSearchDelegate>
{
    BMKMapView* _mapView;
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    CLLocationCoordinate2D coor;
}


@end

@implementation MyLocationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    [MobClick beginLogPageView:self.title];
    self.tabBarController.tabBar.hidden = YES;
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:self.title];
    //self.panoramaView.delegate = nil;
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    
    _panoramaView.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
 
    
    self.title  = @"我的位置";
    _isShowQuanJingMap = NO;
    _isFollowLocation = NO;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(requestData) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//暂停
    [self requestData];
    [self addRightBarButton];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-75)];
    [self.view addSubview:_mapView];
    [self customPanoView];
    [self.view bringSubviewToFront:self.mapChangeButton];
    [self.view bringSubviewToFront:self.refreshButton];
}

#pragma mark - 刷新界面
- (IBAction)refreshButton:(UIButton *)sender {
    [self requestData];
}

#pragma mark - 设置指南针和当前车速
-(void)setCurRoadUI
{
    NSInteger _altitudeInteger = [_altitude integerValue];
    self.directionImage.transform=CGAffineTransformMakeRotation(DegreesToRadians(_altitudeInteger)-DegreesToRadians(45));
    
    self.carSpeed.text = [NSString stringWithFormat:@"%@km/h",_speed];
    self.altitudeLabel.text = [NSString stringWithFormat:@"%@米",_altitude];
    self.timerLabel.text = [NSString stringWithFormat:@"更新时间:%@",[self getTimerFromString:_GPSTime]];
}

- (void)addRightBarButton
{
    //用定制的视图创建BarButtonItem
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _rightBtn.frame = CGRectMake(0, 0, 100, 30);
    [_rightBtn setTitle:@"追随" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(followButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
}
#pragma mark - 定时器事件
- (void)followButton
{
    if(_isFollowLocation)
    {
        [_timer setFireDate:[NSDate distantFuture]];//暂停
        [_rightBtn setTitle:@"跟随" forState:UIControlStateNormal];
    }
    else
    {
        //开始实时
        [_timer setFireDate:[NSDate distantPast]];//开始
        [_rightBtn setTitle:@"停止跟随" forState:UIControlStateNormal];
    }
    _isFollowLocation = !_isFollowLocation;
}

#pragma mark - 数据请求
- (void)requestData
{
    [RequestEngine getLocation:^(NSString *errorCode, NSDictionary *resultDic) {
        if ([errorCode isEqualToString:@"0"])
        {
            _GPSTime = [resultDic objectForKey:@"GPSTime"];
            _altitude = [resultDic objectForKey:@"altitude"];
            _direction = [resultDic objectForKey:@"direction"];
            _isOnline = [resultDic objectForKey:@"isOnline"];
            _latitude = [resultDic objectForKey:@"latitude"];
            _longitude = [resultDic objectForKey:@"longitude"];
            _speed = [resultDic objectForKey:@"speed"];
            _resultDict = resultDic;
            [self addAnnotationWithlongitude:resultDic];
            [self setCurRoadUI];
            //切换全景场景至指定的地理坐标
            CLLocationCoordinate2D test = CLLocationCoordinate2DMake(_latitude.floatValue,_longitude.floatValue);
            NSDictionary *testdic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_GPS);
            CLLocationCoordinate2D cll = BMKCoorDictionaryDecode(testdic);
            [_panoramaView setPanoramaWithLon:cll.longitude lat:cll.latitude];
        }
        else if([errorCode isEqualToString:@"-1"])
        {
            Alert(@"主人,请检查一下您的网络吧");
        }
        else
        {
            Alert(@"主人,网络不给力啊,请检查一下网络吧");
        }
        
    }];
}
#pragma  根据经纬度定位地理位置
- (void)addAnnotationWithlongitude:(NSDictionary *)resultDic
{
    CLLocationCoordinate2D test = CLLocationCoordinate2DMake(_latitude.floatValue,_longitude.floatValue);
    NSDictionary *testdic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D cll = BMKCoorDictionaryDecode(testdic);

    CLLocationCoordinate2D coordinate2D = {cll.latitude,cll.longitude};
    BMKCoordinateSpan span = {0.02f,0.02f};
    BMKCoordinateRegion  region = {coordinate2D,span};
    [_mapView setRegion:region];
    if (pointAnnotation)
    {
        [_mapView removeAnnotation:pointAnnotation];
    }
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = coordinate2D;
    [_mapView addAnnotation:pointAnnotation];

}

#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *annotationViewID = @"reNameMark";
    BMKAnnotationView *newAnnotation;
    if (newAnnotation==nil)
    {
        newAnnotation=[[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationViewID];
        newAnnotation.image=[UIImage imageNamed:@"dingweiMap"];
        TakePhotoView *takePhotoView=[[TakePhotoView alloc]initWithFrame:CGRectMake(0, 0, 210, 100) resultDict:_resultDict];
        BMKActionPaopaoView* test = [[BMKActionPaopaoView alloc]initWithCustomView:takePhotoView];
        ((BMKPinAnnotationView*)newAnnotation).paopaoView = test;
    }
    return newAnnotation;
}
#pragma mark - 地图切换
- (IBAction)mapChangeButton:(UIButton *)sender
{
    if(_isShowQuanJingMap)
    {
        //地图
        _rightBtn.hidden = NO;
        _panoramaView.hidden = YES;

        
        _mapView.hidden = NO;
        [self.mapChangeButton setImage:[UIImage imageNamed:@"mapOne"] forState:UIControlStateNormal];
    }
    else
    {
        //全景
        _rightBtn.hidden = YES;
        _panoramaView.hidden = NO;
        _mapView.hidden = YES;
        [self.mapChangeButton setImage:[UIImage imageNamed:@"mapTwo"] forState:UIControlStateNormal];
    }
    _isShowQuanJingMap = !_isShowQuanJingMap;
}

-(NSString *)getTimerFromString:(NSString *)GPSTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:GPSTime.integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timerStr = nil;
    if (date == nil) {
        timerStr = [dateFormatter stringFromDate:[NSDate date]];
    } else {
        timerStr = [dateFormatter stringFromDate:date];
    }
    return timerStr;
}

#pragma mark - 百度地图  全景地图
- (void)customPanoView
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    // key 为在百度LBS平台上统一申请的接入密钥ak 字符串
    _panoramaView = [[BaiduPanoramaView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-75) key:kBaiDuMapKey];
    NSLog(@"kBaiDuMapKey:%@",kBaiDuMapKey);
    _panoramaView.hidden = YES;
    // 为全景设定一个代理
    _panoramaView.delegate = self;
    [self.view addSubview:_panoramaView];
    // 设定全景的清晰度， 默认为middle
    [_panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    [_panoramaView setPanoramaHeading:0];
}

#pragma mark - panorama view delegate

- (void)panoramaWillLoad:(BaiduPanoramaView *)panoramaView {
    NSLog(@"panorama will load");
}

- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr {
    NSLog(@"panorama did load -> %@",jsonStr);
}


- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error {
    NSLog(@"panorama load failed");
}

- (void)panoramaView:(BaiduPanoramaView *)panoramaView overlayClicked:(NSString *)overlayId {
    NSLog(@"overlay %@ clicked ",overlayId);
}


//获取设备bound方法
BOOL isPortrait()
{
    UIInterfaceOrientation orientation = getStatusBarOritation();
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}
UIInterfaceOrientation getStatusBarOritation()
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return orientation;
}
CGRect getFixedScreenFrame()
{
    CGRect mainScreenFrame = [UIScreen mainScreen].bounds;
    #ifdef NSFoundationVersionNumber_iOS_7_1
    if(!isPortrait() && (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)) {
        mainScreenFrame = CGRectMake(0, 0, mainScreenFrame.size.height, mainScreenFrame.size.width);
    }
    #endif
    return mainScreenFrame;
}

- (void)dealloc
{
    [_panoramaView removeFromSuperview];
    _panoramaView = nil;
}

- (void)didReceiveMemoryWarning
{
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
