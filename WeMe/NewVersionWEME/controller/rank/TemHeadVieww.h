//
//  TemHeadViewy.h
//  微密
//
//  Created by APP on 15/5/23.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
@interface TemHeadVieww : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *gredeAndTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemValueLabel;//用时
@property (weak, nonatomic) IBOutlet UILabel *itemValueTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTaskLabel;//距离目标
@property (weak, nonatomic) IBOutlet UILabel *distanceTaskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;//击败用户
@property (weak, nonatomic) IBOutlet UILabel *precentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet StarView *starView;
- (void)fileDataWithData:(NSDictionary *)dic;
@end
