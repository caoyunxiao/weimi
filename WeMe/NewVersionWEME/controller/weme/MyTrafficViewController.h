//
//  MyTrafficViewController.h
//  微密
//
//  Created by ZFJ on 15/8/4.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "BasesViewController.h"
#import "SDDemoItemView.h"

@interface MyTrafficViewController : BasesViewController{
    
    NSTimer *_timer;
    SDDemoItemView *_demoView;
    CGFloat _progress;
    NSString *_threshold; //本月总量
    NSString *_sum_data;  //本月已用
    NSString *_unit;      //单位
}

@property (weak, nonatomic) IBOutlet UIScrollView *MyTrafficScrollView;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLabel;//本月总量
@property (weak, nonatomic) IBOutlet UILabel *sum_dataLabel;//本月已用
@property (weak, nonatomic) IBOutlet UIButton *RechargeBurron;//去兑换流量
@property (weak, nonatomic) IBOutlet UILabel *flowSet;//流量套餐

@end
