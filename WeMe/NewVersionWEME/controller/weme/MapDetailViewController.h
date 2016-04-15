//
//  MapDetailViewController.h
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathDetailInfo.h"
#import "BasesViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>

#pragma mark --
#pragma mark --  轨迹详细/地图

@interface MapDetailViewController : BasesViewController<BMKMapViewDelegate>

//@property(strong,nonatomic)MAMapView  *mapView;
@property(strong,nonatomic)BMKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *annotations;

@property(copy,nonatomic)NSString *travelIDString;

@property(strong,nonatomic)PathDetailInfo *detailInfo;

@property(assign,nonatomic)BOOL   isHidden;

@end
