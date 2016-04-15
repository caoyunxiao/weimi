//
//  MyAccountyViewController.h
//  微密
//
//  Created by mirrtalk on 15/6/8.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasesViewController.h"
#import <MapKit/MapKit.h>

@interface MyAccountyViewController : BasesViewController<CLLocationManagerDelegate>{
    
    NSMutableArray *_buttonArray;
    NSString * _longitude;
    NSString * _latitude;
    CLLocationManager * _locationManager;
}
- (IBAction)yuerAndZhangdanClick:(UIButton *)sender;

@end
