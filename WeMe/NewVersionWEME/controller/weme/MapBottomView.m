//
//  MapBottomView.m
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import "MapBottomView.h"

@implementation MapBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)fillDetailData:(PathDetailInfo *)detailInfo
{
    if (detailInfo != nil)
    {
        self.cityGradeLabel.text = detailInfo.cityGradeString;
        
        self.isSpeedGradeLabel.text = detailInfo.isSpeedGradeString;
        
        self.routeInfoGradeLabel.text = detailInfo.roadInfoGradeString;
        
        self.habitGradeLabel.text = detailInfo.habitGradeString;
        
        self.travelGradeLabel.text = detailInfo.travelGradeString;
        
        self.timeGradeLable.text = detailInfo.timeGradeString;
        
        self.gsensorGradeLabel.text = detailInfo.gsensorGradeString;
        self.speedGradeLabel.text = detailInfo.speedGradeString;
    }
}

@end
