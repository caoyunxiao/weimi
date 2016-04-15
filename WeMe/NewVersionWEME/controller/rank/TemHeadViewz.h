//
//  TemHeadViewz.h
//  微密
//
//  Created by APP on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
@interface TemHeadViewz : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *gredeAndTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rochelleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rochelleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;//击败用户
@property (weak, nonatomic) IBOutlet UILabel *precentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankRuleTextLabel;//规则
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet StarView *starView;
@end
