//
//  PathTableViewCell.h
//  微密
//
//  Created by longlz on 14-7-22.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathTravelInfo.h"

@interface PathTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) IBOutlet UILabel *startRoadLabel;

@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *endCityLabel;


@property (strong, nonatomic) IBOutlet UILabel *allMileageLabel;

@property (strong, nonatomic) IBOutlet UILabel *allTimeLabel;


@property (strong, nonatomic) IBOutlet UILabel *averageSpeedLabel;

@property (strong, nonatomic) IBOutlet UILabel *maxSeepdLabel;


@property (strong, nonatomic) IBOutlet UILabel *endRoadLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (strong, nonatomic) IBOutlet UILabel *dynamicMileageLabel;




- (void)fillData:(PathTravelInfo *)dataInfo;

@end
