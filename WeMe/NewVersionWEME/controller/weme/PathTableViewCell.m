//
//  PathTableViewCell.m
//  微密
//
//  Created by longlz on 14-7-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "PathTableViewCell.h"
#import "PathTravelInfo.h"


@implementation PathTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}


- (void)fillData:(PathTravelInfo *)dataInfo
{
    if (![dataInfo.startCityNameString isEqualToString:dataInfo.endCityNameString])
    {
        self.endCityLabel.hidden = NO;
        self.endCityLabel.text = dataInfo.endCityNameString;
    }else
    {
        self.endCityLabel.hidden = YES;
    }
    self.cityLabel.text = dataInfo.startCityNameString;
    
    if (dataInfo.startRouteNameString == nil || [dataInfo.startRouteNameString isEqualToString:@""] || [dataInfo.startRouteNameString isEqualToString:@" "])
    {
        self.startRoadLabel.text = @"无名路";
    }else
    {
        self.startRoadLabel.text = dataInfo.startRouteNameString;
    }
    
    if (dataInfo.endRouteNameString == nil || [dataInfo.endRouteNameString isEqualToString:@""]  || [dataInfo.endRouteNameString isEqualToString:@" "])
    {
        self.endRoadLabel.text = @"无名路";
    }
    else
    {
        self.endRoadLabel.text = dataInfo.endRouteNameString;
    }
    
    NSRange range;
    range.location = 11;
    range.length = 5;
    
    NSString *startTimeString = [dataInfo.startTimeString substringWithRange:range];
    
    NSString *endTimeString =[dataInfo.endTimeString substringWithRange:range];
    
    if ([dataInfo.startTimeString length] < 16)
    {
        startTimeString = dataInfo.startTimeString;
    }
    if ([dataInfo.endTimeString length] < 16)
    {
        endTimeString = dataInfo.endTimeString;
    }
    
    self.startTimeLabel.text = startTimeString;
    
    self.endTimeLabel.text = endTimeString;
    
    float sumMileage = [dataInfo.sumMileageString floatValue];
    
    int sumKMMileageInt = (int)sumMileage;
    
    int sumMileageInt = (int)(sumMileage * 1000);
    
    if (sumKMMileageInt == 0)
    {
        self.allMileageLabel.text = [NSString stringWithFormat:@"%dm",sumMileageInt];
    }
    else
    {
        NSString *oneFirst = [NSString stringWithFormat:@"%.1f",sumMileage];
        NSArray *array = [oneFirst componentsSeparatedByString:@"."];
        NSInteger firstNum = [[array firstObject] integerValue];
        NSInteger secondNum = [[array lastObject] integerValue];
        if(secondNum>=5)
        {
            firstNum = firstNum + 1;
        }
        self.allMileageLabel.text = [NSString stringWithFormat:@"%ldkm",firstNum];
    }
        
    self.allTimeLabel.text = [NSString stringWithFormat:@"%@分钟",dataInfo.totalTimeString];
    
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%@km/h",dataInfo.averageSpeedString];
    
    self.maxSeepdLabel.text = [NSString stringWithFormat:@"%@km/h",dataInfo.maxSpeedString];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
