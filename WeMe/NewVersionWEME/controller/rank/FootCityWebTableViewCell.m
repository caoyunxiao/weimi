//
//  FootCityWebTableViewCell.m
//  微密
//
//  Created by APP on 15/6/3.
//  Copyright (c) 2015年 longlz. All rights reserved.
//

#import "FootCityWebTableViewCell.h"

@implementation FootCityWebTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    //[self requestData];
    [self reloadData];
    ImageViewCorner(_headImageView);
}
- (void)reloadData
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[PersonInfo sharePersonInfo].senderUserHeadName] placeholderImage:[UIImage imageNamed:@"girl.jpg"]];
    _nickName.text = [PersonInfo sharePersonInfo].nicknameString==nil?@"无昵称":[PersonInfo sharePersonInfo].nicknameString;
    self.gradeAndTitle.text = [NSString stringWithFormat:@"LV%@ %@",[PersonInfo sharePersonInfo].grade==nil?@"0":[PersonInfo sharePersonInfo].grade,[PersonInfo sharePersonInfo].gradeTitle.length==0?@"微密新手":[PersonInfo sharePersonInfo].gradeTitle];
    
    
    _sexImageView.image = [[NSString stringWithFormat:@"%@",[PersonInfo sharePersonInfo].sexString] isEqualToString:@"1"]?[UIImage imageNamed:@"boy.png"]:[UIImage imageNamed:@"girl.png"];//性别图片
    _cityAndPointLabel.text = self.cityAndPointText;
    CGRect rect = [self dynamicHeight:_nickName.text systemFontOfSize:15];
    CGRect frame = _nickName.frame;
    _nickName.frame = CGRectMake(frame.origin.x, frame.origin.y, rect.size.width, rect.size.height);
    _sexImageView.frame = CGRectMake(CGRectGetMaxX(_nickName.frame)+2, frame.origin.y, 20, 20);
    
}


-(CGRect)dynamicHeight:(NSString *)str systemFontOfSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(2000,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
