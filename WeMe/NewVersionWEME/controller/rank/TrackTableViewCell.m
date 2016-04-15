//
//  TrackTableViewCell.m
//  微密
//
//  Created by APP on 15/6/1.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TrackTableViewCell.h"
#define btnWith [UIScreen mainScreen].bounds.size.width/7
@implementation TrackTableViewCell
{
    NSCalendar *myCalendar;
    NSRange monthRange;
    int     currentDayIndexOfMonth;
    int     firstDayIndexOfWeek;
    NSDate *_currentDate;
    UIView *_view;
    UILabel *_currentMonth;
    
    NSArray *_array;
    //NSMutableArray *_tagArray;
    NSArray *_sumArray;
    
    NSString *_beginString;
    NSString *_endString;
    
}

//- (void)drawRect:(CGRect)rect
//{
//    _activityView = [[UIActivityIndicatorView alloc] init];
//    CGPoint center = self.contentView.center;
//    _activityView.center = center;
//    _activityView.color = [UIColor blackColor];
//    [_activityView startAnimating];
//    [self.contentView addSubview:_activityView];
//    _activityView.hidden = YES;
//}
- (void)awakeFromNib {
    // Initialization code
    // Do any additional setup after loading the view, typically from a nib.
    //初始化日历类，并设置日历类的格式是阳历 若想设置中国日历 设置为NSChineseCalendar
    //_activityView.hidden = YES;
    
    myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //设置每周的第一天从星期几开始  设置为 1 是周日，2是周一
    [myCalendar setFirstWeekday:1];
    //设置每个月或者每年的第一周必须包含的最少天数  设置为1 就是第一周至少要有一天
    [myCalendar setMinimumDaysInFirstWeek:1];
    //设置时区，不设置时区获取月的第一天和星期的第一天的时候可能会提前一天。
    [myCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:0]];
    //_currentDate = [NSDate date];
    //计算绘制日历需要的数据，我传入当前日期  输入月份或年不同的日期就能得到不同的日历。
    //[self calendarSetDate:_currentDate];
    for (int i = 0; i < 7; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(btnWith * (i%7), 30+5, 30, 15);
        if (i == 0)
        {
            label.text = @"日";
        }
        else if (i == 1)
        {
            label.text = @"一";
        }
        else if (i == 2)
        {
            label.text = @"二";
        }
        else if (i == 3)
        {
            label.text = @"三";
        }
        else if (i == 4)
        {
            label.text = @"四";
        }
        else if (i == 5)
        {
            label.text = @"五";
        }
        else if (i == 6)
        {
            label.text = @"六";
        }
        //label.backgroundColor = [UIColor yellowColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor blackColor];
        [self.contentView addSubview:label];
    }
    _currentMonth = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, btnWith*7-60, 30)];
    _currentMonth.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_currentMonth];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];//NSDateFormatter是用于在字符串和日期之间相互转换的类
    //    dateFormatter.dateFormat = @"yyyy-MM";
    //    NSString *strDate1 = [dateFormatter stringFromDate:_currentDate];//把日期转换成指定格式的字符串
    _currentMonth.text = [self getStringWithDate:_currentDate];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(1, 1, 90, 30);
    [leftBtn setTitle:@"上一月" forState:UIControlStateNormal];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(btnWith*7-90-1, 1, 90, 30);
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"下一月" forState:UIControlStateNormal];
    //leftBtn.backgroundColor = [UIColor greenColor];
    //rightBtn.backgroundColor = [UIColor greenColor];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
    //leftBtn.backgroundColor = [UIColor whiteColor];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateNormal];
    //rightBtn.backgroundColor = [UIColor whiteColor];
    leftBtn.tintColor = [UIColor blackColor];
    rightBtn.tintColor = [UIColor blackColor];
    [self.contentView addSubview:leftBtn];
    [self.contentView addSubview:rightBtn];
    if (_view) {
        [_view removeFromSuperview];
        _view = nil;
    }
    [self getMonthBeginAndEndWith:_currentDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)leftBtnClick:(UIButton *)sender
{
//    [_view removeFromSuperview];
//    _view = nil;
    _currentDate = [self getPriousorLaterDateFromDate:_currentDate withMonth:-1];
    
    [self getMonthBeginAndEndWith:_currentDate];
    //NSLog(@"%@",_currentDate);
}
- (void)rightBtnClick:(UIButton *)sender
{
//    [_view removeFromSuperview];
//    _view = nil;
    _currentDate = [self getPriousorLaterDateFromDate:_currentDate withMonth:1];
    
    [self getMonthBeginAndEndWith:_currentDate];
    //NSLog(@"%@",_currentDate);
}
-(void)calendarSetDate:(NSDate *)date
{
    /* 日历类里比较重要的三个方法
     -(NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
     该方法计算date所在的larger单位  里有几个  smaller单位。
     例如smaller为NSDayCalendarUnit，larger为NSMonthCalendarUnit则返回的nsrange的length为date所在的月里共有多少天。
     
     -(NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
     该方法计算date 所在的smaller单位 在 date所在的larger单位 里的位置，即第几位。
     例如smaller为NSDayCalendarUnit，larger为NSMonthCalendarUnit则返回的 nsUInteger为date是date所在的月里的第几天。
     
     -(BOOL)rangeOfUnit:(NSCalendarUnit)unit startDate:(NSDate *)datep interval:(NSTimeInterval )tip forDate:(NSDate *)date;
     若datep 和 tip 可计算，则方法返回YES，否则返回NO。当返回YES时，可从datep里得到date所在的 unit单位 的第一天。unit可以为 NSMonthCalendarUnit NSWeekCalendarUnit 等
     
     */
    
    
    //获取date所在的月的天数，即monthRange的length
    monthRange = [myCalendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:date];
    //NSLog(@"monthRange:%d,%d",monthRange.location,monthRange.length);
    //获取date在其所在的月份里的位置
    currentDayIndexOfMonth = (int)[myCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date]  ;
    //NSLog(@"currentIndex:%d",currentDayIndexOfMonth);
    
    NSTimeInterval interval;
    NSDate *firstDayOfMonth;
    //如果firstDayOfMonth和interval可计算，下边这个方法会返回YES，并且由firstDayOfMonth可得到date所在的设置的时间段（NSMonthCalendarUnit）里的第一天
    if ([myCalendar rangeOfUnit: NSMonthCalendarUnit startDate:&firstDayOfMonth interval:&interval forDate:date])
    {
        //NSLog(@"firstDayOfMonth---%@",firstDayOfMonth);
        //NSLog(@"interval----%f",interval);
    }
    //获取date所在月的第一天在其所在周的位置，即第几天。
    firstDayIndexOfWeek = (int)[myCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstDayOfMonth];
    
    //画按钮
    [self drawBtn];
    
}
-(void)drawBtn
{
    if(_view){
        [_view removeFromSuperview];
        _view = nil;
    }
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, 60, btnWith*7, 250)];
    //_view.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:_view];
    NSString *date1 = [self getStringWithDate:_currentDate];
    _currentMonth.text = date1;
    //为了方便计算按钮的frame，我的i没从0开始
    for (int i = firstDayIndexOfWeek - 1 ; i < monthRange.length + firstDayIndexOfWeek -1 ; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(btnWith* (i%7)+5, 40*(i/7), 30, 30);
        //btn.backgroundColor = [UIColor yellowColor];
        btn.tag = i + 2 - firstDayIndexOfWeek;
        if (i%7==0) {
            UIView *line= [[UIView alloc] initWithFrame:CGRectMake(0, 40*i/7, ScreenWidth, 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            [_view addSubview:line];
            
        }
        [btn setTitle:[NSString stringWithFormat:@"%d",i + 2 - firstDayIndexOfWeek ]
             forState:UIControlStateNormal];

        NSString *strDate = [self getStringWithDate:[NSDate date]];//把日期转换成指定格式的字符串
        if ([date1 isEqualToString:strDate]) {//看当前月是不是当前月
            if (btn.tag == [myCalendar ordinalityOfUnit:NSDayCalendarUnit
                                                 inUnit:NSMonthCalendarUnit
                                                forDate:[NSDate date]]) {
                //btn.backgroundColor = [UIColor redColor];
                [btn setTitle:@"今天" forState:UIControlStateNormal];
            }
        }
        [btn setTintColor:[UIColor blackColor]];
        [_view addSubview:btn];

        for (int i = 0; i<_array.count; i++) {
            if (btn.tag == [self getIntWithString:_array[i]]&&[_sumArray[i] integerValue]!=0) {
//                [btn setBackgroundImage:[UIImage imageNamed:@"chack.png"] forState:UIControlStateNormal];
//                [btn setTintColor:[UIColor whiteColor]];
//                [btn addTarget:self
//                        action:@selector(nslogBtnTag:)
//              forControlEvents:UIControlEventTouchUpInside];
//                btn.tag = 1000+i;
                
                UILabel *_popLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x, CGRectGetMinY(btn.frame), 1000, 30)];
                //_popLabel.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(btn.frame), 1000, 30);
                _popLabel.text = [NSString stringWithFormat:@"%dkm",[_sumArray[i] intValue]];
                //CGRect rect = [self dynamicHeight:_popLabel.text systemFontOfSize:8];
                _popLabel.frame = CGRectMake(btn.frame.origin.x-5, btn.frame.origin.y+20,40, 20);
                _popLabel.font = [UIFont systemFontOfSize:8];
                _popLabel.textAlignment = NSTextAlignmentCenter;
                _popLabel.textColor = [UIColor redColor];
                //_popLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                //_popLabel.layer.cornerRadius = 5;
                //_popLabel.layer.masksToBounds = YES;
                [_view addSubview:_popLabel];
                
            }
        }
        
        
    }
}
- (NSString *)getStringWithDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM";
    return [dateFormatter stringFromDate:date];
    
}
- (int)getIntWithString:(NSString *)str
{
    NSArray *ary = [str componentsSeparatedByString:@"-"];
    return [ary.lastObject intValue];
}
//- (NSDate *)getDateWithString:(NSString *)str
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    return [dateFormatter dateFromString:str];
//}
-(void)nslogBtnTag:(UIButton *)btn
{
    //NSLog(@"%@",_sumArray[btn.tag-1000]);
    btn.enabled = NO;
    UILabel *_popLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x, CGRectGetMinY(btn.frame), 1000, 30)];
    _popLabel.frame = CGRectMake(btn.frame.origin.x, CGRectGetMinY(btn.frame), 1000, 30);
    _popLabel.text = [NSString stringWithFormat:@"%@KM",_sumArray[btn.tag-1000]];
    CGRect rect = [self dynamicHeight:_popLabel.text systemFontOfSize:8];
    _popLabel.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, rect.size.width, 20);
    _popLabel.font = [UIFont systemFontOfSize:8];
    
    _popLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _popLabel.layer.cornerRadius = 5;
    _popLabel.layer.masksToBounds = YES;
    [_view addSubview:_popLabel];
    [UIView animateWithDuration:1.0 animations:^{
        _popLabel.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y-20, rect.size.width, 20);
    } completion:^(BOOL finished) {
        btn.enabled = YES;
        [_popLabel removeFromSuperview];
    }];
}


-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

- (void)getMonthBeginAndEndWith:(NSDate *)newDate{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    _beginString = [myDateFormatter stringFromDate:beginDate];
    _endString = [myDateFormatter stringFromDate:endDate];
    
    //NSString *s = [NSString stringWithFormat:@"%@--------------------%@",_beginString,_endString];
    
    //NSLog(@"%@",s);
    _currentDate = beginDate;
    NSComparisonResult ret = [[NSDate date] compare:_currentDate];
    if (ret == NSOrderedAscending) {//当前日期小于 日历日期 不用请求
        _array = nil;
        _sumArray = nil;
        [self calendarSetDate:_currentDate];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _array  =[defaults objectForKey:[NSString stringWithFormat:@"%@%@",[PersonInfo sharePersonInfo].accountIDString,_beginString]];
        _sumArray = [defaults objectForKey:[NSString stringWithFormat:@"Sum%@%@",[PersonInfo sharePersonInfo].accountIDString,_beginString]];
        if (_array && _sumArray) {
            //直接用
            
            [self calendarSetDate:_currentDate];
            
        }else{
            if (_activityView) {
                [_activityView removeFromSuperview];
            }
                _activityView = [[UIActivityIndicatorView alloc] init];
                CGPoint center = self.contentView.center;
                _activityView.center = center;
                _activityView.color = [UIColor blackColor];
                [_activityView startAnimating];
                [self.contentView addSubview:_activityView];
            [RequestEngine getSumMileageListWithBeginDate:_beginString andEndDate:_endString complete:^(NSString *errorCode, NSArray *dateTimeArray, NSArray *sumMileageArray) {
                [_activityView removeFromSuperview];
                //_activityView.hidden = YES;
                _array = dateTimeArray;
                _sumArray = sumMileageArray;
                [self calendarSetDate:_currentDate];
                if (!_array && !_sumArray) {
                    _array = @[];
                    _sumArray = @[];
                }
                [defaults setObject:_array forKey:[NSString stringWithFormat:@"%@%@",[PersonInfo sharePersonInfo].accountIDString,_beginString]];
                [defaults setObject:_sumArray forKey:[NSString stringWithFormat:@"Sum%@%@",[PersonInfo sharePersonInfo].accountIDString,_beginString]];
                [defaults synchronize];
            }];
        }
    }
}
-(CGRect)dynamicHeight:(NSString *)str systemFontOfSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}
@end
