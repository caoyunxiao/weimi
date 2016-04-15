//
//  ServiceViewCell.h
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerZFJModel.h"

@interface ServiceViewCell : UITableViewCell <UIAlertViewDelegate>

//设置数据
- (void)setUIViewWithMOdel:(ServerZFJModel *)model customType:(NSString *)customType;

@property (weak, nonatomic) IBOutlet UIImageView *SVImageView;
@property (weak, nonatomic) IBOutlet UILabel *SVName;
@property (weak, nonatomic) IBOutlet UILabel *SVBriefIntroduction;
@property (weak, nonatomic) IBOutlet UIButton *SVButton;
- (IBAction)SVButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *ImmediatelyUseButton;//马上使用

@end
