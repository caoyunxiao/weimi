//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <BaiduMapAPI/BMKAnnotationView.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : BMKAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;

@property (assign,nonatomic)BOOL   isClick;


@property (copy,nonatomic)NSString *speedString;

@property (copy,nonatomic)NSString *altitudeString;

@property (copy,nonatomic)NSString *gpsTimeString;

@property (copy,nonatomic)NSString *directionString;
@end
