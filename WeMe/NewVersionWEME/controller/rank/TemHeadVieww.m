//
//  TemHeadViewy.m
//  微密
//
//  Created by APP on 15/5/23.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "TemHeadVieww.h"

@implementation TemHeadVieww

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.itemValueLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.distanceTaskLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.precentLabel.font = [UIFont boldSystemFontOfSize:13.0];
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    ImageViewCorner(_headImageView);
    ImageViewCorner(self.bottomView);
}

- (void)fileDataWithData:(NSDictionary *)dic
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    _itemValueLabel.text = [NSString stringWithFormat:@"%@",dic[@"rochelle"]==nil?@"0":dic[@"rochelle"]];
    _distanceTaskLabel.text = [NSString stringWithFormat:@"%@",dic[@"nextRochelle"]==nil?@"0":dic[@"nextRochelle"]];
    _precentLabel.text = [NSString stringWithFormat:@"%@",dic[@"present"]==nil?@"0":dic[@"present"]];
    _nickNameLabel.text = [PersonInfo sharePersonInfo].nicknameString;
    self.gredeAndTitleLabel.text = [NSString stringWithFormat:@"LV%@ %@",[PersonInfo sharePersonInfo].grade==nil?@"0":[PersonInfo sharePersonInfo].grade,[PersonInfo sharePersonInfo].gradeTitle.length==0?@"微密新手":[PersonInfo sharePersonInfo].gradeTitle];;
}
@end
