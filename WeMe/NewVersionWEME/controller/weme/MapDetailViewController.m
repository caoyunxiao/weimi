//
//  MapDetailViewController.m
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "MapDetailViewController.h"
#import "TravelModel.h"
#import "MapBottomView.h"
#import "TravelInfo.h"
#import "CLLocation+YCLocation.h"
#import "CustomAnnotationView.h"
#import "MobClick.h"

@interface MapDetailViewController ()<UMSocialUIDelegate,UMSocialDataDelegate>
{
    MapBottomView *_bottomView;
    NSMutableArray *_overlays;
    ModelView *_modelView;
}
@end

@implementation MapDetailViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        self.title = @"轨迹";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick:)];
        
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [MobClick endLogPageView:self.title];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 164)];
    self.mapView.delegate = self;
    self.mapView.mapType = BMKMapTypeStandard;
    [self.view addSubview:self.mapView];
    
    
    self.mapView.showMapScaleBar = NO;
    self.mapView.showsUserLocation = NO;
    
    if (_bottomView == nil)
    {
        _bottomView = (MapBottomView *)[[[NSBundle mainBundle]loadNibNamed:@"MapBottomView" owner:self options:nil]lastObject];
        _bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 100, self.view.bounds.size.width, 100);
    }
    [_bottomView fillDetailData:_detailInfo];
    
    [self.view addSubview:_bottomView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.showsUserLocation = NO;
    
    if (_modelView == nil)
    {
        _modelView = [[ModelView alloc]initWithFrame:self.view.bounds];
    }

    [self.view addSubview:_modelView];
    
    TravelModel *model = [[TravelModel alloc]init];
    
    if (_detailInfo.travelIDString == nil)
    {
        [_modelView removeFromSuperview];
        return;
    }
    [model travelPathWithID:_detailInfo.travelIDString travels:^(NSMutableArray *travelPoints)
     {
         [_modelView removeFromSuperview];
         
         if ([travelPoints count] > 0)
         {
             [self initOverlays:travelPoints];
         }
     }];
}

- (void)initOverlays:(NSMutableArray *)points
{
    if (self.annotations == nil)
    {
        self.annotations = [NSMutableArray arrayWithCapacity:5];
    }else
    {
        [self.annotations removeAllObjects];
    }
    
    if (_overlays == nil)
    {
        _overlays = [[NSMutableArray alloc]init];
    }
    else
    {
        [_overlays removeAllObjects];
    }
    
    int locationCount = (int)[points count];
    
    CLLocationCoordinate2D polylineCoords[locationCount];
    
    CLLocationCoordinate2D  minCoordinate;
    CLLocationCoordinate2D  maxCoordinate;
    
    for (int i = 0; i < locationCount; i++)
    {
        TravelInfo *info = [points objectAtIndex:i];
        CLLocationCoordinate2D test = CLLocationCoordinate2DMake([info.latitudeString floatValue], [info.longitudeString floatValue]);
        ////////////////坐标转换
        NSDictionary* testdic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_COMMON);
        
        CLLocationCoordinate2D lo = BMKCoorDictionaryDecode(testdic);
        CLLocation *cll = [[[CLLocation alloc]initWithLatitude:lo.latitude longitude:lo.longitude] locationMarsFromEarth];
        //////////////////////
//        CLLocation *cll = [[[CLLocation alloc]initWithLatitude:[info.latitudeString floatValue] longitude:[info.longitudeString floatValue]] locationMarsFromEarth];
        
        polylineCoords[i].latitude = cll.coordinate.latitude;
        polylineCoords[i].longitude = cll.coordinate.longitude;
        
        if (i == 0)
        {
            BMKPointAnnotation *red = [[BMKPointAnnotation alloc] init];
            red.coordinate = polylineCoords[i];
            [self.annotations insertObject:red atIndex:0];
            minCoordinate = polylineCoords[i];
            maxCoordinate = polylineCoords[i];
        }
        else if (i == locationCount - 1)
        {
            BMKPointAnnotation *red = [[BMKPointAnnotation alloc] init];
            red.coordinate =polylineCoords[i];;
            [self.annotations insertObject:red atIndex:1];
            
            if (minCoordinate.latitude > polylineCoords[i].latitude)
            {
                minCoordinate.latitude = polylineCoords[i].latitude;
            }
            if (minCoordinate.longitude > polylineCoords[i].longitude)
            {
                minCoordinate.longitude = polylineCoords[i].longitude;
            }
            
            if (maxCoordinate.latitude < polylineCoords[i].latitude)
            {
                maxCoordinate.latitude = polylineCoords[i].latitude;
            }
            if (maxCoordinate.longitude < polylineCoords[i].longitude)
            {
                maxCoordinate.longitude = polylineCoords[i].longitude;
            }
            
        }else
        {
            if (minCoordinate.latitude > polylineCoords[i].latitude)
            {
                minCoordinate.latitude = polylineCoords[i].latitude;
            }
            if (minCoordinate.longitude > polylineCoords[i].longitude)
            {
                minCoordinate.longitude = polylineCoords[i].longitude;
            }
            
            if (maxCoordinate.latitude < polylineCoords[i].latitude)
            {
                maxCoordinate.latitude = polylineCoords[i].latitude;
            }
            if (maxCoordinate.longitude < polylineCoords[i].longitude)
            {
                maxCoordinate.longitude = polylineCoords[i].longitude;
            }
        }
    }
    
    BMKCoordinateRegion region;
    
    CLLocationCoordinate2D center;
    
    center.latitude = minCoordinate.latitude + (maxCoordinate.latitude - minCoordinate.latitude) * 0.5;
    center.longitude = minCoordinate.longitude + (maxCoordinate.longitude - minCoordinate.longitude) * 0.5;
    
    region.center = center;
    
    BMKCoordinateSpan span;
    
    span.latitudeDelta = maxCoordinate.latitude - minCoordinate.latitude;
    span.longitudeDelta = maxCoordinate.longitude - minCoordinate.longitude;
    
    region.span = span;
    
    [self.mapView setRegion:region];
    
    [self.mapView addOverlay:[BMKPolyline polylineWithCoordinates:polylineCoords count:locationCount]];
    [self.mapView addAnnotations:self.annotations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.mapView.visibleMapRect = BMKMapRectMake(23.178189, 113.491618, 1000000, 1000000);
}


- (void)setTravelID:(NSString *)travelID
{
    
}

- (void)setDetailInfo:(PathDetailInfo *)detailInfo
{
    _travelIDString = [detailInfo.travelIDString copy];
    
    _detailInfo = detailInfo;
}


- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView *polylineRenderer = [[BMKPolylineView alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 5.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:79/255.0 green:140/255.0 blue:232/255.0 alpha:1];
        return polylineRenderer;
    }
    
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        if ([self.annotations indexOfObject:annotation] == 0)
        {
            annotationView.portrait = [UIImage imageNamed:@"endPoint.png"];
        }
        else if([self.annotations indexOfObject:annotation] == 1)
        {
            annotationView.portrait = [UIImage imageNamed:@"startPoint.png"];
        }
        return annotationView;
    }
    
    return nil;
}


//截地图
- (UIImage *)screenshotMap
{
    UIImage *screenImage = [self.mapView takeSnapshot:self.mapView.bounds];
    return screenImage;
}

//截地下图片
- (UIImage *)screenshotBot
{
    
    if (&UIGraphicsBeginImageContextWithOptions != nil)
    {
        UIGraphicsBeginImageContextWithOptions(_bottomView.bounds.size, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(_bottomView.bounds.size);
    }
    
    
    [_bottomView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//合并图片
- (NSString *)screenshotAll
{
    UIImage *image1 = [self screenshotMap];
    UIImage *image2 = [self screenshotBot];
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Library/screenshot"];
    
    
    NSString *imagePath = [path stringByAppendingString:@"/1.png"];
    
    
    CGSize mapSize = image1.size;
    
    CGSize bottomSize = image2.size;
    
    CGSize maxSize ;
    
    maxSize.width = mapSize.width;
    maxSize.height = mapSize.height + bottomSize.height;
    UIGraphicsBeginImageContext(maxSize);
    
    [image1 drawInRect:CGRectMake(0, 0, mapSize.width, mapSize.height)];
    
    [image2 drawInRect:CGRectMake(0, mapSize.height, bottomSize.width, bottomSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    BOOL isDir= NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([UIImagePNGRepresentation(newImage) writeToFile:imagePath atomically:YES])
    {
        return imagePath;
    }
    return nil;
    
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"zoomLevel: %f",mapView.zoomLevel);
    
//    if (mapView.zoomLevel >= 16.0)
//    {
//        [mapView setZoomLevel:16.0];
//    }
    
}

- (void)saveClick:(id)sender
{
    
    NSString *imagePath = [self screenshotAll];

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMAPPKey
                                      shareText:@"道客悬赏令#这是一个路上的时代，我们已经把所有的奖金放在了路上，等着你去发掘。速度，激情，力量，想要吗？微密可以全部给你，上路吧，道客的时代已经来临。http://www.daoke.me"
                                     shareImage:[UIImage imageWithContentsOfFile:imagePath]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,nil]
                                       delegate:self];
    
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
//    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:@"#道客悬赏令#这是一个路上的时代，我们已经把所有的奖金放在了路上，等着你去发掘。速度，激情，力量，想要吗？微密可以全部给你，上路吧，道客的时代已经来临。" images:@[[UIImage imageWithContentsOfFile:imagePath]] url:[NSURL URLWithString:@"http://www.daoke.me"] title:@"道客分享" type:SSDKContentTypeImage];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
@end
