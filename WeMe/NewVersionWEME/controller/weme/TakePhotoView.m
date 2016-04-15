//
//  TakePhotoView.m
//  DaokeClub
//
//  Created by WEME on 15/6/18.
//  Copyright (c) 2015年 Daoke Dev. All rights reserved.
//

#import "TakePhotoView.h"

@implementation TakePhotoView

- (instancetype)initWithFrame:(CGRect)frame resultDict:(NSDictionary *)resultDict
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10)];
        view.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [self addSubview:view];
        
        NSArray *titleArr = @[@"车速",@"海拔",@"方向角",@"更新时间"];
        NSString *speed = [NSString stringWithFormat:@"%@ km/h",[resultDict objectForKey:@"speed"]];
        NSString *altitude = [NSString stringWithFormat:@"%@米",[resultDict objectForKey:@"altitude"]];
        NSString *direction = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"direction"]];
        NSString *GPSTime = [self getTimerFromString:[resultDict objectForKey:@"GPSTime"]];
        NSArray *contentArr = @[speed,altitude,direction,GPSTime];
        for(int i=0;i<titleArr.count;i++)
        {
            float height = (self.frame.size.height-10)/titleArr.count;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, height*i, self.frame.size.width-5, height)];
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%@:%@",titleArr[i],contentArr[i]];
            [view addSubview:label];
        }
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-20)/2, self.frame.size.height-20+4, 20, 20)];
        image.image = [UIImage imageNamed:@"xiangxia"];
        [self addSubview:image];
        
    }
    return self;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
