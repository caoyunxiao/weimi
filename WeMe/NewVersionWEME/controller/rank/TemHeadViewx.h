//
//  TemHeadViewy.h
//  微密
//
//  Created by APP on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
@interface TemHeadViewx : UIView
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *gredeAndTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageSumLabel;//1已行驶
@property (weak, nonatomic) IBOutlet UILabel *mileageSumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemValueLabel;//用时
@property (weak, nonatomic) IBOutlet UILabel *itemValueTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTaskLabel;//距离目标
@property (weak, nonatomic) IBOutlet UILabel *distanceTaskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;//击败用户
@property (weak, nonatomic) IBOutlet UILabel *precentTitleLabel;
@property (copy, nonatomic)NSString *rankRuleText;//规则
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (copy, nonatomic) NSString *ctlTitleText;
@property (weak, nonatomic) IBOutlet UILabel *ctlTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ctlDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ruleDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
- (void)fileDataWithData:(RankModel *)model;
@end
