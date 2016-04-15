//
//  SerViceViewController.h
//  微密
//
//  Created by MacDev on 15/3/26.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
#import <MapKit/MapKit.h>

@interface SerViceViewController : BasesViewController{
    NSInteger _startPage;
    NSInteger _pageCount;
    CLLocationManager * _locationManager;
    NSString *_longitude;
    NSString *_latitude;
}

@end
