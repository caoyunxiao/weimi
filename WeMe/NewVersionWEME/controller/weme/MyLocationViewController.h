//
//  MyLocationViewController.h
//  微密
//
//  Created by APP on 15/7/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "BaiduPanoramaView.h"

@interface MyLocationViewController : BasesViewController<BaiduPanoramaViewDelegate>{
    NSString *_GPSTime;
    NSString *_altitude;
    NSString *_direction;
    NSString *_isOnline;
    NSString *_latitude;
    NSString *_longitude;
    NSString *_speed;
    NSDictionary *_resultDict;
    NSTimer *_timer;    //时间控制器
    
    BaiduPanoramaView  *_panoramaView; //全景地图
    BOOL _isShowQuanJingMap;   //是否展示全景地图
    BOOL _isFollowLocation; //是否实时定位
    UIButton *_rightBtn;
}

@property (weak, nonatomic) IBOutlet UILabel *carSpeed;//车速
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;//海拔
@property (weak, nonatomic) IBOutlet UIImageView *directionImage;//指南针
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;//时间
@property (weak, nonatomic) IBOutlet UIButton *mapChangeButton;//地图切换
- (IBAction)mapChangeButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;//刷新按钮
- (IBAction)refreshButton:(UIButton *)sender;












@end
