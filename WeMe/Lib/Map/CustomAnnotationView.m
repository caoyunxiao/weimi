//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
#import <BaiduMapAPI/BMKAnnotationView.h>

#define kCalloutWidth   200.0
#define kCalloutHeight  110.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;


@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *altitudeLabel;
@property (nonatomic, strong) UILabel *gpsTimeLabel;
@property (nonatomic, strong) UILabel *directionLabel;

@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;



#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}


- (void)setSpeedString:(NSString *)speedString
{
    self.speedLabel.text = [NSString stringWithFormat:@"车速 : %@ km/h",speedString] ;
    _speedString = speedString;
}


- (void)setAltitudeString:(NSString *)altitudeString
{
    self.altitudeLabel.text =[NSString stringWithFormat:@"海拔: %@",altitudeString] ;
    _altitudeString = altitudeString;
}


- (void)setDirectionString:(NSString *)directionString
{
    self.directionLabel.text = [NSString stringWithFormat:@"方向角: %@",directionString];

    _directionString = directionString;
}

- (void)setGpsTimeString:(NSString *)gpsTimeString
{
    self.gpsTimeLabel.text = [NSString stringWithFormat:@"更新时间: %@",gpsTimeString];
    _gpsTimeString = gpsTimeString;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    if (selected)
    {
        if (!_isClick)
        {
            return;
        }
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2.5, 190, 20)];
            _speedLabel.backgroundColor = [UIColor clearColor];
            _speedLabel.textColor = [UIColor whiteColor];
            _speedLabel.text =[NSString stringWithFormat:@"车速 : %@ km/h",_speedString] ;
            [self.calloutView addSubview:_speedLabel];
            
            _altitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27.5, 100, 20)];
            _altitudeLabel.backgroundColor = [UIColor clearColor];
            _altitudeLabel.text = [NSString stringWithFormat:@"海拔: %@ 米",_altitudeString] ;
            _altitudeLabel.textColor = [UIColor whiteColor];
            [self.calloutView addSubview:_altitudeLabel];
            
            _directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 52.5, 100, 20)];
            _directionLabel.backgroundColor = [UIColor clearColor];
            
            if ([_directionString floatValue] < 0) {
                _directionLabel.text = @"方向角 : 停止";
            }else
            {
                _directionLabel.text = [NSString stringWithFormat:@"方向角 : %@ ",_directionString];
            }
            
            
            _directionLabel.textColor = [UIColor whiteColor];
            [self.calloutView addSubview:_directionLabel];
            
            _gpsTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 77.5, 190, 20)];
            _gpsTimeLabel.backgroundColor = [UIColor clearColor];
            _gpsTimeLabel.textColor = [UIColor whiteColor];
            _gpsTimeLabel.text =[NSString stringWithFormat:@"更新时间: %@",_gpsTimeString];
            [self.calloutView addSubview:_gpsTimeLabel];
        }
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f,30,30);
        
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 30, 30)];
        self.portraitImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.portraitImageView];
    }
    
    return self;
}

@end
