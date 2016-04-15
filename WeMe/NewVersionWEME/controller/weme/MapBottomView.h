//
//  MapBottomView.h
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathDetailInfo.h"

@interface MapBottomView : UIView


@property (strong, nonatomic) IBOutlet UILabel *isSpeedGradeLabel;

@property (strong, nonatomic) IBOutlet UILabel *routeInfoGradeLabel;

@property (strong, nonatomic) IBOutlet UILabel *cityGradeLabel;

@property (strong, nonatomic) IBOutlet UILabel *habitGradeLabel;

@property (strong, nonatomic) IBOutlet UILabel *travelGradeLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeGradeLable;

@property (strong, nonatomic) IBOutlet UILabel *gsensorGradeLabel;

@property (strong, nonatomic) IBOutlet UILabel *speedGradeLabel;


- (void)fillDetailData:(PathDetailInfo *)detailInfo;

@end
