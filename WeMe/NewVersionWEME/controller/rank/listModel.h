//
//  listModel.h
//  微密
//
//  Created by MacDev on 15/4/13.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface listModel : NSObject
@property(nonatomic,copy)NSString * accountID;//用户accountID
@property(nonatomic,copy)NSString * grade;//用户等级
@property(nonatomic,copy)NSString * gradeTitle;//等级名称
@property(nonatomic,copy)NSString * rochelle;//谢尔值
@property(nonatomic,copy)NSString * nextGradeRochelle;//距离下一等级谢尔值
@property(nonatomic,copy)NSString * allRanking;//全部道客用户谢尔值排名
@property(nonatomic,copy)NSString * monthRanking;//全部道客用户本月排名
@property(nonatomic,copy)NSString * influenceIndex;//影响指数
@property(nonatomic,copy)NSString * closeIndex;//亲密值数
@property(nonatomic,copy)NSString * interactIndex;//参与指数据
@property(nonatomic,copy)NSString * meetIndex;//相遇指数
@property(nonatomic,copy)NSString * addMileageSum;//新增里程
@property(nonatomic,copy)NSString * mileageCostTime;//达标用时
@property(nonatomic,copy)NSString * mePoint;//捐献密点
@property(nonatomic,copy)NSString * driverDaysMonth;//当月驾驶天数
@property(nonatomic,copy)NSString * driverGrade;//驾驶评分
@property(nonatomic,copy)NSString * tweetCount;//吐槽数
@property(nonatomic,copy)NSString * taskIndex;//任务指数
@property(nonatomic,copy)NSString * environmentalIndex;//环保指数
@property(nonatomic,copy)NSString * driverCityNum;//驾驶城市数
@property(nonatomic,copy)NSString * driverHotNum;//驾驶热点数
@property(nonatomic,copy)NSString * driverLocusNum;//轨迹数
@property(nonatomic,copy)NSString * driverDays;//总驾驶天数
@property(nonatomic,copy)NSString * driverMileageSum;//驾驶总里程数据

@property(nonatomic,copy)NSString * addMileageSumStar;//新增里程
@property(nonatomic,copy)NSString * mileageCostTimeStar;//达标用时
@property(nonatomic,copy)NSString * mePointStar;//捐献秘典
@property(nonatomic,copy)NSString * tweetCountStar;//吐槽数
@property(nonatomic,copy)NSString * environmentalIndexStar;//lI环保指数
@property(nonatomic,copy)NSString * taskIndexStar;//任务指数
@property(nonatomic,copy)NSString * driverGradeStar;//驾驶评分
@property(nonatomic,copy)NSString * driverDaysMonthStar;//当月驾驶天数




+(listModel *)getModelWithDic:(NSDictionary *)dic;
@end
