//
//  TemHeadViewy.m
//  微密
//
//  Created by APP on 15/5/20.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TemHeadViewx.h"

@implementation TemHeadViewx


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {//加粗
    // Drawing code
    self.mileageSumLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.itemValueLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.distanceTaskLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.precentLabel.font = [UIFont boldSystemFontOfSize:13.0];

}
#pragma 重写set方法
- (void)setCtlTitleText:(NSString *)ctlTitleText
{
    _ctlTitleText = ctlTitleText;
    self.ctlTitleLabel.text = [NSString stringWithFormat:@"%@:",_ctlTitleText];
}
- (void)setRankRuleText:(NSString *)rankRuleText
{
    if (rankRuleText.length == 0) {
        self.ctlDetailLabel.text = @"";
        self.ruleDetailLabel.text = @"";
    }else{
        NSArray *ary = [rankRuleText componentsSeparatedByString:@"|"];
       // NSLog(@"%@ %@",ary[0],ary[1]);
        self.ctlDetailLabel.text = ary[0];
        self.ruleDetailLabel.text = ary[1];
    }
    if ([_ctlTitleText isEqualToString:@"驾驶评分"]) {
        // 驾驶评分需要改变frame
        _backView.frame = CGRectMake(0, 135, 320, 64);
        
        _ctlDetailLabel.frame = CGRectMake(67, 5, 220, 20);
        
        _ruleLabel.frame = CGRectMake(18, 25, 50, 17);
        _ruleDetailLabel.frame = CGRectMake(67, 24, 220, 40);
        _topLabel.frame = CGRectMake(0, 198, 320, 21);
        _explainLabel.frame = CGRectMake(0, 217, 320, 16);
    }
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    ImageViewCorner(_headImageView);
    ImageViewCorner(self.bottomView);
}
- (void)fileDataWithData:(RankModel *)model
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    self.itemValueLabel.text = [NSString stringWithFormat:@"%@",model.itemValue==nil?@"0":model.itemValue];
    self.distanceTaskLabel.text = [NSString stringWithFormat:@"%@",model.distanceTask==nil?@"0":model.distanceTask];
    self.precentLabel.text = [NSString stringWithFormat:@"%@",model.precent==nil?@"0":model.precent];
    
    self.gredeAndTitleLabel.text = [NSString stringWithFormat:@"LV%@ %@",[PersonInfo sharePersonInfo].grade==nil?@"0":[PersonInfo sharePersonInfo].grade,[PersonInfo sharePersonInfo].gradeTitle.length==0?@"微密新手":[PersonInfo sharePersonInfo].gradeTitle];
    
    self.nickNameLabel.text = [PersonInfo sharePersonInfo].nicknameString;
    float starCount = model.star==nil?0:model.star.floatValue;
    [self.starView setStar:starCount];
}

@end
