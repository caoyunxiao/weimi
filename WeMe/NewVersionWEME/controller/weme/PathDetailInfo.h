//
//  PathDetailInfo.h
//  微密
//
//  Created by longlz on 14-7-23.
//  Copyright (c) 2014年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathDetailInfo : NSObject

//驾驶城市
@property(copy,nonatomic)NSString *cityGradeString;
//时长评分
@property(copy,nonatomic)NSString *timeGradeString;

//超速情况
@property(copy,nonatomic)NSString *isSpeedGradeString;
//驾驶天气
@property(copy,nonatomic)NSString *habitGradeString;
//里程分布
@property(copy,nonatomic)NSString *travelGradeString;
//道路等级
@property(copy,nonatomic)NSString *roadInfoGradeString;
//驾驶速度
@property(copy,nonatomic)NSString *speedGradeString;
//车辆姿态
@property(copy,nonatomic)NSString *gsensorGradeString;

@property(copy,nonatomic)NSString *travelIDString;

@end
