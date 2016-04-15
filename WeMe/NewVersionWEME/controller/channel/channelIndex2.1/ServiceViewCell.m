//
//  ServiceViewCell.m
//  微密
//
//  Created by ZFJ on 15/8/5.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "ServiceViewCell.h"

@implementation ServiceViewCell

- (void)awakeFromNib
{
    self.ImmediatelyUseButton.layer.masksToBounds = YES;
    self.ImmediatelyUseButton.layer.cornerRadius = 5;
    self.ImmediatelyUseButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.ImmediatelyUseButton.layer.borderWidth = 1.0;
}

//设置数据
- (void)setUIViewWithMOdel:(ServerZFJModel *)model customType:(NSString *)customType
{
    
    [self.SVImageView setImageWithURLOfZFJ:model.defineLogo placeholderImage:[UIImage imageNamed:@"jiaotongtongxinfenxiang.png"]];
    self.SVName.text = model.defineName;
    self.SVBriefIntroduction.text = model.briefIntro;
    self.ImmediatelyUseButton.tag = 1250+[model.customType integerValue];
    if([model.customType isEqualToString:customType])
    {
        [self.ImmediatelyUseButton setTitle:@"已关联吐槽键" forState:UIControlStateNormal];
        [self.ImmediatelyUseButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.ImmediatelyUseButton setTitle:@"关联吐槽键" forState:UIControlStateNormal];
        [self.ImmediatelyUseButton setTitleColor:[UIColor colorWithRed:11/255.0 green:96/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)SVButton:(UIButton *)sender {

}



@end
